import Foundation

public struct Text: View, Primitive {
    let text: String
    @Environment(\.foregroundColor) var foregroundColor: Color
    @Environment(\.font) var font: Font

    public init(_ text: String) {
        self.text = text
    }

    static var size: Int? { 1 }

    func buildNode(_ node: Node) {
        setupEnvironmentProperties(node: node)
        node.control = TextControl(text: text, color: foregroundColor, font: font)
    }
    
    func updateNode(_ node: Node) {
        setupEnvironmentProperties(node: node)
        node.nodeBuilder = self
        let control = node.control as! TextControl
        control.text = text
        control.color = foregroundColor
        control.layer.invalidate()
    }
}

private class TextControl: Control {
    var text: String
    var color: Color
    var font: Font

    init(text: String, color: Color, font: Font) {
        self.text = text
        self.color = color
        self.font = font
    }

    override func size(proposedSize: Size) -> Size {
        return Size(width: text.count, height: 1)
    }

    override func cell(at position: Position) -> Cell? {
        guard position.line == 0 else { return nil }
        guard position.column < text.count else { return .init(char: " ") }
        return Cell(char: text[text.index(text.startIndex, offsetBy: position.column)], foregroundColor: color, font: font)
    }
}
