import Foundation

class Renderer {
    var layer: Layer

    /// Even though we only redraw invalidated parts of the screen, terminal
    /// drawing is currently still slow, as it involves moving the cursor
    /// position and printing a character there.
    /// This cache stores the screen content to see if printing is necessary.
    private var cache: [[Cell]]

    /// The current cursor position, which might need to be updated before
    /// printing.
    private var currentPosition: Position = .zero

    private var currentForegroundColor: Color? = nil
    private var currentBackgroundColor: Color? = nil

    init(layer: Layer) {
        self.layer = layer
        let cell = Cell(char: " ")
        cache = .init(repeating: .init(repeating: cell, count: layer.frame.size.width), count: layer.frame.size.height)
        setup()
    }

    /// Draw only the invalidated part of the layer.
    func update() {
        if let invalidated = layer.invalidated {
            draw(rect: invalidated)
            layer.invalidated = nil
        }
    }

    /// Draw a specific area, or the entire layer if the area is nil.
    func draw(rect: Rect? = nil) {
        if rect == nil { layer.invalidated = nil }
        let rect = rect ?? Rect(position: .zero, size: layer.frame.size)
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
        restoreScreen()
        showCursor()
    }

    private func drawPixel(_ cell: Cell, at position: Position) {
        if cache[position.line][position.column] != cell {
            cache[position.line][position.column] = cell
            if self.currentPosition != position {
                moveTo(position)
                self.currentPosition = position
            }
            if self.currentForegroundColor != cell.foregroundColor {
                setForegroundColor(cell.foregroundColor ?? .white)
                self.currentForegroundColor = cell.foregroundColor
            }
            if self.currentBackgroundColor != cell.backgroundColor {
                setBackgroundColor(cell.backgroundColor ?? .black)
                self.currentBackgroundColor = cell.backgroundColor
            }
            write(String(cell.char))
            self.currentPosition.column += 1
        }
    }

    private func setup() {
        saveScreen()
        clearScreen()
        moveTo(currentPosition)
        hideCursor()
    }

    private func clearScreen() {
        write("\u{1b}[2J")
    }

    private func enableAlternateBuffer() {
        write("\u{1b}[?1049h")
    }

    private func hideCursor() {
        write("\u{1b}[?25l")
    }

    private func showCursor() {
        write("\u{1b}[?25h")
    }

    private func setForegroundColor(_ color: Color) {
        write("\u{1b}[\(color.foregroundCode)m")
    }

    private func setBackgroundColor(_ color: Color) {
        write("\u{1b}[\(color.backgroundCode)m")
    }

    private func moveTo(_ position: Position) {
        write("\u{1b}[\(position.line + 1);\(position.column + 1)H")
    }

    private func disableAlternateBuffer() {
        write("\u{1b}[?1049l")
    }

    private func write(_ str: String) {
        str.withCString {
#if os(Linux)
            _ = Glibc.write(STDOUT_FILENO, $0, strlen($0))
#else
            _ = Darwin.write(STDOUT_FILENO, $0, strlen($0))
#endif
        }
    }
}
