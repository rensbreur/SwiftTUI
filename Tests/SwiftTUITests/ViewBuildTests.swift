import XCTest
@testable import SwiftTUI

final class ViewBuildTests: XCTestCase {
    func test_VStack_TupleView2() throws {
        struct MyView: View {
            var body: some View {
                VStack {
                    Text("One")
                    Text("Two")
                }
            }
        }

        let control = try buildView(MyView())

        XCTAssertEqual(control.treeDescription, """
            → VStackControl
              → TextControl
              → TextControl
            """)
    }

    func test_conditional_VStack() throws {
        struct MyView: View {
            @State var value = true

            var body: some View {
                if value {
                    VStack {
                        Text("One")
                    }
                }
            }
        }

        let control = try buildView(MyView())

        XCTAssertEqual(control.treeDescription, """
            → VStackControl
              → TextControl
            """)
    }

    private func buildView<V: View>(_ view: V) throws -> Control {
        let node = Node(view: VStack(content: view).view)
        node.build()
        return try XCTUnwrap(node.control?.children.first)
    }

}
