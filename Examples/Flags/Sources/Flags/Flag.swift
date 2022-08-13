import SwiftTUI

struct Flag {
    enum Orientation {
        case horizontal
        case vertical
    }
    var orientation: Orientation = .horizontal
    var colors: [Color] = [.white]
}
