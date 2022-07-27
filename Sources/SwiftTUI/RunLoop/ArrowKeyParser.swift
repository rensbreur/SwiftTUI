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

    mutating func parse(character: UInt8) -> Bool {
        if partial == 0 && character == 27 {
            partial = 1
            return true
        }
        if partial == 1 && character == 91 {
            partial = 2
            return true
        }
        if partial == 2 && character == 65 {
            arrowKey = .up
            partial = 0
            return true
        }
        if partial == 2 && character == 66 {
            arrowKey = .down
            partial = 0
            return true
        }
        if partial == 2 && character == 67 {
            arrowKey = .right
            partial = 0
            return true
        }
        if partial == 2 && character == 68 {
            arrowKey = .left
            partial = 0
            return true
        }
        arrowKey = nil
        partial = 0
        return false
    }

}
