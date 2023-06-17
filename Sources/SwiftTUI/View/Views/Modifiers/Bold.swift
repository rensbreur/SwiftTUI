import Foundation

public extension View {
    func bold(_ isActive: Bool = true) -> some View {
        environment(\.bold, isActive)
    }
}

private struct BoldEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool { false }
}

extension EnvironmentValues {
    var bold: Bool {
        get { self[BoldEnvironmentKey.self] }
        set { self[BoldEnvironmentKey.self] = newValue }
    }
}
