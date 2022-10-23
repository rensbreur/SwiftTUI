import Foundation

public struct Group<Content: View>: View, Primitive {
    public let content: Content

    public init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }

    static var size: Int? { Content.size }

    func buildNode(_ node: Node) {
        node.addNode(at: 0, Node(nodeBuilder: content.nodeBuilder))
    }

    func updateNode(_ node: Node) {
        node.nodeBuilder = self
        node.children[0].update(using: content.nodeBuilder)
    }

}
