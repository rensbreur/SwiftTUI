import Foundation

/// This is the interface to any view as the view graph is concerned.
///
/// Such a generic view can be either a `PrimitiveView`, meaning it has custom logic to build
/// and update the nodes, or a `ComposedView`, meaning it is created using the familiar `View`
/// struct.
protocol GenericView {
    func buildNode(_ node: Node)
    func updateNode(_ node: Node)
    static var size: Int? { get }
}
