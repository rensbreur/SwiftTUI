import Foundation

class Layer {
    private(set) var children: [Layer] = []
    private(set) var parent: Layer?

    weak var control: Control?

    var invalidated: Rect?

    weak var renderer: Renderer?

    var frame: Rect = .zero {
        didSet {
            if oldValue != frame {
                parent?.invalidate(rect: oldValue)
                parent?.invalidate(rect: frame)
            }
        }
    }

    func addLayer(_ layer: Layer, at index: Int) {
        self.children.insert(layer, at: index)
        layer.parent = self
    }

    func removeLayer(at index: Int) {
        children[index].parent = nil
        self.children.remove(at: index)
    }

    func invalidate() {
        invalidate(rect: Rect(position: .zero, size: frame.size))
    }

    /// This recursively invalidates the same rect in the parent, in the
    /// parent's coordinate system.
    /// If the parent is the root layer, it sets the `invalidated` rect instead.
    func invalidate(rect: Rect) {
        if let parent = self.parent {
            parent.invalidate(rect: Rect(position: Position(column: rect.position.column + frame.position.column, line: rect.position.line + frame.position.line), size: rect.size))
            return
        }
        guard let invalidated = self.invalidated else {
            self.invalidated = rect
            return
        }
        self.invalidated = Rect(minColumn: min(rect.minColumn, invalidated.minColumn), minLine: min(rect.minLine, invalidated.minLine), maxColumn: max(rect.maxColumn, invalidated.maxColumn), maxLine: max(rect.maxLine, invalidated.maxLine))
    }

    func cell(at position: Position) -> Cell? {
        var char: Character? = nil
        var foregroundColor: Color? = nil
        var backgroundColor: Color? = nil

        // Draw children
        for child in children {
            let position = Position(column: position.column - child.frame.position.column, line: position.line - child.frame.position.line)
            guard position.line >= 0, position.column >= 0, position.column < child.frame.size.width, position.line < child.frame.size.height else { continue }
            if let cell = child.cell(at: position) {
                if char == nil { char = cell.char; foregroundColor = cell.foregroundColor }
                if let color = cell.backgroundColor { backgroundColor = color }
                if char != nil && backgroundColor != nil { break }
            }
        }

        // Draw control's content as background
        if (char == nil || backgroundColor == nil), let cell = control?.cell(at: position) {
            if char == nil {
                char = cell.char
                foregroundColor = cell.foregroundColor
            }
            if backgroundColor == nil, let color = cell.backgroundColor { backgroundColor = color }
        }

        return char.map { Cell(char: $0, foregroundColor: foregroundColor, backgroundColor: backgroundColor) }
    }

}
