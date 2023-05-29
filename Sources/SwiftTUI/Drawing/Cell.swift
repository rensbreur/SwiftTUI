import Foundation

struct Cell: Equatable {
    var char: Character
    var attributes: AttributeContainer

    init(char: Character, attributes: AttributeContainer = AttributeContainer()) {
        self.char = char
        self.attributes = attributes
    }
}
