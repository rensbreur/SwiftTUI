import Foundation

public struct Font: Hashable {

    var isItalic: Bool
    var isBold: Bool

    public init() {
        self.isItalic = false
        self.isBold = false
    }

    public func bold() -> Font {
        var font = self
        font.isBold = true
        return font
    }

    public func italic() -> Font {
        var font = self
        font.isItalic = true
        return font
    }
}
