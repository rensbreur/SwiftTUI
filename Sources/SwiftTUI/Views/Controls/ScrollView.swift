import Foundation

/// Automatically scrolls to the currently active control. The content needs to contain controls
/// such as buttons to scroll to.
public struct ScrollView<Content: View>: View, PrimitiveView {
    let content: VStack<Content>

    public init(@ViewBuilder _ content: () -> Content) {
        self.content = VStack(content: content())
    }

    static var size: Int? { 1 }

    func buildNode(_ node: Node) {
        node.addNode(at: 0, Node(view: content.view))
        let control = ScrollControl()
        control.contentControl = node.children[0].control(at: 0)
        control.addSubview(control.contentControl, at: 0)
        node.control = control
    }

    func updateNode(_ node: Node) {
        node.view = self
        node.children[0].update(using: content.view)
    }

    private class ScrollControl: Control {
        var contentControl: Control!
        var contentOffset: Extended = 0

        override func layout(size: Size) {
            super.layout(size: size)
            let contentSize = contentControl.size(proposedSize: .zero)
            contentControl.layout(size: contentSize)
            contentControl.layer.frame.position.line = -contentOffset
        }

        override func scroll(to position: Position) {
            let destination = position.line - contentControl.layer.frame.position.line
            guard layer.frame.size.height > 0 else { return }
            if contentOffset > destination {
                contentOffset = destination
            } else if contentOffset < destination - layer.frame.size.height + 1 {
                contentOffset = destination - layer.frame.size.height + 1
            }
        }
    }
}
