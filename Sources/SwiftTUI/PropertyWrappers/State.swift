import Foundation

@propertyWrapper
public struct State<T>: AnyState {
    public let initialValue: T

    public init(initialValue: T) {
        self.initialValue = initialValue
    }

    public init(wrappedValue: T) {
        self.initialValue = wrappedValue
    }

    /// @State variables can have a nonmutating setter, because they are just
    /// a reference to state stored in a Node.
    var valueReference = StateReference()

    public var wrappedValue: T {
        get {
            guard let node = valueReference.node,
                  let label = valueReference.label
            else {
                assertionFailure("Attempting to access @State variable before view is instantiated")
                return initialValue
            }
            if let value = node.state[label] {
                return value as! T
            }
            return initialValue
        }
        nonmutating set {
            guard let node = valueReference.node,
                  let label = valueReference.label
            else {
                assertionFailure("Attempting to modify @State variable before view is instantiated")
                return
            }
            node.state[label] = newValue
            Node.invalidatedNodes.append(node)
        }
    }
}

protocol AnyState {
    var valueReference: StateReference { get }
}

class StateReference {
    weak var node: Node?
    var label: String?
}
