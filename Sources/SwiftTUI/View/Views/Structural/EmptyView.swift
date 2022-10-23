import Foundation

public struct EmptyView: View, Primitive {
    static var size: Int? { 0 }
    
    func buildNode(_ node: Node) {}

    func updateNode(_ node: Node) {}
}
