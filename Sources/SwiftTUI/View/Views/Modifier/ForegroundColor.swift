import Foundation

public extension View {
    func foregroundColor(_ color: Color) -> some View {
        environment(\.foregroundColor, color)
    }
}

private struct ForegroundColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color { .default }
}

extension EnvironmentValues {
    var foregroundColor: Color {
        get { self[ForegroundColorEnvironmentKey.self] }
        set { self[ForegroundColorEnvironmentKey.self] = newValue }
    }
}
