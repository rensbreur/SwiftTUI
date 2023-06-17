import Foundation

class Renderer {
    var layer: Layer

    /// Even though we only redraw invalidated parts of the screen, terminal
    /// drawing is currently still slow, as it involves moving the cursor
    /// position and printing a character there.
    /// This cache stores the screen content to see if printing is necessary.
    private var cache: [[Cell?]] = []

    /// The current cursor position, which might need to be updated before
    /// printing.
    private var currentPosition: Position = .zero

    private var currentForegroundColor: Color? = nil
    private var currentBackgroundColor: Color? = nil

    private var currentAttributes = CellAttributes()

    weak var application: Application?

    init(layer: Layer) {
        self.layer = layer
        setCache()
        setup()
    }

    /// Draw only the invalidated part of the layer.
    func update() {
        if let invalidated = layer.invalidated {
            draw(rect: invalidated)
            layer.invalidated = nil
        }
    }

    func setCache() {
        cache = .init(repeating: .init(repeating: nil, count: layer.frame.size.width), count: layer.frame.size.height)
    }

    /// Draw a specific area, or the entire layer if the area is nil.
    func draw(rect: Rect? = nil) {
        if rect == nil { layer.invalidated = nil }
        let rect = rect ?? Rect(position: .zero, size: layer.frame.size)
        guard rect.size.width > 0, rect.size.height > 0 else {
            assertionFailure("Trying to draw in empty rect")
            return
        }
        for line in rect.minLine ... rect.maxLine {
            for column in rect.minColumn ... rect.maxColumn {
                let position = Position(column: column, line: line)
                if let cell = layer.cell(at: position) {
                    drawPixel(cell, at: Position(column: column, line: line))
                }
            }
        }
    }

    func stop() {
        disableAlternateBuffer()
        showCursor()
    }

    private func drawPixel(_ cell: Cell, at position: Position) {
        guard position.column >= 0, position.line >= 0, position.column < layer.frame.size.width, position.line < layer.frame.size.height else {
            return
        }
        if cache[position.line][position.column] != cell {
            cache[position.line][position.column] = cell
            if self.currentPosition != position {
                moveTo(position)
                self.currentPosition = position
            }
            if self.currentForegroundColor != cell.foregroundColor {
                setForegroundColor(cell.foregroundColor)
                self.currentForegroundColor = cell.foregroundColor
            }
            let backgroundColor = cell.backgroundColor ?? .default
            if self.currentBackgroundColor != backgroundColor {
                setBackgroundColor(backgroundColor)
                self.currentBackgroundColor = backgroundColor
            }
            self.updateAttributes(cell.attributes)
            output(String(cell.char))
            self.currentPosition.column += 1
        }
    }

    private func setup() {
        enableAlternateBuffer()
        clearScreen()
        moveTo(currentPosition)
        hideCursor()
    }

    private func clearScreen() {
        output("\u{1b}[2J")
    }

    private func enableAlternateBuffer() {
        output("\u{1b}[?1049h")
    }

    private func hideCursor() {
        output("\u{1b}[?25l")
    }

    private func showCursor() {
        output("\u{1b}[?25h")
    }

    private func setForegroundColor(_ color: Color) {
        output("\u{1b}[\(color.foregroundCode)m")
    }

    private func setBackgroundColor(_ color: Color) {
        output("\u{1b}[\(color.backgroundCode)m")
    }

    private func moveTo(_ position: Position) {
        output("\u{1b}[\(position.line + 1);\(position.column + 1)H")
    }

    private func updateAttributes(_ attributes: CellAttributes) {
        if currentAttributes.bold != attributes.bold {
            if attributes.bold { enableBold() }
            else { disableBold() }
        }
        if currentAttributes.italic != attributes.italic {
            if attributes.italic { enableItalic() }
            else { disableItalic() }
        }
        if currentAttributes.underline != attributes.underline {
            if attributes.underline { enableUnderline() }
            else { disableUnderline() }
        }
        if currentAttributes.strikethrough != attributes.strikethrough {
            if attributes.strikethrough { enableStrikethrough() }
            else { disableStrikethrough() }
        }
        if currentAttributes.inverted != attributes.inverted {
            if attributes.inverted { enableInverted() }
            else { disableInverted() }
        }
        currentAttributes = attributes
    }

    private func enableBold() {
        output("\u{1b}[1m")
    }

    private func disableBold() {
        output("\u{1b}[22m")
    }

    private func enableItalic() {
        output("\u{1b}[3m")
    }

    private func disableItalic() {
        output("\u{1b}[23m")
    }

    private func enableUnderline() {
        output("\u{1b}[4m")
    }

    private func disableUnderline() {
        output("\u{1b}[24m")
    }

    private func enableStrikethrough() {
        output("\u{1b}[9m")
    }

    private func disableStrikethrough() {
        output("\u{1b}[29m")
    }

    private func enableInverted() {
        output("\u{1b}[7m")
    }

    private func disableInverted() {
        output("\u{1b}[27m")
    }

    private func disableAlternateBuffer() {
        output("\u{1b}[?1049l")
    }

    private func output(_ str: String) {
        str.withCString { _ = write(STDOUT_FILENO, $0, strlen($0)) }
    }
}
