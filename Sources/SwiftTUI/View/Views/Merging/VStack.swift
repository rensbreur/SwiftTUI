import Foundation

public struct VStack<Content: View>: View, PrimitiveView, ViewContainer {
    public let content: Content

    public init(@ItemBuilder _ content: () -> Content) {
        self.content = content()
    }

    static var size: Int? { 1 }

    func loadData(node: Node) {
        for i in 0 ..< node.children[0].size {
            (node.control as! VStackControl).addSubview(node.children[0].control(at: i), at: i)
        }
    }

    func buildNode(_ node: Node) {
        node.addNode(at: 0, Node(viewWrapper: ViewWrapper(view: content)))
        node.control = VStackControl()
    }

    func updateNode(_ node: Node) {
        node.viewWrapper = ViewWrapper(view: self)
        node.children[0].update(using: ViewWrapper(view: content))
    }

    func insertControl(at index: Int, node: Node) {
        (node.control as! VStackControl).addSubview(node.control(at: index), at: index)
    }

    func removeControl(at index: Int, node: Node) {
        (node.control as! VStackControl).removeSubview(at: index)
    }

}

private class VStackControl: Control {
    override func size(proposedSize: Size) -> Size {
        var size: Size = .init(width: 0, height: 0)
        for view in children {
            size.width = max(size.width, view.size(proposedSize: proposedSize).width)
            size.height += view.size(proposedSize: proposedSize).height
        }
        return size
    }
    override func layout(size: Size) {
        var size: Size = .init(width: 0, height: 0)
        for view in children {
            view.layer.frame.position = Position(column: 0, line: size.height)
            view.layout(size: view.size(proposedSize: size))
            size.width = max(size.width, view.layer.frame.size.width)
            size.height += view.layer.frame.size.height
        }
        self.layer.frame.size = size
    }
    override func selectableElement(below index: Int) -> Control? {
        var index = index + 1
        while index < children.count {
            if let element = children[index].firstSelectableElement {
                return element
            }
            index += 1
        }
        return super.selectableElement(below: index)
    }
    override func selectableElement(above index: Int) -> Control? {
        var index = index - 1
        while index >= 0 {
            if let element = children[index].firstSelectableElement {
                return element
            }
            index -= 1
        }
        return super.selectableElement(above: index)
    }
}
