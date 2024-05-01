import Foundation

public struct Button<Label: View>: View, PrimitiveView {
    let label: VStack<Label>
    let action: () -> Void

    public init(action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
        self.label = VStack(content: label())
        self.action = action
    }

    public init(_ text: String, action: @escaping () -> Void) where Label == Text {
        self.label = VStack(content: Text(text))
        self.action = action
    }

    static var size: Int? { 1 }

    func buildNode(_ node: Node) {
        node.addNode(at: 0, Node(view: label.view))
        let control = ButtonControl(action: action)
        control.label = node.children[0].control(at: 0)
        control.addSubview(control.label, at: 0)
        node.control = control
    }

    func updateNode(_ node: Node) {
        node.view = self
        node.children[0].update(using: label.view)
    }

    private class ButtonControl: Control {
        var action: () -> Void
        var label: Control!
        weak var buttonLayer: ButtonLayer?

        init(action: @escaping () -> Void) {
            self.action = action
        }

        override func size(proposedSize: Size) -> Size {
            return label.size(proposedSize: proposedSize)
        }

        override func layout(size: Size) {
            super.layout(size: size)
            self.label.layout(size: size)
        }

        override func handleEvent(_ char: Character) {
            if char == "\n" || char == "\r" || char == " " {
                action()
            }
        }

        override var selectable: Bool { true }

        override func becomeFirstResponder() {
            super.becomeFirstResponder()
            buttonLayer?.highlighted = true
            layer.invalidate()
        }

        override func resignFirstResponder() {
            super.resignFirstResponder()
            buttonLayer?.highlighted = false
            layer.invalidate()
        }

        override func makeLayer() -> Layer {
            let layer = ButtonLayer()
            self.buttonLayer = layer
            return layer
        }
    }

    private class ButtonLayer: Layer {
        var highlighted = false

        override func cell(at position: Position) -> Cell? {
            var cell = super.cell(at: position)
            if highlighted {
                cell?.attributes.inverted.toggle()
            }
            return cell
        }
    }
}
