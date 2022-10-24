import Foundation

/// Modifies controls as they are passed to a container.
protocol Modifier {
    func passControl(_ control: Control) -> Control
}
