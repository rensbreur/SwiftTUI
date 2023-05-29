import Foundation

public struct Text: View, Primitive {
    let text: String
    let textAttributes: [AttributeContainer]
    @Environment(\.foregroundColor) var foregroundColor: Color
    @Environment(\.font) var font: Font

    public init(_ text: String) {
        self.text = text
        self.textAttributes = Array(repeating: AttributeContainer(), count: text.count)
    }

    static var size: Int? { 1 }

    func buildNode(_ node: Node) {
        setupEnvironmentProperties(node: node)
        node.control = TextControl(text: text, attributes: cellsAttributes())
    }
    
    func updateNode(_ node: Node) {
        setupEnvironmentProperties(node: node)
        node.nodeBuilder = self
        let control = node.control as! TextControl
        control.text = text
        control.attributes = cellsAttributes()
        control.layer.invalidate()
    }
}

private extension Text {
    /// Creates an array containing the attributes of each one of the characters of an attributed string.
    static func charsAttributes(from attributedString: AttributedString) -> [AttributeContainer] {
        attributedString.runs.reduce(into: [AttributeContainer]()) { result, run in
            let containers = Array(repeating: run.attributes, count: attributedString[run.range].characters.count)
            result.append(contentsOf: containers)
        }
    }

    /// Creates an array by merging _view_ and text attributes.
    func cellsAttributes() -> [AttributeContainer] {
        var viewAttributes: AttributeContainer = AttributeContainer()
        viewAttributes.font = font
        viewAttributes.foregroundColor = foregroundColor
        return textAttributes.map { container in
            var container = container
            container.merge(viewAttributes, mergePolicy: AttributedString.AttributeMergePolicy.keepCurrent)
            return container
        }
    }
}

private class TextControl: Control {
    var text: String
    var attributes: [AttributeContainer]

    init(text: String, attributes: [AttributeContainer]) {
        self.text = text
        self.attributes = attributes
    }

    override func size(proposedSize: Size) -> Size {
        return Size(width: text.count, height: 1)
    }

    override func cell(at position: Position) -> Cell? {
        guard position.line == 0 else { return nil }
        guard position.column < text.count else { return .init(char: " ") }
        let index = text.index(text.startIndex, offsetBy: position.column)
        let distance = text.distance(from: text.startIndex, to: index)
        return Cell(char: text[index], attributes: attributes[distance])
    }
}
