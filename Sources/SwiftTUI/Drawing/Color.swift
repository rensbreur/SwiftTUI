import Foundation

public struct Color: Equatable {
    let foregroundCode: Int
    let backgroundCode: Int

    public static var `default`: Color { Color(foregroundCode: 39, backgroundCode: 49) }

    public static var black: Color { Color(foregroundCode: 30, backgroundCode: 40) }
    public static var red: Color { Color(foregroundCode: 31, backgroundCode: 41) }
    public static var green: Color { Color(foregroundCode: 32, backgroundCode: 42) }
    public static var yellow: Color { Color(foregroundCode: 33, backgroundCode: 43) }
    public static var blue: Color { Color(foregroundCode: 34, backgroundCode: 44) }
    public static var magenta: Color { Color(foregroundCode: 35, backgroundCode: 45) }
    public static var white: Color { Color(foregroundCode: 37, backgroundCode: 47) }
}
