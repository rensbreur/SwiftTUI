import Foundation

public struct TupleItem2<A: View, B: View>: View, PrimitiveView {
    public let content: (A, B)

    static var size: Int? {
        if let a = ViewWrapper<A>.size, let b = ViewWrapper<B>.size { return a + b }
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

public struct TupleItem3<A: View, B: View, C: View>: View, PrimitiveView {
    public let content: (A, B, C)

    static var size: Int? {
        if let a = ViewWrapper<A>.size,
           let b = ViewWrapper<B>.size,
           let c = ViewWrapper<C>.size
        { return a + b + c }
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
