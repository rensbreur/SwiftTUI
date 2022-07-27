import Foundation

/// The node tree is the runtime representation of the views in an application.
/// Every view corresponds to a node. If a view is used in multiple places, in
/// each of the places it is used it will have a seperate node.
///
/// Once (a part of) the node tree is built, views can update the node tree, as
/// long as their type match. This is done by the views themselves.
///
/// Note that the control tree more closely resembles the layout hierarchy,
/// because structural views (ForEach, etc.) have their own node.
final class Node {
    var viewWrapper: AnyViewWrapper

    var control: Control?

    private(set) var parent: Node?
    private(set) var children: [Node] = []

    private(set) var index: Int = 0

    private(set) var built = false

    static var invalidatedNodes: [Node] = []

    var size: Int {
        if let size = type(of: viewWrapper).size { return size }
        build()
        return children.map(\.size).reduce(0, +)
    }

    init(viewWrapper: AnyViewWrapper) {
        self.viewWrapper = viewWrapper
    }

    func update(using viewWrapper: AnyViewWrapper) {
        build()
        viewWrapper.updateNode(self)
    }

    func build() {
        if !built {
            self.viewWrapper.buildNode(self)
            built = true
            if let container = viewWrapper as? ViewContainer {
                container.loadData(node: self)
            }
        }
    }

    // MARK: - Changing nodes

    func addNode(at index: Int, _ node: Node) {
        guard node.parent == nil else { fatalError("Node is already in tree") }
        children.insert(node, at: index)
        node.parent = self
        for i in index ..< children.count {
            children[i].index = i
        }
        if built {
            for i in 0 ..< node.size {
                node.insertControl(at: i)
            }
        }
    }

    func removeNode(at index: Int) {
        if built {
            for i in (0 ..< children[index].size).reversed() {
                children[index].removeControl(at: i)
            }
        }
        children[index].parent = nil
        children.remove(at: index)
        for i in index ..< children.count {
            children[i].index = i
        }
    }

    // MARK: - Container data source

    func control(at offset: Int) -> Control {
        build()
        if offset == 0, let control = self.control { return control }
        var i = 0
        for child in children {
            let size = child.size
            if (offset - i) < size {
                let control = child.control(at: offset - i)
                if let modifier = self.viewWrapper as? ControlMapper {
                    return modifier.passControl(control)
                }
                return control
            }
            i += size
        }
        fatalError("Out of bounds")
    }

    // MARK: - Container changes

    private func insertControl(at offset: Int) {
        if let container = viewWrapper as? ViewContainer {
            container.insertControl(at: offset, node: self)
            return
        }
        var offset = offset
        for i in 0 ..< index {
            offset += parent?.children[i].size ?? 0
        }
        parent?.insertControl(at: offset)
    }

    private func removeControl(at offset: Int) {
        if let container = viewWrapper as? ViewContainer {
            container.removeControl(at: offset, node: self)
            return
        }
        var offset = offset
        for i in 0 ..< index {
            offset += parent?.children[i].size ?? 0
        }
        parent?.removeControl(at: offset)
    }
}
