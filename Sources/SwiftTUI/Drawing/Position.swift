import Foundation

struct Position: Equatable, CustomStringConvertible {
    var column: Int
    var line: Int

    static var zero: Position { Position(column: 0, line: 0) }

    var description: String { "(\(column), \(line))" }
}
