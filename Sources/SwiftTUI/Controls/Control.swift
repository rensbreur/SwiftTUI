import Foundation

/// The basic layout object that can be created by a node. Not every node will
/// create a control (e.g. ForEach won't).
class Control: LayerDrawing {
    private(set) var children: [Control] = []
    private(set) var parent: Control?

    private var index: Int = 0

    private(set) lazy var layer: Layer = makeLayer()

    var window: Window?
    final var rootWindow: Window? { window ?? parent?.rootWindow }

    func addSubview(_ view: Control, at index: Int) {
        self.children.insert(view, at: index)
        layer.addLayer(view.layer, at: index)
        view.parent = self
        view.window = window
        for i in index ..< children.count {
            children[i].index = i
        }
    }

    func removeSubview(at index: Int) {
        if children[index].isFirstResponder {
            rootWindow?.firstResponder?.resignFirstResponder()
            rootWindow?.firstResponder = selectableElement(above: index) ?? selectableElement(below: index)
            rootWindow?.firstResponder?.becomeFirstResponder()
        }
        children[index].window = nil
        children[index].parent = nil
        self.children.remove(at: index)
        layer.removeLayer(at: index)
        for i in index ..< children.count {
            children[i].index = i
        }
    }

    func makeLayer() -> Layer {
        let layer = Layer()
        layer.content = self
        return layer
    }

    // MARK: - Layout

    func size(proposedSize: Size) -> Size {
        proposedSize
    }

    func layout(size: Size) {
        layer.frame.size = size
    }

    var layoutPriority: Double { 0 }

    /// Spacers only grow stacks in their direction, in contrast to other
    /// flexible views such as colors.
    var isSpacer: Bool { false }

    // MARK: - Drawing

    func cell(at position: Position) -> Cell? { nil }

    // MARK: - Event handling

    func handleEvent(_ char: UInt8) {
        for subview in children {
            subview.handleEvent(char)
        }
    }

    func becomeFirstResponder() {}

    func resignFirstResponder() {}

    var isFirstResponder: Bool { rootWindow?.firstResponder === self }

    // MARK: - Selection

    var selectable: Bool { false }

    final var firstSelectableElement: Control? {
        if selectable { return self }
        for control in children {
            if let element = control.firstSelectableElement { return element }
        }
        return nil
    }

    func selectableElement(below index: Int) -> Control? { parent?.selectableElement(below: self.index) }
    func selectableElement(above index: Int) -> Control? { parent?.selectableElement(above: self.index) }
    func selectableElement(rightOf index: Int) -> Control? { parent?.selectableElement(rightOf: self.index) }
    func selectableElement(leftOf index: Int) -> Control? { parent?.selectableElement(leftOf: self.index) }

}
