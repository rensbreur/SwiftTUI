import Foundation

struct Rect {
    var position: Position
    var size: Size

    init(position: Position, size: Size) {
        self.position = position
        self.size = size
    }

    init(minColumn: Int, minLine: Int, maxColumn: Int, maxLine: Int) {
        self.position = Position(column: minColumn, line: minLine)
        self.size = Size(width: maxColumn - minColumn + 1, height: maxLine - minLine + 1)
    }

    init(column: Int, line: Int, width: Int, height: Int) {
        self.position = Position(column: column, line: line)
        self.size = Size(width: width, height: height)
    }

    static var zero: Rect { Rect(position: .zero, size: .zero) }

    var minLine: Int { position.line }
    var minColumn: Int { position.column }
    var maxLine: Int { position.line + size.height - 1 }
    var maxColumn: Int { position.column + size.width - 1 }
}
