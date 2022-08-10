import Foundation

extension Color: View, PrimitiveView {
    static var size: Int? { 1 }

    func buildNode(_ node: Node) {
        node.control = ColorControl(color: self)
    }

    func updateNode(_ node: Node) {
        let last = (node.viewWrapper as! ViewWrapper<Self>).view
        node.viewWrapper = ViewWrapper(view: self)
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
        log("Initting")
        self.color = color
    }

    override func size(proposedSize: Size) -> Size {
        return super.size(proposedSize: proposedSize)
    }

    override func layout(size: Size) {
        log("Layout size \(size)")
        self.layer.frame.size = size
    }

    override func cell(at position: Position) -> Cell? {
        Cell(char: "r", backgroundColor: color)
    }
}
