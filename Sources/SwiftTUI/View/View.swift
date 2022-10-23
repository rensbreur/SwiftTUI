import Foundation

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
