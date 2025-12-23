import Foundation

/// The visual style of the cursor in a TextField
public enum TextFieldCursorStyle {
    /// Cursor displayed as an underline beneath the character
    case underline
    /// Cursor displayed as an inverted block covering the character
    case block
}

// MARK: - Environment Value

public extension EnvironmentValues {
    var textFieldCursorStyle: TextFieldCursorStyle {
        get { self[TextFieldCursorStyleKey.self] }
        set { self[TextFieldCursorStyleKey.self] = newValue }
    }
}

private struct TextFieldCursorStyleKey: EnvironmentKey {
    static var defaultValue: TextFieldCursorStyle { .underline }
}

// MARK: - View Modifier

public extension View {
    /// Sets the cursor style for TextFields within this view
    /// - Parameter style: The cursor style to use (.underline or .block)
    /// - Returns: A view with the specified cursor style
    func textFieldCursorStyle(_ style: TextFieldCursorStyle) -> some View {
        environment(\.textFieldCursorStyle, style)
    }
}
