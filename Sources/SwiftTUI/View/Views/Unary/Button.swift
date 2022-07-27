import Foundation

public struct Button: View, PrimitiveView {
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
        let last = (node.viewWrapper as! ViewWrapper<Self>).view
        node.viewWrapper = ViewWrapper(view: self)
        if self.n != last.n {
            (node.control as! ButtonControl).text = n
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

    override func handleEvent(_ char: UInt8) {
        let char = Character(.init(char))
        if char == "\n" || char == " " {
            action()
        }
    }

    override func cell(at position: Position) -> Cell? {
        let foreground: Color = rootWindow?.firstResponder === self ? .black : .white
        let background: Color = rootWindow?.firstResponder === self ? .white : .black
        guard position.line == 0 else { return nil }
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
