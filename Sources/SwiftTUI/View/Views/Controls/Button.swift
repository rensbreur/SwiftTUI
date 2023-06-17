import Foundation

public struct Button: View, Primitive {
    public let n: String
    public let action: () -> Void

    public init(_ text: String, action: @escaping () -> Void) {
        self.n = text
        self.action = action
    }

    static var size: Int? { 1 }

    func buildNode(_ node: Node) {
        node.control = ButtonControl(text: n, action: action)
    }

    func updateNode(_ node: Node) {
        let last = node.nodeBuilder as! Self
        node.nodeBuilder = self
        if self.n != last.n {
            let control = node.control as! ButtonControl
            control.text = n
            control.layer.invalidate()
        }
    }
}

private class ButtonControl: Control {
    var text: String

    var action: () -> Void

    init(text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }

    override func size(proposedSize: Size) -> Size {
        return Size(width: text.count, height: 1)
    }

    override func handleEvent(_ char: Character) {
        if char == "\n" || char == " " {
            action()
        }
    }

    override func cell(at position: Position) -> Cell? {
        guard position.line == 0 else { return nil }
        guard position.column < text.count else { return .init(char: " ") }
        return Cell(
            char: text[text.index(text.startIndex, offsetBy: position.column)],
            attributes: CellAttributes(inverted: isFirstResponder)
        )
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
