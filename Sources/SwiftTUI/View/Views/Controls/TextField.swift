import Foundation

public struct TextField: View, Primitive {
    public let action: (String) -> Void

    public init(action: @escaping (String) -> Void) {
        self.action = action
    }

    static var size: Int? { 1 }

    func buildNode(_ node: Node) {
        node.control = TextFieldControl(action: action)
    }

    func updateNode(_ node: Node) {
        node.nodeBuilder = self
        (node.control as! TextFieldControl).action = action
    }
}

private class TextFieldControl: Control {
    var text: String = ""

    var action: (String) -> Void

    init(action: @escaping (String) -> Void) {
        self.action = action
    }

    override func size(proposedSize: Size) -> Size {
        return Size(width: text.count + 1, height: 1)
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
        if position.column == text.count, isFirstResponder { return Cell(char: "_") }
        guard position.column < text.count else { return .init(char: " ") }
        return Cell(char: text[text.index(text.startIndex, offsetBy: position.column)])
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
