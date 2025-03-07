import Foundation

public enum VerticalAlignment: Sendable {
    case top
    case center
    case bottom
}

public enum HorizontalAlignment: Sendable {
    case leading
    case center
    case trailing
}

public struct Alignment: Sendable {
    public var horizontalAlignment: HorizontalAlignment
    public var verticalAlignment: VerticalAlignment

    public init(horizontalAlignment: HorizontalAlignment, verticalAlignment: VerticalAlignment) {
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
    }

    public static let top = Alignment(horizontalAlignment: .center, verticalAlignment: .top)
    public static let bottom = Alignment(horizontalAlignment: .center, verticalAlignment: .bottom)
    public static let center = Alignment(horizontalAlignment: .center, verticalAlignment: .center)
    public static let topLeading = Alignment(horizontalAlignment: .leading, verticalAlignment: .top)
    public static let leading = Alignment(horizontalAlignment: .leading, verticalAlignment: .center)
    public static let bottomLeading = Alignment(horizontalAlignment: .leading, verticalAlignment: .bottom)
    public static let topTrailing = Alignment(horizontalAlignment: .trailing, verticalAlignment: .top)
    public static let trailing = Alignment(horizontalAlignment: .trailing, verticalAlignment: .center)
    public static let bottomTrailing = Alignment(horizontalAlignment: .trailing, verticalAlignment: .bottom)
}
