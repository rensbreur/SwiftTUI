import Foundation
#if os(macOS)
import Combine
#endif

/// The node of a view graph.
///
/// The view graph is the runtime representation of the views in an application.
/// Every view corresponds to a node. If a view is used in multiple places, in
/// each of the places it is used it will have a seperate node.
///
/// Once (a part of) the node tree is built, views can update the node tree, as
/// long as their type match. This is done by the views themselves.
///
/// Note that the control tree more closely resembles the layout hierarchy,
/// because structural views (ForEach, etc.) have their own node.
final class Node {
    var view: GenericView

    var state: [String: Any] = [:]
    var environment: ((inout EnvironmentValues) -> Void)?
    #if os(macOS)
    var subscriptions: [String: AnyCancellable] = [:]
    #endif

    var control: Control?
    weak var application: Application?

    /// For modifiers only, references to the controls
    var controls: WeakSet<Control>?

    private(set) var parent: Node?
    private(set) var children: [Node] = []

    private(set) var index: Int = 0

    private(set) var built = false

    init(view: GenericView) {
        self.view = view
    }

    func update(using view: GenericView) {
        build()
        view.updateNode(self)
    }

    var root: Node { parent?.root ?? self }

    /// The total number of controls in the node.
    /// The node does not need to be fully built for the size to be computed.
    var size: Int {
        if let size = type(of: view).size { return size }
        build()
        return children.map(\.size).reduce(0, +)
    }

    /// The number of controls in the parent node _before_ the current node.
    private var offset: Int {
        var offset = 0
        for i in 0 ..< index {
            offset += parent?.children[i].size ?? 0
        }
        return offset
    }

    func build() {
        if !built {
            self.view.buildNode(self)
            built = true
            if !(view is OptionalView), let container = view as? LayoutRootView {
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
                insertControl(at: node.offset + i)
            }
        }
    }

    func removeNode(at index: Int) {
        if built {
            for i in (0 ..< children[index].size).reversed() {
                removeControl(at: children[index].offset + i)
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
                if !(view is OptionalView), let modifier = self.view as? ModifierView {
                    return modifier.passControl(control, node: self)
                }
                return control
            }
            i += size
        }
        fatalError("Out of bounds")
    }

    // MARK: - Container changes

    private func insertControl(at offset: Int) {
        if !(view is OptionalView), let container = view as? LayoutRootView {
            container.insertControl(at: offset, node: self)
            return
        }
        parent?.insertControl(at: offset + self.offset)
    }

    private func removeControl(at offset: Int) {
        if !(view is OptionalView), let container = view as? LayoutRootView {
            container.removeControl(at: offset, node: self)
            return
        }
        parent?.removeControl(at: offset + self.offset)
    }
}
