import Foundation

extension View {
    func setupStateProperties(node: Node) {
        for (label, value) in Mirror(reflecting: self).children {
            if let stateValue = value as? AnyState {
                // Note: this is not how SwiftUI handles state.
                // This will break if you initialize a View, and then use it
                // multiple times, because we would be editing the same View.
                stateValue.valueReference.node = node
                stateValue.valueReference.label = label
            }
        }
    }
}
