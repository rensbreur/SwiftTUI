import Foundation

public extension View {
    func padding() -> some View {
        return Padding(content: self)
    }
}

private struct Padding<Content: View>: View, Primitive, ControlMapper {
    let content: Content

    init(content: Content) {
        self.content = content
    }

    static var size: Int? { Content.size }

    func buildNode(_ node: Node) {
        node.addNode(at: 0, Node(nodeBuilder: content.nodeBuilder))
    }

    func updateNode(_ node: Node) {
        node.nodeBuilder = self
        node.children[0].update(using: content.nodeBuilder)
    }

    func passControl(_ control: Control) -> Control {
        if let paddingControl = control.parent { return paddingControl }
        let paddingControl = PaddingControl()
        paddingControl.addSubview(control, at: 0)
        return paddingControl
    }

}

private class PaddingControl: Control {
    override func size(proposedSize: Size) -> Size {
        var proposedSize = proposedSize
        proposedSize.width -= 2
        proposedSize.height -= 2
        var size = children[0].size(proposedSize: proposedSize)
        size.width += 2
        size.height += 2
        return size
    }

    override func layout(size: Size) {
        var contentSize = size
        contentSize.width -= 2
        contentSize.height -= 2
        children[0].layout(size: contentSize)
        children[0].layer.frame.position = Position(column: 1, line: 1)
        self.layer.frame.size = size
    }

}
