import Foundation

/// Stacks and lists are layout roots. A layout root is responsible for setting
/// up and handling changes in the controls in the view. Because view graph
/// nodes aren't fully built when they are created, it can also do that lazily.
protocol LayoutRootView {
    func loadData(node: Node)
    func insertControl(at index: Int, node: Node)
    func removeControl(at index: Int, node: Node)
}
