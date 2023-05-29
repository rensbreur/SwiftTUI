import Foundation

extension AttributeScopes {
    /// Attribute scopes that SwiftTUI defines.
    public struct SwiftTUIAttributes: AttributeScope {
        public let backgroundColor: BackgroundColorAttribute = BackgroundColorAttribute()
        public let foregroundColor: ForegroundColorAttribute = ForegroundColorAttribute()

        public let font: FontAttribute = FontAttribute()
    
        public typealias DecodingConfiguration = AttributeScopeCodableConfiguration
        public typealias EncodingConfiguration = AttributeScopeCodableConfiguration

        public let strikethroughStyle: StrikethroughStyleAttribute = StrikethroughStyleAttribute()
        public let underlineStyle: UnderlineStyleAttribute = UnderlineStyleAttribute()

        let inverted: InvertedAttribute = InvertedAttribute()
    }
}

extension AttributeScopes.SwiftTUIAttributes {
    public struct BackgroundColorAttribute: AttributedStringKey {
        public typealias Value = Color
        public static let name = "BackgroundColor"
    }

    public struct ForegroundColorAttribute: AttributedStringKey {
        public typealias Value = Color
        public static let name = "ForegroundColor"
    }

    public struct FontAttribute: AttributedStringKey {
        public typealias Value = Font
        public static let name = "Font"
    }
    
    public struct StrikethroughStyleAttribute: AttributedStringKey {
        public typealias Value = Text.LineStyle
        public static let name = "StrikethroughStyle"
    }

    public struct UnderlineStyleAttribute: AttributedStringKey {
        public typealias Value = Text.LineStyle
        public static let name = "UnderlineStyle"
    }

    struct InvertedAttribute: AttributedStringKey {
        typealias Value = Bool
        static let name = "Inverted"
    }
}

public extension AttributeDynamicLookup {
    /// Adds dynamic member lookup of SwiftTUI attributes.
  subscript<T: AttributedStringKey>(dynamicMember keyPath: KeyPath<AttributeScopes.SwiftTUIAttributes, T>) -> T {
    self[T.self]
  }
}
