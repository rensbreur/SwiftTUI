import Foundation

public extension View {
    func background(_ color: Color) -> some View {
        return Background(content: self, color: color)
    }
}

private struct Background<Content: View>: View, PrimitiveView, ModifierView {
    let content: Content
    let color: Color

    static var size: Int? { Content.size }

    func buildNode(_ node: Node) {
        node.addNode(at: 0, Node(view: content.view))
    }

    func updateNode(_ node: Node) {
        node.view = self
        node.children[0].update(using: content.view)
    }

    func passControl(_ control: Control) -> Control {
        if let borderControl = control.parent { return borderControl }
        let borderControl = BackgroundControl(color: color)
        borderControl.addSubview(control, at: 0)
        return borderControl
    }

}

private class BackgroundControl: Control {
    var color: Color

    init(color: Color) {
        self.color = color
    }

    override func size(proposedSize: Size) -> Size {
        children[0].size(proposedSize: proposedSize)
    }

    override func layout(size: Size) {
        super.layout(size: size)
        children[0].layout(size: size)
    }

    override func cell(at position: Position) -> Cell? {
        Cell(char: " ", backgroundColor: color)
    }

}
