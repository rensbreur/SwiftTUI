import Foundation

struct Size: Equatable {
    var width: Int
    var height: Int

    static var zero: Size { Size(width: 0, height: 0) }
}
