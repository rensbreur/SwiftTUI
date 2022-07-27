import Foundation

protocol StateProperty {
    var storage: Box<StateStorage?> { get }
    var initialErasedValue: Any { get }
}

@propertyWrapper
public struct State<T>: StateProperty {
    public let initialValue: T

    public init(initialValue: T) {
        self.initialValue = initialValue
    }

    public init(wrappedValue: T) {
        self.initialValue = wrappedValue
    }

    var storage = Box<StateStorage?>(value: nil)

    var initialErasedValue: Any { initialValue }

    public var wrappedValue: T {
        get { storage.value!.value as! T }
        nonmutating set { storage.value!.value = newValue }
    }
}

class Box<T> {
    var value: T
    init(value: T) { self.value = value }
}

class StateStorage {
    var value: Any { didSet { Node.invalidatedNodes.append(node!) } }
    weak var node: Node?
    init(value: Any, node: Node) {
        self.value = value
        self.node = node
    }
}
