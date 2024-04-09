import Foundation

public struct TextField: View, PrimitiveView {
    public let placeholder: String?
    public let action: (String) -> Void

    @Environment(\.placeholderColor) private var placeholderColor: Color

    public init(placeholder: String? = nil, action: @escaping (String) -> Void) {
        self.placeholder = placeholder
        self.action = action
    }

    static var size: Int? { 1 }

    func buildNode(_ node: Node) {
        setupEnvironmentProperties(node: node)
        node.control = TextFieldControl(placeholder: placeholder ?? "", placeholderColor: placeholderColor, action: action)
    }

    func updateNode(_ node: Node) {
        setupEnvironmentProperties(node: node)
        node.view = self
        (node.control as! TextFieldControl).action = action
    }

    private class TextFieldControl: Control {
        var placeholder: String
        var placeholderColor: Color
        var action: (String) -> Void

        var text: String = ""

        init(placeholder: String, placeholderColor: Color, action: @escaping (String) -> Void) {
            self.placeholder = placeholder
            self.placeholderColor = placeholderColor
            self.action = action
        }

        override func size(proposedSize: Size) -> Size {
            return Size(width: Extended(max(text.count, placeholder.count)) + 1, height: 1)
        }

        override func handleEvent(_ char: Character) {
            if char == "\n" {
                action(text)
                self.text = ""
                layer.invalidate()
                return
            }

            if char == ASCII.DEL {
                if !self.text.isEmpty {
                    self.text.removeLast()
                    layer.invalidate()
                }
                return
            }

            self.text += String(char)
            layer.invalidate()
        }

        override func cell(at position: Position) -> Cell? {
            guard position.line == 0 else { return nil }
            if text.isEmpty {
                if position.column.intValue < placeholder.count {
                    let showUnderline = (position.column.intValue == 0) && isFirstResponder
                    let char = placeholder[placeholder.index(placeholder.startIndex, offsetBy: position.column.intValue)]
                    return Cell(
                        char: char,
                        foregroundColor: placeholderColor,
                        attributes: CellAttributes(underline: showUnderline)
                    )
                }
                return .init(char: " ")
            }
            if position.column.intValue == text.count, isFirstResponder { return Cell(char: " ", attributes: CellAttributes(underline: true)) }
            guard position.column.intValue < text.count else { return .init(char: " ") }
            return Cell(char: text[text.index(text.startIndex, offsetBy: position.column.intValue)])
        }

        override var selectable: Bool { true }

        override func becomeFirstResponder() {
            super.becomeFirstResponder()
            layer.invalidate()
        }

        override func resignFirstResponder() {
            super.resignFirstResponder()
            layer.invalidate()
        }
    }
}

extension EnvironmentValues {
    public var placeholderColor: Color {
        get { self[PlaceholderColorEnvironmentKey.self] }
        set { self[PlaceholderColorEnvironmentKey.self] = newValue }
    }
}

private struct PlaceholderColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color { .default }
}
