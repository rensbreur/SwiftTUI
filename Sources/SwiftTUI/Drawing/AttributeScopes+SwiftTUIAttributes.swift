import Foundation

@available(macOS 12, *)
extension AttributeScopes {
    public struct SwiftTUIAttributes: AttributeScope {
        public let backgroundColor = BackgroundColorAttribute()
        public let foregroundColor = ForegroundColorAttribute()
        public let bold = BoldAttribute()
        public let italic = ItalicAttribute()
        public let strikethrough = StrikethroughAttribute()
        public let underline = UnderlineAttribute()
        public let inverted = InvertedAttribute()
    }
}

@available(macOS 12, *)
extension AttributeScopes.SwiftTUIAttributes {
    public struct BackgroundColorAttribute: AttributedStringKey {
        public typealias Value = Color
        public static let name = "BackgroundColor"
    }

    public struct ForegroundColorAttribute: AttributedStringKey {
        public typealias Value = Color
        public static let name = "ForegroundColor"
    }

    public struct BoldAttribute: AttributedStringKey {
        public typealias Value = Bool
        public static let name = "Bold"
    }

    public struct ItalicAttribute: AttributedStringKey {
        public typealias Value = Bool
        public static let name = "Italic"
    }

    public struct StrikethroughAttribute: AttributedStringKey {
        public typealias Value = Bool
        public static let name = "Strikethrough"
    }

    public struct UnderlineAttribute: AttributedStringKey {
        public typealias Value = Bool
        public static let name = "Underline"
    }

    public struct InvertedAttribute: AttributedStringKey {
        public typealias Value = Bool
        public static let name = "Inverted"
    }
}

@available(macOS 12, *)
public extension AttributeDynamicLookup {
  subscript<T: AttributedStringKey>(dynamicMember keyPath: KeyPath<AttributeScopes.SwiftTUIAttributes, T>) -> T {
    self[T.self]
  }
}
