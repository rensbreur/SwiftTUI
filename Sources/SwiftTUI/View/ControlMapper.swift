import Foundation

/// Modifies controls as they are passed to a container.
protocol ControlMapper {
    func passControl(_ control: Control) -> Control
}
