import Foundation

enum StackOriention {
    case horizontal
    case vertical
}

private struct StackOrientionEnvironmentKey: EnvironmentKey {
    static var defaultValue: StackOriention { .vertical }
}

extension EnvironmentValues {
    /// This is used by views like `Spacer`, the appearance of which depends
    /// on the orientation of the stack they are in.
    var stackOrientation: StackOriention {
        get { self[StackOrientionEnvironmentKey.self] }
        set { self[StackOrientionEnvironmentKey.self] = newValue }
    }
}

