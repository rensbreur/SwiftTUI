import Foundation

struct Position: Equatable {
    var column: Extended
    var line: Extended

    static var zero: Position { Position(column: 0, line: 0) }
}

extension Position: CustomStringConvertible {
    var description: String { "(\(column), \(line))" }
}

extension Position: AdditiveArithmetic {
    static func +(lhs: Self, rhs: Self) -> Self {
        Position(column: lhs.column + rhs.column, line: lhs.line + rhs.line)
    }

    static func - (lhs: Position, rhs: Position) -> Position {
        Position(column: lhs.column - rhs.column, line: lhs.line - rhs.line)
    }
}
