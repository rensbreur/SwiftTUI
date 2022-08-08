import Foundation

struct Color: Equatable {
    let foregroundCode: Int
    let backgroundCode: Int

    static var `default`: Color { Color(foregroundCode: 39, backgroundCode: 49) }

    static var black: Color { Color(foregroundCode: 30, backgroundCode: 40) }
    static var red: Color { Color(foregroundCode: 31, backgroundCode: 41) }
    static var green: Color { Color(foregroundCode: 32, backgroundCode: 42) }
    static var yellow: Color { Color(foregroundCode: 33, backgroundCode: 43) }
    static var blue: Color { Color(foregroundCode: 34, backgroundCode: 44) }
    static var magenta: Color { Color(foregroundCode: 35, backgroundCode: 45) }
    static var white: Color { Color(foregroundCode: 37, backgroundCode: 47) }
}
