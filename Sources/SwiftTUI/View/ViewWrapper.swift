import Foundation

/// This wraps a view, so that we can hide it behind a non-generic protocol.
struct ViewWrapper<I: View>: AnyViewWrapper {
    let view: I

    func buildNode(_ node: Node) {
        if let view = view as? PrimitiveView {
            view.buildNode(node)
        } else {
            setupStateProperties(node: node)
            setupEnvironmentProperties(node: node)
            node.addNode(at: 0, Node(viewWrapper: ViewWrapper<I.Body>(view: view.body)))
        }
    }

    func updateNode(_ node: Node) {
        if let view = view as? PrimitiveView {
            view.updateNode(node)
        } else {
            setupStateProperties(node: node)
            setupEnvironmentProperties(node: node)
            node.viewWrapper = self
            node.children[0].update(using: ViewWrapper<I.Body>(view: view.body))
        }
    }

    private func setupStateProperties(node: Node) {
        for (label, value) in Mirror(reflecting: view).children {
            if let stateValue = value as? AnyState {
                // Note: this is not how SwiftUI handles state.
                // This will break if you initialize a View, and then use it
                // multiple times, because we would be editing the same View.
                stateValue.valueReference.node = node
                stateValue.valueReference.label = label
            }
        }
    }

    private func setupEnvironmentProperties(node: Node) {
        for (_, value) in Mirror(reflecting: view).children {
            if let environmentValue = value as? AnyEnvironment {
                environmentValue.valueReference.node = node
            }
        }
    }

    static var size: Int? {
        if let I = I.self as? PrimitiveView.Type {
            return I.size
        } else {
            return ViewWrapper<I.Body>.size
        }
    }
}

protocol AnyViewWrapper {
    func buildNode(_ node: Node)
    func updateNode(_ node: Node)
    static var size: Int? { get }
}

extension ViewWrapper: ViewContainer where I: ViewContainer {
    func loadData(node: Node) {
        view.loadData(node: node)
    }

    func insertControl(at index: Int, node: Node) {
        view.insertControl(at: index, node: node)
    }

    func removeControl(at index: Int, node: Node) {
        view.removeControl(at: index, node: node)
    }

}

extension ViewWrapper: ControlMapper where I: ControlMapper {
    func passControl(_ control: Control) -> Control {
        view.passControl(control)
    }
}

extension ViewWrapper: CustomStringConvertible {
    var description: String {
        String(describing: I.self)
    }
}
