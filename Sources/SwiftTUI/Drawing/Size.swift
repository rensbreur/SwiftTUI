import Foundation

struct Size: Equatable, CustomStringConvertible {
    var width: Int
    var height: Int

    static var zero: Size { Size(width: 0, height: 0) }

    var description: String { "\(width)x\(height)" }
}
