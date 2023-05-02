import Foundation

public extension View {
    func font(_ font: Font) -> some View {
        environment(\.font, font)
    }
}

private struct FontEnvironmentKey: EnvironmentKey {
    static var defaultValue: Font { Font() }
}

extension EnvironmentValues {
    var font: Font {
        get { self[FontEnvironmentKey.self] }
        set { self[FontEnvironmentKey.self] = newValue }
    }
}
