import Foundation

public struct Button<Label: View>: View, PrimitiveView {
    let label: VStack<Label>
    let hover: () -> Void
    let action: () -> Void
    var disabled: Bool = false

    public init(action: @escaping () -> Void, hover: @escaping () -> Void = {}, @ViewBuilder label: () -> Label) {
        self.label = VStack(content: label())
        self.action = action
        self.hover = hover
    }

    public init(_ text: String, hover: @escaping () -> Void = {}, action: @escaping () -> Void) where Label == Text {
        self.label = VStack(content: Text(text))
        self.action = action
        self.hover = hover
    }

    public func disabled(_ isDisabled: Bool) -> Self {
        var result = self
        result.disabled = isDisabled
        return result
    }

    static var size: Int? { 1 }

    func buildNode(_ node: Node) {
        node.addNode(at: 0, Node(view: label.view))
        let control = ButtonControl(action: action, hover: hover)
        control.disabled = disabled
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
        var hover: () -> Void
        var disabled: Bool = false
        var label: Control!
        weak var buttonLayer: ButtonLayer?

        init(action: @escaping () -> Void, hover: @escaping () -> Void) {
            self.action = action
            self.hover = hover
        }

        override func size(proposedSize: Size) -> Size {
            return label.size(proposedSize: proposedSize)
        }

        override func layout(size: Size) {
            super.layout(size: size)
            self.label.layout(size: size)
        }

        override func handleEvent(_ char: Character) {
            if char == "\n" || char == " " {
                if !disabled {
                    action()
                }
            }
        }

        override var selectable: Bool { true }

        override func becomeFirstResponder() {
            super.becomeFirstResponder()
            buttonLayer?.highlighted = true
            hover()
            layer.invalidate()
        }

        override func resignFirstResponder() {
            super.resignFirstResponder()
            buttonLayer?.highlighted = false
            layer.invalidate()
        }

        override func makeLayer() -> Layer {
            let layer = ButtonLayer()
            layer.disabled = self.disabled
            self.buttonLayer = layer
            return layer
        }
    }

    private class ButtonLayer: Layer {
        var highlighted = false
        var disabled = false

        override func cell(at position: Position) -> Cell? {
            var cell = super.cell(at: position)
            if disabled {
                cell?.foregroundColor = .gray
            }
            if highlighted {
                cell?.attributes.inverted.toggle()
            }
            return cell
        }
    }
}
