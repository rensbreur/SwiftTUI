import Foundation

public extension View {
    func border(_ color: Color? = nil, style: BorderStyle = .default) -> some View {
        return Border(content: self, color: color, style: style)
    }
  
    func border(_ style: BorderStyle = .default) -> some View {
        Border(content: self, color: nil, style: style)
    }
}

public struct BorderStyle: Equatable {
    let topLeft: Character
    let top: Character
    let topRight: Character
    let left: Character
    let right: Character
    let bottomLeft: Character
    let bottom: Character
    let bottomRight: Character

    public init(topLeft: Character, top: Character, topRight: Character, left: Character, right: Character, bottomLeft: Character, bottom: Character, bottomRight: Character) {
        self.topLeft = topLeft
        self.top = top
        self.topRight = topRight
        self.left = left
        self.right = right
        self.bottomLeft = bottomLeft
        self.bottom = bottom
        self.bottomRight = bottomRight
    }

    public init(topLeft: Character, topRight: Character, bottomLeft: Character, bottomRight: Character, horizontal: Character, vertical: Character) {
        self.topLeft = topLeft
        self.top = horizontal
        self.topRight = topRight
        self.left = vertical
        self.right = vertical
        self.bottomLeft = bottomLeft
        self.bottom = horizontal
        self.bottomRight = bottomRight
    }

    /// ```
    /// ┌──┐
    /// └──┘
    /// ```
    public static var `default`: BorderStyle {
        BorderStyle(topLeft: "┌", topRight: "┐", bottomLeft: "└", bottomRight: "┘", horizontal: "─", vertical: "│")
    }

    /// ```
    /// ╭──╮
    /// ╰──╯
    /// ```
    public static var rounded: BorderStyle {
        BorderStyle(topLeft: "╭", topRight: "╮", bottomLeft: "╰", bottomRight: "╯", horizontal: "─", vertical: "│")
    }

    /// ```
    /// ┏━━┓
    /// ┗━━┛
    /// ```
    public static var heavy: BorderStyle {
        BorderStyle(topLeft: "┏", topRight: "┓", bottomLeft: "┗", bottomRight: "┛", horizontal: "━", vertical: "┃")
    }

    /// ```
    /// ╔══╗
    /// ╚══╝
    /// ```
    public static var double: BorderStyle {
        BorderStyle(topLeft: "╔", topRight: "╗", bottomLeft: "╚", bottomRight: "╝", horizontal: "═", vertical: "║")
    }
}

private struct Border<Content: View>: View, PrimitiveView, ModifierView {
    let content: Content
    let color: Color?
    let style: BorderStyle
    @Environment(\.foregroundColor) var foregroundColor: Color
    
    static var size: Int? { Content.size }
    
    func buildNode(_ node: Node) {
        setupEnvironmentProperties(node: node)
        node.controls = WeakSet<Control>()
        node.addNode(at: 0, Node(view: content.view))
    }
    
    func updateNode(_ node: Node) {
        setupEnvironmentProperties(node: node)
        node.view = self
        node.children[0].update(using: content.view)
        for control in node.controls?.values ?? [] {
            let control = control as! BorderControl
            if control.color != color || control.style != style {
                control.color = color ?? foregroundColor
                control.style = style
                control.layer.invalidate()
            }
        }
    }
    
    func passControl(_ control: Control, node: Node) -> Control {
        if let borderControl = control.parent { return borderControl }
        let borderControl = BorderControl(color: color ?? foregroundColor, style: style)
        borderControl.addSubview(control, at: 0)
        node.controls?.add(borderControl)
        return borderControl
    }
    
    private class BorderControl: Control {
        var color: Color
        var style: BorderStyle

        init(color: Color, style: BorderStyle) {
            self.color = color
            self.style = style
        }
        
        override func size(proposedSize: Size) -> Size {
            var proposedSize = proposedSize
            proposedSize.width -= 2
            proposedSize.height -= 2
            var size = children[0].size(proposedSize: proposedSize)
            size.width += 2
            size.height += 2
            return size
        }
        
        override func layout(size: Size) {
            var contentSize = size
            contentSize.width -= 2
            contentSize.height -= 2
            children[0].layout(size: contentSize)
            children[0].layer.frame.position = Position(column: 1, line: 1)
            self.layer.frame.size = size
        }
        
        override func cell(at position: Position) -> Cell? {
            var char: Character?
            if position.line == 0 {
                if position.column == 0 {
                    char = style.topLeft
                } else if position.column == layer.frame.size.width - 1 {
                    char = style.topRight
                } else {
                    char = style.top
                }
            } else if position.line == layer.frame.size.height - 1 {
                if position.column == 0 {
                    char = style.bottomLeft
                } else if position.column == layer.frame.size.width - 1 {
                    char = style.bottomRight
                } else {
                    char = style.bottom
                }
            } else if position.column == 0 {
                char = style.left
            } else if position.column == layer.frame.size.width - 1 {
                char = style.right
            }
            return char.map { Cell(char: $0, foregroundColor: color) }
        }
    }
}
