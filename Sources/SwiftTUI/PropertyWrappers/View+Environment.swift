import Foundation

extension View {
    func setupEnvironmentProperties(node: Node) {
        for (_, value) in Mirror(reflecting: self).children {
            if let environmentValue = value as? AnyEnvironment {
                environmentValue.valueReference.node = node
            }
        }
    }
}
