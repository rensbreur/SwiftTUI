import Foundation

extension Text {
    public struct LineStyle: Hashable {
        /// SwiftTUI's alternative to Foundation's `NSUnderlineStyle`.
        public enum UnderlineStyle {
            case single
        }

        public enum Pattern: Hashable {
            case solid
        }

        let style: UnderlineStyle

        public init?(underlineStyle: UnderlineStyle?) {
            guard let underlineStyle = underlineStyle else {
                return nil
            }
            self.style = underlineStyle
        }

        public init(pattern: Pattern) {
            switch pattern {
            case .solid:
                self.style = .single
            }
        }
    }
}
