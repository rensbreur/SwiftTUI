import Foundation

extension Node {
    /// Log the tree underneath the current node.
    /// ```
    /// → ContentView
    ///   → VStack<Text>
    ///     → Text
    /// ```
    func logTree() {
        logTree(level: 0)
    }

    private func logTree(level: Int) {
        let indent = Array(repeating: " ", count: level * 2).joined()
        log("\(indent)→ \(type(of: self.view))")
        for child in children {
            child.logTree(level: level + 1)
        }
    }
}
