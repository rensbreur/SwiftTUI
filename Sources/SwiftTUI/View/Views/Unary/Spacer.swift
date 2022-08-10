import Foundation

public struct Spacer: View, PrimitiveView {
    public init() {}
    
    static var size: Int? { 1 }

    func buildNode(_ node: Node) {
        node.control = SpacerControl()
    }

    func updateNode(_ node: Node) {
        node.viewWrapper = ViewWrapper(view: self)
    }
}

private class SpacerControl: Control {
    override var layoutPriority: Double { -1000 }

    override var isSpacer: Bool { true }
}
