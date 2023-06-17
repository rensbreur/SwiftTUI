import Foundation

public extension View {
    func underline(_ isActive: Bool = true) -> some View {
        environment(\.underline, isActive)
    }
}

private struct UnderlineEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool { false }
}

extension EnvironmentValues {
    var underline: Bool {
        get { self[UnderlineEnvironmentKey.self] }
        set { self[UnderlineEnvironmentKey.self] = newValue }
    }
}
