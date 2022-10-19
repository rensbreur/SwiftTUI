import XCTest
@testable import SwiftTUI

final class PositionTests: XCTestCase {
    func testAdd() throws {
        let pos1 = Position(column: 1, line: 2)
        let pos2 = Position(column: 5, line: 6)
        XCTAssertEqual(pos1 + pos2, Position(column: 6, line: 8))
    }

    func testSubtract() throws {
        let pos1 = Position(column: 1, line: 2)
        let pos2 = Position(column: 5, line: 6)
        XCTAssertEqual(pos2 - pos1, Position(column: 4, line: 4))
    }
}
