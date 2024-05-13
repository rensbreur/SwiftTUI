import Foundation

public extension View {
  /// Define a style for `Divider` component
  /// - Parameter style: choose a style between `.default`, `.doubled`, `.heavy`
  /// - Returns: Divider styled
    func style(_ style: DividerStyle = .default) -> some View {
        environment(\.dividerStyle, style)
    }
}

private struct DividerStyleEnvironmentKey: EnvironmentKey {
    static var defaultValue: DividerStyle { .default }
}

extension EnvironmentValues {
  /// This is used by views like `Divider`, the appearance of which depends
  /// on the orientation of the stack they are in.
  var dividerStyle: DividerStyle {
    get { self[DividerStyleEnvironmentKey.self] }
    set { self[DividerStyleEnvironmentKey.self] = newValue }
  }
}

public struct DividerStyle: Equatable {
    let horizontal: Character
    let vertical: Character
    
    public init(horizontal: Character, vertical: Character) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
    
    /// Define a single line for Divider
    ///
    /// Vertical
    /// ```
    /// │
    /// ```
    ///
    /// Horizontal
    /// ```
    /// ───────────
    /// ```
    public static var `default`: DividerStyle {
        DividerStyle(
            horizontal: "─",
            vertical: "│"
        )
    }
     
    
    /// Define a double line for Divider
    ///
    /// Vertical
    /// ```
    /// ║
    /// ```
    ///
    /// Horizontal
    /// ```
    /// ═══════════
    /// ```
    public static var double: DividerStyle {
        DividerStyle(
            horizontal: "═",
            vertical: "║"
        )
    }
    
    /// Define a heavy line for Divider
    ///
    /// Vertical
    /// ```
    /// ┃
    /// ```
    ///
    /// Horizontal
    /// ```
    /// ━━━━━━━━━━━
    /// ```
    public static var heavy: DividerStyle {
        DividerStyle(
            horizontal: "━",
            vertical: "┃"
        )
    }
}

/// Divide a content using a vertical or horizontal line.
/// The orientation, will be defined by the parent, if `HStack` a horizontal line will be used, otherwise a vertical line.
public struct Divider: View, PrimitiveView {
    @Environment(\.stackOrientation) private var stackOrientation
    @Environment(\.foregroundColor) private var foregroundColor: Color
    @Environment(\.dividerStyle) private var style: DividerStyle

    public init() {}
    
    static var size: Int? { 1 }
    
    func buildNode(_ node: Node) {
        setupEnvironmentProperties(node: node)

        node.control = DividerControl(
          orientation: stackOrientation,
          color: foregroundColor,
          style: style
        )
    }
    
    func updateNode(_ node: Node) {
        setupEnvironmentProperties(node: node)
        node.view = self

        let control = node.control as! DividerControl
        control.orientation = stackOrientation
        control.color = foregroundColor
    }
    
    private class DividerControl: Control {
        var orientation: StackOrientation
        var color: Color
        var style: DividerStyle
      
        init(orientation: StackOrientation, color: Color, style: DividerStyle) {
            self.orientation = orientation
            self.color = color
            self.style = style
        }
        
        override func size(proposedSize: Size) -> Size {
            switch orientation {
            case .horizontal:
                Size(width: 1, height: proposedSize.height)
            case .vertical:
                Size(width: proposedSize.width, height: 1)
            }
        }
        
        override func cell(at position: Position) -> Cell? {
            switch orientation {
            case .horizontal:
                Cell(
                    char: style.vertical,
                    foregroundColor: color
                )

            case .vertical:
                Cell(
                    char: style.horizontal,
                    foregroundColor: color
                )
            }
        }
    }
}
