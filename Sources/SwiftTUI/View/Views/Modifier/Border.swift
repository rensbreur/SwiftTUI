import Foundation

public extension View {
    func border(_ color: Color? = nil) -> some View {
        return Border(content: self, color: color)
    }
}

private struct Border<Content: View>: View, PrimitiveView, ControlMapper {
    let content: Content
    let color: Color?
    @Environment(\.foregroundColor) var foregroundColor: Color

    static var size: Int? { ViewWrapper<Content>.size }

    func buildNode(_ node: Node) {
        node.addNode(at: 0, Node(viewWrapper: ViewWrapper(view: content)))
    }

    func updateNode(_ node: Node) {
        node.viewWrapper = ViewWrapper(view: self)
        node.children[0].update(using: ViewWrapper(view: content))
    }

    func passControl(_ control: Control) -> Control {
        if let borderControl = control.parent { return borderControl }
        let borderControl = BorderControl(color: color ?? foregroundColor)
        borderControl.addSubview(control, at: 0)
        return borderControl
    }

}

private class BorderControl: Control {
    var color: Color

    init(color: Color) {
        self.color = color
    }

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
    
    override var layoutPriority: Double { children[0].layoutPriority }

    override func cell(at position: Position) -> Cell? {
        var char: Character?
        if position.line == 0 {
            if position.column == 0 {
                char = "┌"
            } else if position.column == layer.frame.size.width - 1 {
                char = "┐"
            } else {
                char = "─"
            }
        } else if position.line == layer.frame.size.height - 1 {
            if position.column == 0 {
                char = "└"
            } else if position.column == layer.frame.size.width - 1 {
                char = "┘"
            } else {
                char = "─"
            }
        } else if position.column == 0 || position.column == layer.frame.size.width - 1 {
            char = "│"
        }
        return char.map { Cell(char: $0, foregroundColor: color) }
    }

}
