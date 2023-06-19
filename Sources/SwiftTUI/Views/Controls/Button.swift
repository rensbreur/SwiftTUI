import Foundation

public struct Button<Label>: View, PrimitiveView where Label : View {
    public let label: Label
    public let action: () -> Void

    public init(action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
        self.label = label()
        self.action = action
    }

    static var size: Int? { 1 }

    func buildNode(_ node: Node) {
        node.addNode(at: 0, Node(view: label.view))
        node.control = ButtonControl(action: action)
        for i in 0 ..< node.children[0].size {
            (node.control as! ButtonControl).addSubview(node.children[0].control(at: i), at: i)
        }
    }

    func updateNode(_ node: Node) {
        node.view = self
        node.children[0].update(using: label.view)
        let control = node.control as! ButtonControl
        control.action = action
    }

    private class ButtonControl: Control {
        var action: () -> Void

        init(action: @escaping () -> Void) {
            self.action = action
        }

        // MARK: - Layout

        override func size(proposedSize: Size) -> Size {
            var size: Size = .zero
            for control in children {
                let childSize = control.size(proposedSize: Size(width: proposedSize.width, height: proposedSize.height))
                size.height = max(size.height, childSize.height)
                size.width = max(size.width, childSize.width)
            }
            return size
        }

        override func layout(size: Size) {
            super.layout(size: size)
            for control in children {
                let childSize = control.size(proposedSize: Size(width: size.width, height: size.height))
                control.layout(size: childSize)
            }
        }

        override func cell(at position: Position) -> Cell? {
            Cell(char: " ", highlighted: isFirstResponder)
        }

        // MARK: - Event handling

        override func handleEvent(_ char: Character) {
            if char == "\n" || char == " " {
                action()
            }
        }

        override func becomeFirstResponder() {
            super.becomeFirstResponder()
            layer.invalidate()
        }

        override func resignFirstResponder() {
            super.resignFirstResponder()
            layer.invalidate()
        }

        // MARK: - Selection

        override var selectable: Bool { true }
    }
}

extension Button where Label == Text {
    public init(_ text: String, action: @escaping () -> Void) {
        self.label = Text(text)
        self.action = action
    }
}