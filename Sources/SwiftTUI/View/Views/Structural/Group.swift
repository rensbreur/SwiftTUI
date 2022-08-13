import Foundation

public struct Group<Content: View>: View, PrimitiveView {
    public let content: Content

    public init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }

    static var size: Int? { ViewWrapper<Content>.size }

    func buildNode(_ node: Node) {
        node.addNode(at: 0, Node(viewWrapper: ViewWrapper(view: content)))
    }

    func updateNode(_ node: Node) {
        node.viewWrapper = ViewWrapper(view: self)
        node.children[0].update(using: ViewWrapper(view: content))
    }

}
