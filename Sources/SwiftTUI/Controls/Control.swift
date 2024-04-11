import Foundation

/// The basic layout object that can be created by a node. Not every node will
/// create a control (e.g. ForEach won't).
class Control: LayerDrawing {
    private(set) var children: [Control] = []
    private(set) var parent: Control?

    private var index: Int = 0

    var window: Window?
    private(set) lazy var layer: Layer = makeLayer()

    var root: Control { parent?.root ?? self }

    func addSubview(_ view: Control, at index: Int) {
        self.children.insert(view, at: index)
        layer.addLayer(view.layer, at: index)
        view.parent = self
        view.window = window
        for i in index ..< children.count {
            children[i].index = i
        }
        if let window = root.window, window.firstResponder == nil {
            if let responder = view.firstSelectableElement {
                window.firstResponder = responder
                responder.becomeFirstResponder()
            }
        }
    }

    func removeSubview(at index: Int) {
        if children[index].isFirstResponder || root.window?.firstResponder?.isDescendant(of: children[index]) == true {
            root.window?.firstResponder?.resignFirstResponder()
            root.window?.firstResponder = selectableElement(above: index) ?? selectableElement(below: index)
            root.window?.firstResponder?.becomeFirstResponder()
        }
        children[index].window = nil
        children[index].parent = nil
        self.children.remove(at: index)
        layer.removeLayer(at: index)
        for i in index ..< children.count {
            children[i].index = i
        }
    }

    func isDescendant(of control: Control) -> Bool {
        guard let parent else { return false }
        return control === parent || parent.isDescendant(of: control)
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

    func horizontalFlexibility(height: Extended) -> Extended {
        let minSize = size(proposedSize: Size(width: 0, height: height))
        let maxSize = size(proposedSize: Size(width: .infinity, height: height))
        return maxSize.width - minSize.width
    }

    func verticalFlexibility(width: Extended) -> Extended {
        let minSize = size(proposedSize: Size(width: width, height: 0))
        let maxSize = size(proposedSize: Size(width: width, height: .infinity))
        return maxSize.height - minSize.height
    }

    // MARK: - Drawing

    func cell(at position: Position) -> Cell? { nil }

    // MARK: - Event handling

    func handleEvent(_ char: Character) {
        for subview in children {
            subview.handleEvent(char)
        }
    }

    func becomeFirstResponder() {
        scroll(to: .zero)
    }

    func resignFirstResponder() {}

    var isFirstResponder: Bool { root.window?.firstResponder === self }

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

    // MARK: - Scrolling

    func scroll(to position: Position) {
        parent?.scroll(to: position + layer.frame.position)
    }

}
