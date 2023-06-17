import Foundation

public struct Text: View, Primitive {
    let text: String

    @Environment(\.foregroundColor) private var foregroundColor: Color
    @Environment(\.bold) private var bold: Bool
    @Environment(\.italic) private var italic: Bool
    @Environment(\.underline) private var underline: Bool
    @Environment(\.strikethrough) private var strikethrough: Bool

    public init(_ text: String) {
        self.text = text
    }

    static var size: Int? { 1 }

    func buildNode(_ node: Node) {
        setupEnvironmentProperties(node: node)
        node.control = TextControl(
            text: text,
            foregroundColor: foregroundColor,
            bold: bold,
            italic: italic,
            underline: underline,
            strikethrough: strikethrough
        )
    }
    
    func updateNode(_ node: Node) {
        setupEnvironmentProperties(node: node)
        node.nodeBuilder = self
        let control = node.control as! TextControl
        control.text = text
        control.foregroundColor = foregroundColor
        control.bold = bold
        control.italic = italic
        control.underline = underline
        control.strikethrough = strikethrough
        control.layer.invalidate()
    }
}

private class TextControl: Control {
    var text: String


    var foregroundColor: Color
    var bold: Bool
    var italic: Bool
    var underline: Bool
    var strikethrough: Bool

    init(
        text: String,
        foregroundColor: Color,
        bold: Bool,
        italic: Bool,
        underline: Bool,
        strikethrough: Bool
    ) {
        self.text = text
        self.foregroundColor = foregroundColor
        self.bold = bold
        self.italic = italic
        self.underline = underline
        self.strikethrough = strikethrough
    }

    override func size(proposedSize: Size) -> Size {
        return Size(width: text.count, height: 1)
    }

    override func cell(at position: Position) -> Cell? {
        guard position.line == 0 else { return nil }
        guard position.column < text.count else { return .init(char: " ") }
        let cellAttributes = CellAttributes(
            bold: bold,
            italic: italic,
            underline: underline,
            strikethrough: strikethrough
        )
        return Cell(
            char: text[text.index(text.startIndex, offsetBy: position.column)],
            foregroundColor: foregroundColor,
            attributes: cellAttributes
        )
    }
}
