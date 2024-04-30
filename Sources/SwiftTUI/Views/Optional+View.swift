import Foundation

extension Optional: View, PrimitiveView, GenericView, OptionalView where Wrapped: View {
    public typealias Body = Never

    static var size: Int? {
        if Wrapped.size == 0 { return 0 }
        return nil
    }

    func buildNode(_ node: Node) {
        if let view = self {
            node.addNode(at: 0, Node(view: view.view))
        }
    }

    func updateNode(_ node: Node) {
        let last = node.view as! Self
        node.view = self
        switch (last, self) {
        case (.none, .none):
            break
        case (.none, .some(let newValue)):
            node.addNode(at: 0, Node(view: newValue.view))
        case (.some, .none):
            node.removeNode(at: 0)
        case (.some, .some(let newValue)):
            node.children[0].update(using: newValue.view)
        }
    }
}

/// We can use this non-generic protocol to check if a view is optional or not.
///
/// In particular, when checking if a view is of a particular type (e.g. a layout root) using
/// Swift's `is` or `as?`, optional views can be implicitly unwrapped, so we explicitly need to
/// make sure the view is not optional.
protocol OptionalView {}
