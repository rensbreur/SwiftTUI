import Foundation

public struct Size: Equatable, CustomStringConvertible {
    public var width: Extended
    public var height: Extended

    public init(width: Extended, height: Extended) {
        self.width = width
        self.height = height
    }

    public static var zero: Size { Size(width: 0, height: 0) }

    public var description: String { "\(width)x\(height)" }
}
