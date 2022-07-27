import Foundation

struct Color: Equatable {
    let foregroundCode: Int
    let backgroundCode: Int

    static var black: Self { .init(foregroundCode: 30, backgroundCode: 40) }
    static var red: Self { .init(foregroundCode: 31, backgroundCode: 41) }
    static var green: Self { .init(foregroundCode: 32, backgroundCode: 42) }
    static var yellow: Self { .init(foregroundCode: 33, backgroundCode: 43) }
    static var blue: Self { .init(foregroundCode: 34, backgroundCode: 44) }
    static var magenta: Self { .init(foregroundCode: 35, backgroundCode: 45) }
    static var white: Self { .init(foregroundCode: 37, backgroundCode: 47) }
}
