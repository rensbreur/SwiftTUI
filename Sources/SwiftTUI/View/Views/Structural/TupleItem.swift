import Foundation

public struct TupleView2<C0: View, C1: View>: View, PrimitiveView {
    public let content: (C0, C1)

    static var size: Int? {
        if let c0 = ViewWrapper<C0>.size,
           let c1 = ViewWrapper<C1>.size
        {
            return c0 + c1
        }
        return nil
    }

    func buildNode(_ node: Node) {
        node.addNode(at: 0, Node(viewWrapper: ViewWrapper(view: content.0)))
        node.addNode(at: 1, Node(viewWrapper: ViewWrapper(view: content.1)))
    }

    func updateNode(_ node: Node) {
        node.viewWrapper = ViewWrapper(view: self)
        node.children[0].update(using: ViewWrapper(view: content.0))
        node.children[1].update(using: ViewWrapper(view: content.1))
    }

}

public struct TupleView3<C0: View, C1: View, C2: View>: View, PrimitiveView {
    public let content: (C0, C1, C2)

    static var size: Int? {
        if let c0 = ViewWrapper<C0>.size,
           let c1 = ViewWrapper<C1>.size,
           let c2 = ViewWrapper<C2>.size
        {
            return c0 + c1 + c2
        }
        return nil
    }

    func buildNode(_ node: Node) {
        node.addNode(at: 0, Node(viewWrapper: ViewWrapper(view: content.0)))
        node.addNode(at: 1, Node(viewWrapper: ViewWrapper(view: content.1)))
        node.addNode(at: 2, Node(viewWrapper: ViewWrapper(view: content.2)))
    }

    func updateNode(_ node: Node) {
        node.viewWrapper = ViewWrapper(view: self)
        node.children[0].update(using: ViewWrapper(view: content.0))
        node.children[1].update(using: ViewWrapper(view: content.1))
        node.children[2].update(using: ViewWrapper(view: content.2))
    }

}
