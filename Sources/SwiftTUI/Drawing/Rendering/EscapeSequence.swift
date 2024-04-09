import Foundation

enum EscapeSequence {
    static let clearScreen = "\u{1b}[2J"

    static let enableAlternateBuffer = "\u{1b}[?1049h"
    static let disableAlternateBuffer = "\u{1b}[?1049l"

    static let showCursor = "\u{1b}[?25h"
    static let hideCursor = "\u{1b}[?25l"

    static func moveTo(_ position: Position) -> String {
        "\u{1b}[\(position.line + 1);\(position.column + 1)H"
    }

    static func setForegroundColor(_ color: ANSIColor) -> String {
        "\u{1b}[\(color.foregroundCode)m"
    }

    static func setBackgroundColor(_ color: ANSIColor) -> String {
        "\u{1b}[\(color.backgroundCode)m"
    }

    static func setForegroundColor(red: Int, green: Int, blue: Int) -> String {
        "\u{1b}[38;2;\(red);\(green);\(blue)m"
    }

    static func setBackgroundColor(red: Int, green: Int, blue: Int) -> String {
        "\u{1b}[48;2;\(red);\(green);\(blue)m"
    }

    static func setForegroundColor(xterm: Int) -> String {
        "\u{1b}[38;5;\(xterm)m"
    }

    static func setBackgroundColor(xterm: Int) -> String {
        "\u{1b}[48;5;\(xterm)m"
    }

    static let enableBold = "\u{1b}[1m"
    static let disableBold = "\u{1b}[22m"

    static let enableItalic = "\u{1b}[3m"
    static let disableItalic = "\u{1b}[23m"

    static let enableUnderline = "\u{1b}[4m"
    static let disableUnderline = "\u{1b}[24m"

    static let enableStrikethrough = "\u{1b}[9m"
    static let disableStrikethrough = "\u{1b}[29m"

    static let enableInverted = "\u{1b}[7m"
    static let disableInverted = "\u{1b}[27m"
}
