import Foundation

/// Modifies controls as they are passed to a container.
protocol ModifierView {
    func passControl(_ control: Control, node: Node) -> Control
}
