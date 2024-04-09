import Foundation

public struct Color: Hashable {
    private let data: Data

    private enum Data: Hashable {
        case ansi(ANSIColor)
        case rgb(Int, Int, Int)
    }

    private init(data: Data) {
        self.data = data
    }

    public init(ansi: ANSIColor) {
        self.init(data: .ansi(ansi))
    }

    public init(red: Int, green: Int, blue: Int) {
        self.init(data: .rgb(red, green, blue))
    }

    var foregroundEscapeSequence: String {
        switch data {
        case .ansi(let color):
            return EscapeSequence.setForegroundColor(color)
        case .rgb(let r, let g, let b):
            return EscapeSequence.setForegroundColor(red: r, green: g, blue: b)
        }
    }

    var backgroundEscapeSequence: String {
        switch data {
        case .ansi(let color):
            return EscapeSequence.setBackgroundColor(color)
        case .rgb(let r, let g, let b):
            return EscapeSequence.setBackgroundColor(red: r, green: g, blue: b)
        }
    }

    public static var `default`: Color { Color(ansi: .default) }

    public static var black: Color { Color(ansi: .black) }
    public static var red: Color { Color(ansi: .red) }
    public static var green: Color { Color(ansi: .green) }
    public static var yellow: Color { Color(ansi: .yellow) }
    public static var blue: Color { Color(ansi: .blue) }
    public static var magenta: Color { Color(ansi: .magenta) }
    public static var white: Color { Color(ansi: .white) }
}

public struct ANSIColor: Hashable {
    let foregroundCode: Int
    let backgroundCode: Int

    public static var `default`: ANSIColor { ANSIColor(foregroundCode: 39, backgroundCode: 49) }

    public static var black: ANSIColor { ANSIColor(foregroundCode: 30, backgroundCode: 40) }
    public static var red: ANSIColor { ANSIColor(foregroundCode: 31, backgroundCode: 41) }
    public static var green: ANSIColor { ANSIColor(foregroundCode: 32, backgroundCode: 42) }
    public static var yellow: ANSIColor { ANSIColor(foregroundCode: 33, backgroundCode: 43) }
    public static var blue: ANSIColor { ANSIColor(foregroundCode: 34, backgroundCode: 44) }
    public static var magenta: ANSIColor { ANSIColor(foregroundCode: 35, backgroundCode: 45) }
    public static var cyan: ANSIColor { ANSIColor(foregroundCode: 36, backgroundCode: 46) }
    public static var white: ANSIColor { ANSIColor(foregroundCode: 37, backgroundCode: 47) }
}
