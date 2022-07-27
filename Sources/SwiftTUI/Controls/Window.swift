import Foundation

class Window {
    private(set) lazy var layer: Layer = { makeLayer() }()

    private(set) var controls: [Control] = []

    var firstResponder: Control?

    func addControl(_ control: Control) {
        control.window = self
        self.controls.append(control)
        layer.addLayer(control.layer, at: 0)
    }

    func makeLayer() -> Layer {
        let layer = Layer()
        let background = WindowBackgroundLayer()
        layer.frame.size = Size(width: 100, height: 50)
        background.frame.size = layer.frame.size
        layer.addLayer(background, at: 0)
        return layer
    }

}

private class WindowBackgroundLayer: Layer {
    override func cell(at position: Position) -> Cell? {
        Cell(char: " ")
    }
}
