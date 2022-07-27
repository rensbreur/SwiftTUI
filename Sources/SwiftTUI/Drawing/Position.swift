import Foundation

struct Position: Equatable {
    var column: Int
    var line: Int

    static var zero: Position { Position(column: 0, line: 0) }
}
