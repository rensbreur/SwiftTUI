import Foundation

struct ArrowKeyParser {
    enum ArrowKey {
        case up
        case down
        case right
        case left
    }

    private var partial: Int = 0

    var arrowKey: ArrowKey?

    mutating func parse(character: Character) -> Bool {
        if partial == 0 && character == "\u{1b}" {
            partial = 1
            return true
        }
        if partial == 1 && character == "[" {
            partial = 2
            return true
        }
        if partial == 2 && character == "A" {
            arrowKey = .up
            partial = 0
            return true
        }
        if partial == 2 && character == "B" {
            arrowKey = .down
            partial = 0
            return true
        }
        if partial == 2 && character == "C" {
            arrowKey = .right
            partial = 0
            return true
        }
        if partial == 2 && character == "D" {
            arrowKey = .left
            partial = 0
            return true
        }
        arrowKey = nil
        partial = 0
        return false
    }

}
