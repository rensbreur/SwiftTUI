import Foundation

protocol GenericView {
    func buildNode(_ node: Node)
    func updateNode(_ node: Node)
    static var size: Int? { get }
}
