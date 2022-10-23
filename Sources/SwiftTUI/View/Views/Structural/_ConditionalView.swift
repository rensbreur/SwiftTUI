import Foundation

public struct _ConditionalView<TrueContent: View, FalseContent: View>: View, Primitive {
    enum ConditionalContent {
        case a(TrueContent)
        case b(FalseContent)
    }

    let content: ConditionalContent

    static var size: Int? {
        if TrueContent.size == FalseContent.size { return TrueContent.size }
        return nil
    }

    func buildNode(_ node: Node) {
        switch content {
        case .a(let value):
            node.addNode(at: 0, Node(nodeBuilder: value.nodeBuilder))
        case .b(let value):
            node.addNode(at: 0, Node(nodeBuilder: value.nodeBuilder))
        }
    }

    func updateNode(_ node: Node) {
        let last = node.nodeBuilder as! Self
        node.nodeBuilder = self
        switch (last.content, self.content) {
        case (.a, .a(let newValue)):
            node.children[0].update(using: newValue.nodeBuilder)
        case (.b, .b(let newValue)):
            node.children[0].update(using: newValue.nodeBuilder)
        case (.b, .a(let newValue)):
            node.removeNode(at: 0)
            node.addNode(at: 0, Node(nodeBuilder: newValue.nodeBuilder))
        case (.a, .b(let newValue)):
            node.removeNode(at: 0)
            node.addNode(at: 0, Node(nodeBuilder: newValue.nodeBuilder))
        }
    }
}

extension View {
    var nodeBuilder: NodeBuilder {
        if let primitiveView = self as? Primitive {
            return primitiveView
        }
        return Composed(view: self)
    }
}
