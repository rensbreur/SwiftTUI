import XCTest
@testable import SwiftTUI

final class RectTests: XCTestCase {
    func testUnion() throws {
        let rect1 = Rect(position: Position(column: 1, line: 2), size: Size(width: 5, height: 8))
        let rect2 = Rect(position: Position(column: 3, line: 1), size: Size(width: 2, height: 4))
        let expected = Rect(position: Position(column: 1, line: 1), size: Size(width: 5, height: 9))
        XCTAssertEqual(rect1.union(rect2), expected)
    }
}
