import Foundation

public struct TextField: View, PrimitiveView {
    public let action: (String) -> Void

    public init(action: @escaping (String) -> Void) {
        self.action = action
    }

    static var size: Int? { 1 }

    func buildNode(_ node: Node) {
        node.control = TextFieldControl(action: action)
    }

    func updateNode(_ node: Node) {
        node.viewWrapper = ViewWrapper(view: self)
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

    override func handleEvent(_ char: UInt8) {
        let character = Character(.init(char))
        if character == "\n" { action(text); return }
        if char == 127 { self.text.removeLast(); return }
        self.text += String(character)
        layer.invalidate()
    }

    override func cell(at position: Position) -> Cell? {
        let foreground: Color = .white
        let background: Color = .black
        guard position.line == 0 else { return nil }
        if position.column == text.count, rootWindow?.firstResponder === self { return Cell(char: "_", foregroundColor: foreground, backgroundColor: background) }
        guard position.column < text.count else { return .init(char: " ") }
        return .init(char: text[text.index(text.startIndex, offsetBy: position.column)], foregroundColor: foreground, backgroundColor: background)
    }

    override var selectable: Bool { true }

    override func becomeFirstResponder() {
        layer.invalidate()
    }

    override func resignFirstResponder() {
        layer.invalidate()
    }

}
