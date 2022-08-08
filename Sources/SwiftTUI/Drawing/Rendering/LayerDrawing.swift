import Foundation

protocol LayerDrawing: AnyObject {
    func cell(at position: Position) -> Cell?
}

