import Foundation

extension Color: View, Primitive {
    static var size: Int? { 1 }

    func buildNode(_ node: Node) {
        node.control = ColorControl(color: self)
    }

    func updateNode(_ node: Node) {
        let last = node.nodeBuilder as! Self
        node.nodeBuilder = self
        if self != last {
            let control = node.control as! ColorControl
            control.color = self
            control.layer.invalidate()
        }
    }
}

private class ColorControl: Control {
    var color: Color

    init(color: Color) {
        self.color = color
    }

    override func cell(at position: Position) -> Cell? {
        Cell(char: " ", backgroundColor: color)
    }

}
