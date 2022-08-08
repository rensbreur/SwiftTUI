import Foundation

class Window: LayerDrawing {
    private(set) lazy var layer: Layer = makeLayer()

    private(set) var controls: [Control] = []

    var firstResponder: Control?

    func addControl(_ control: Control) {
        control.window = self
        self.controls.append(control)
        layer.addLayer(control.layer, at: 0)
    }

    private func makeLayer() -> Layer {
        let layer = Layer()
        layer.content = self
        return layer
    }

    func cell(at position: Position) -> Cell? {
        Cell(char: " ")
    }
}
