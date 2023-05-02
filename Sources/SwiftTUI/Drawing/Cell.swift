import Foundation

struct Cell: Equatable {
    var char: Character
    var foregroundColor: Color

    /// When this is nil, it does not mean the default background color.
    /// Rather, it means that the background color from the content below
    /// is used.
    var backgroundColor: Color?

    var font: Font
    var inverted: Bool

    init(char: Character, foregroundColor: Color = .default, backgroundColor: Color? = nil, font: Font = Font(), inverted: Bool = false) {
        self.char = char
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.font = font
        self.inverted = inverted
    }
}
