import Foundation

public struct Color: Hashable {
    private let data: Data

    private enum Data: Hashable {
        case ansi(ANSIColor)
        case xterm(XTermColor)
        case trueColor(TrueColor)
    }

    private init(data: Data) {
        self.data = data
    }

    static func ansi(_ color: ANSIColor) -> Color {
        Color(data: .ansi(color))
    }

    /// RGB values must lie between 0 and 5
    public static func xterm(red: Int, green: Int, blue: Int) -> Color {
        Color(data: .xterm(.color(red: red, green: green, blue: blue)))
    }

    /// White value must lie between 0 and 23
    public static func xterm(white: Int) -> Color {
        Color(data: .xterm(.grayscale(white: white)))
    }

    /// RGB values must lie between 0 and 255. Not all terminals support this.
    public static func trueColor(red: Int, green: Int, blue: Int) -> Color {
        Color(data: .trueColor(TrueColor(red: red, green: green, blue: blue)))
    }

    var foregroundEscapeSequence: String {
        switch data {
        case .ansi(let color):
            return EscapeSequence.setForegroundColor(color)
        case .trueColor(let color):
            return EscapeSequence.setForegroundColor(red: color.red, green: color.green, blue: color.blue)
        case .xterm(let color):
            return EscapeSequence.setForegroundColor(xterm: color.value)
        }
    }

    var backgroundEscapeSequence: String {
        switch data {
        case .ansi(let color):
            return EscapeSequence.setBackgroundColor(color)
        case .trueColor(let color):
            return EscapeSequence.setBackgroundColor(red: color.red, green: color.green, blue: color.blue)
        case .xterm(let color):
            return EscapeSequence.setBackgroundColor(xterm: color.value)
        }
    }

    public static var `default`: Color { Color.ansi(.default) }

    public static var black: Color { .ansi(.black) }
    public static var red: Color { .ansi(.red) }
    public static var green: Color { .ansi(.green) }
    public static var yellow: Color { .ansi(.yellow) }
    public static var blue: Color { .ansi(.blue) }
    public static var magenta: Color { .ansi(.magenta) }
    public static var white: Color { .ansi(.white) }
}

struct ANSIColor: Hashable {
    let foregroundCode: Int
    let backgroundCode: Int

    static var `default`: ANSIColor { ANSIColor(foregroundCode: 39, backgroundCode: 49) }

    static var black: ANSIColor { ANSIColor(foregroundCode: 30, backgroundCode: 40) }
    static var red: ANSIColor { ANSIColor(foregroundCode: 31, backgroundCode: 41) }
    static var green: ANSIColor { ANSIColor(foregroundCode: 32, backgroundCode: 42) }
    static var yellow: ANSIColor { ANSIColor(foregroundCode: 33, backgroundCode: 43) }
    static var blue: ANSIColor { ANSIColor(foregroundCode: 34, backgroundCode: 44) }
    static var magenta: ANSIColor { ANSIColor(foregroundCode: 35, backgroundCode: 45) }
    static var cyan: ANSIColor { ANSIColor(foregroundCode: 36, backgroundCode: 46) }
    static var white: ANSIColor { ANSIColor(foregroundCode: 37, backgroundCode: 47) }
}

struct XTermColor: Hashable {
    let value: Int

    static func color(red: Int, green: Int, blue: Int) -> XTermColor {
        guard red >= 0, red < 6, green >= 0, green < 6, blue >= 0, blue < 6 else {
            fatalError("Color values must lie between 1 and 5")
        }
        let offset = 16 // system colors
        return XTermColor(value: offset + (6 * 6 * red) + (6 * green) + blue)
    }

    static func grayscale(white: Int) -> XTermColor {
        guard white >= 0, white < 24 else {
            fatalError("Color value must lie between 1 and 24")
        }
        let offset = 16 + (6 * 6 * 6)
        return XTermColor(value: offset + white)
    }
}

struct TrueColor: Hashable {
    let red: Int
    let green: Int
    let blue: Int
}
