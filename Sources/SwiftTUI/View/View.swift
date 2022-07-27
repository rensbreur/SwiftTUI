import Foundation

public protocol View {
    associatedtype Body: View
    @ItemBuilder var body: Body { get }
}

extension Never: View {
    public var body: Never {
        fatalError()
    }

    public typealias Body = Never
}

