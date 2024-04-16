import SwiftTUI

struct ColorState {
    let color: Color
    let name: String
    let fgCode: Int
    let bgCode: Int
}

extension ColorState: Identifiable {
    var id: String { name }
}

extension ColorState {
    static let black = ColorState(color: .black, name: "black", fgCode: 30, bgCode: 40)
    static let red = ColorState(color: .red, name: "red", fgCode: 31, bgCode: 41)
    static let green = ColorState(color: .green, name: "green", fgCode: 32, bgCode: 42)
    static let yellow = ColorState(color: .yellow, name: "yellow", fgCode: 33, bgCode: 43)
    static let blue = ColorState(color: .blue, name: "blue", fgCode: 34, bgCode: 44)
    static let magenta = ColorState(color: .magenta, name: "magenta", fgCode: 35, bgCode: 45)
    static let cyan = ColorState(color: .cyan, name: "cyan", fgCode: 36, bgCode: 46)
    static let white = ColorState(color: .white, name: "white", fgCode: 37, bgCode: 47)

    static let brightBlack = ColorState(color: .brightBlack, name: "bright black", fgCode: 90, bgCode: 100)
    static let brightRed = ColorState(color: .brightRed, name: "bright red", fgCode: 91, bgCode: 101)
    static let brightGreen = ColorState(color: .brightGreen, name: "bright green", fgCode: 92, bgCode: 102)
    static let brightYellow = ColorState(color: .brightYellow, name: "bright yellow", fgCode: 93, bgCode: 103)
    static let brightBlue = ColorState(color: .brightBlue, name: "bright blue", fgCode: 94, bgCode: 104)
    static let brightMagenta = ColorState(color: .brightMagenta, name: "bright magenta", fgCode: 95, bgCode: 105)
    static let brightCyan = ColorState(color: .brightCyan, name: "bright cyan", fgCode: 96, bgCode: 106)
    static let brightWhite = ColorState(color: .brightWhite, name: "bright white", fgCode: 97, bgCode: 107)

    static let normalColors: [ColorState] = [.black, .red, .green, .yellow, .blue, .magenta, .cyan, .white]
    static let brightColors: [ColorState] = [.brightBlack, .brightRed, .brightGreen, .brightYellow, .brightBlue, .brightMagenta, .brightCyan, .brightWhite]
}
