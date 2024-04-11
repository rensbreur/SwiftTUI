import Foundation

public extension View {
    func environment<T>(_ keyPath: WritableKeyPath<EnvironmentValues, T>, _ value: T) -> some View {
        return SetEnvironment(content: self, keyPath: keyPath, value: value)
    }
}

private struct SetEnvironment<Content: View, T>: View, PrimitiveView {
    let content: Content
    let keyPath: WritableKeyPath<EnvironmentValues, T>
    let value: T

    init(content: Content, keyPath: WritableKeyPath<EnvironmentValues, T>, value: T) {
        self.content = content
        self.keyPath = keyPath
        self.value = value
    }

    static var size: Int? { Content.size }

    func buildNode(_ node: Node) {
        node.addNode(at: 0, Node(view: content.view))
        node.environment = { $0[keyPath: keyPath] = value }
    }

    func updateNode(_ node: Node) {
        node.view = self
        node.environment = { $0[keyPath: keyPath] = value }
        node.children[0].update(using: content.view)
    }

}
