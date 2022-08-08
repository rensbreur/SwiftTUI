import Foundation

public struct Text: View, PrimitiveView {
    public let n: String

    public init(_ text: String) {
        self.n = text
    }

    static var size: Int? { 1 }

    func buildNode(_ node: Node) {
        node.control = TextControl(text: n)
    }
    
    func updateNode(_ node: Node) {
        let last = (node.viewWrapper as! ViewWrapper<Self>).view
        node.viewWrapper = ViewWrapper(view: self)
        if self.n != last.n {
            let control = node.control as! TextControl
            control.text = n
            control.layer.invalidate()
        }
    }
}

private class TextControl: Control {
    var text: String

    init(text: String) {
        self.text = text
    }

    override func size(proposedSize: Size) -> Size {
        return Size(width: text.count, height: 1)
    }

    override func cell(at position: Position) -> Cell? {
        guard position.line == 0 else { return nil }
        guard position.column < text.count else { return .init(char: " ") }
        return Cell(char: text[text.index(text.startIndex, offsetBy: position.column)])
    }
}
