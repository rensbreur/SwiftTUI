import Foundation

/// This wraps a composed view, so that it can be used as a node builder.
struct Composed<I: View>: GenericView {
    let view: I

    func buildNode(_ node: Node) {
        view.setupStateProperties(node: node)
        view.setupEnvironmentProperties(node: node)
        node.addNode(at: 0, Node(view: view.body.view))
    }

    func updateNode(_ node: Node) {
        view.setupStateProperties(node: node)
        view.setupEnvironmentProperties(node: node)
        node.view = self
        node.children[0].update(using: view.body.view)
    }

    static var size: Int? {
        I.Body.size
    }
}
