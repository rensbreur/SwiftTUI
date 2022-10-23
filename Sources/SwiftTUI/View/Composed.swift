import Foundation

/// This wraps a composed view, so that it can be used as a node builder.
struct Composed<I: View>: NodeBuilder {
    let view: I

    func buildNode(_ node: Node) {
        view.setupStateProperties(node: node)
        view.setupEnvironmentProperties(node: node)
        node.addNode(at: 0, Node(nodeBuilder: view.body.nodeBuilder))
    }

    func updateNode(_ node: Node) {
        view.setupStateProperties(node: node)
        view.setupEnvironmentProperties(node: node)
        node.nodeBuilder = self
        node.children[0].update(using: view.body.nodeBuilder)
    }

    static var size: Int? {
        I.Body.size
    }
}
