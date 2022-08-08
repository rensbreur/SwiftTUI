import Foundation

public struct HStack<Content: View>: View, PrimitiveView, ViewContainer {
    public let content: Content

    public init(@ItemBuilder _ content: () -> Content) {
        self.content = content()
    }

    init(content: Content) {
        self.content = content
    }

    static var size: Int? { 1 }

    func loadData(node: Node) {
        for i in 0 ..< node.children[0].size {
            (node.control as! HStackControl).addSubview(node.children[0].control(at: i), at: i)
        }
    }

    func buildNode(_ node: Node) {
        node.addNode(at: 0, Node(viewWrapper: ViewWrapper(view: content)))
        node.control = HStackControl()
    }

    func updateNode(_ node: Node) {
        node.viewWrapper = ViewWrapper(view: self)
        node.children[0].update(using: ViewWrapper(view: content))
    }

    func insertControl(at index: Int, node: Node) {
        (node.control as! HStackControl).addSubview(node.children[0].control(at: index), at: index)
    }

    func removeControl(at index: Int, node: Node) {
        (node.control as! HStackControl).removeSubview(at: index)
    }

}

private class HStackControl: Control {
    override func size(proposedSize: Size) -> Size {
        var size: Size = .zero
        for view in children {
            size.height = max(size.height, view.size(proposedSize: proposedSize).height)
            size.width += view.size(proposedSize: proposedSize).width
        }
        return size
    }
    override func layout(size: Size) {
        var size: Size = .zero
        for view in children {
            view.layer.frame.position = Position(column: size.width, line: 0)
            view.layout(size: view.size(proposedSize: size))
            size.height = max(size.height, view.layer.frame.size.height)
            size.width += view.layer.frame.size.width
        }
        self.layer.frame.size = size
    }
    override func selectableElement(rightOf index: Int) -> Control? {
        var index = index + 1
        while index < children.count {
            if let element = children[index].firstSelectableElement {
                return element
            }
            index += 1
        }
        return super.selectableElement(rightOf: index)
    }
    override func selectableElement(leftOf index: Int) -> Control? {
        var index = index - 1
        while index >= 0 {
            if let element = children[index].firstSelectableElement {
                return element
            }
            index -= 1
        }
        return super.selectableElement(leftOf: index)
    }
}
