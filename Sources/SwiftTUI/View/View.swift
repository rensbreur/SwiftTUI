import Foundation

// Note that a view is a description of how to create a **list** of controls.
// For example, a single `ForEach` view can generate many controls.
public protocol View {
    associatedtype Body: View
    @ViewBuilder var body: Body { get }
}

extension Never: View {
    public var body: Never {
        fatalError()
    }

    public typealias Body = Never
}
