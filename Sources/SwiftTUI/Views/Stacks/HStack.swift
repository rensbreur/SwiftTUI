import Foundation

public struct HStack<Content: View>: View, PrimitiveView, LayoutRootView {
    public let content: Content
    let alignment: VerticalAlignment
    let spacing: Extended?

    /// Vertically aligns content to the top by default.
    public init(alignment: VerticalAlignment = .top, spacing: Extended? = nil, @ViewBuilder _ content: () -> Content) {
        self.content = content()
        self.alignment = alignment
        self.spacing = spacing
    }

    static var size: Int? { 1 }

    func loadData(node: Node) {
        for i in 0 ..< node.children[0].size {
            (node.control as! HStackControl).addSubview(node.children[0].control(at: i), at: i)
        }
    }

    func buildNode(_ node: Node) {
        node.addNode(at: 0, Node(view: content.view))
        node.control = HStackControl(alignment: alignment, spacing: spacing ?? 1)
        node.environment = { $0.stackOrientation = .horizontal }
    }

    func updateNode(_ node: Node) {
        node.view = self
        node.children[0].update(using: content.view)
        let control = node.control as! HStackControl
        control.alignment = alignment
        control.spacing = spacing ?? 1
    }

    func insertControl(at index: Int, node: Node) {
        (node.control as! HStackControl).addSubview(node.children[0].control(at: index), at: index)
    }

    func removeControl(at index: Int, node: Node) {
        (node.control as! HStackControl).removeSubview(at: index)
    }

    private class HStackControl: Control {
        var alignment: VerticalAlignment
        var spacing: Extended

        init(alignment: VerticalAlignment, spacing: Extended) {
            self.alignment = alignment
            self.spacing = spacing
        }

        // MARK: - Layout

        override func size(proposedSize: Size) -> Size {
            var size: Size = .zero
            var remainingItems = children.count
            for control in children.sorted(by: { $0.horizontalFlexibility(height: proposedSize.height) < $1.horizontalFlexibility(height: proposedSize.height) }) {
                let remainingWidth = (size.width == .infinity) ? .infinity : (proposedSize.width - size.width)
                let childSize = control.size(proposedSize: Size(width: remainingWidth / Extended(remainingItems), height: proposedSize.height))
                size.width += childSize.width
                if remainingItems > 1 {
                    size.width += spacing
                }
                size.height = max(size.height, childSize.height)
                remainingItems -= 1
            }
            return size
        }

        override func layout(size: Size) {
            super.layout(size: size)
            var remainingItems = children.count
            var remainingWidth = size.width
            for control in children.sorted(by: { $0.horizontalFlexibility(height: size.height) < $1.horizontalFlexibility(height: size.height) }) {
                let childSize = control.size(proposedSize: Size(width: remainingWidth / Extended(remainingItems), height: size.height))
                control.layout(size: childSize)
                if remainingItems > 1 {
                    remainingWidth -= spacing
                }
                remainingItems -= 1
                remainingWidth -= childSize.width
            }
            var column: Extended = 0
            for control in children {
                control.layer.frame.position.column = column
                column += control.layer.frame.size.width
                column += spacing
                switch alignment {
                case .top: control.layer.frame.position.line = 0
                case .center: control.layer.frame.position.line = (size.height - control.layer.frame.size.height) / 2
                case .bottom: control.layer.frame.position.line = size.height - control.layer.frame.size.height
                }
            }
        }

        // MARK: - Selection

        override func selectableElement(rightOf index: Int) -> Control? {
            var index = index + 1
            while index < children.count {
                if let element = children[index].firstSelectableElement {
                    return element
                }
                index += 1
            }
            return super.selectableElement(rightOf: index)
        }

        override func selectableElement(leftOf index: Int) -> Control? {
            var index = index - 1
            while index >= 0 {
                if let element = children[index].firstSelectableElement {
                    return element
                }
                index -= 1
            }
            return super.selectableElement(leftOf: index)
        }
    }
}
