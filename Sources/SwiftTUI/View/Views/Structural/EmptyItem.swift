import Foundation

public struct EmptyItem: View, PrimitiveView {
    static var size: Int? { 0 }
    
    func buildNode(_ node: Node) {}

    func updateNode(_ node: Node) {}
}
