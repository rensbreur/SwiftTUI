import Foundation

extension Optional: View, PrimitiveView where Wrapped: View {
    public typealias Body = Never

    static var size: Int? {
        if ViewWrapper<Wrapped>.size == 0 { return 0 }
        return nil
    }

    func buildNode(_ node: Node) {
        if let view = self {
            node.addNode(at: 0, Node(viewWrapper: ViewWrapper(view: view)))
        }
    }

    func updateNode(_ node: Node) {
        let last = (node.viewWrapper as! ViewWrapper<Self>).view
        node.viewWrapper = ViewWrapper(view: self)
        switch (last, self) {
        case (.none, .none):
            break
        case (.none, .some(let newValue)):
            node.addNode(at: 0, Node(viewWrapper: ViewWrapper(view: newValue)))
        case (.some, .none):
            node.removeNode(at: 0)
        case (.some, .some(let newValue)):
            node.children[0].update(using: ViewWrapper(view: newValue))
        }
    }
}
