import Foundation

public struct HStack<Content: View>: View, PrimitiveView, ViewContainer {
    public let content: Content
    let alignment: VerticalAlignment
    let spacing: Int?

    public init(alignment: VerticalAlignment = .top, spacing: Int? = nil, @ViewBuilder _ content: () -> Content) {
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
        node.addNode(at: 0, Node(viewWrapper: ViewWrapper(view: content)))
        node.control = HStackControl(alignment: alignment, spacing: spacing ?? 1)
    }

    func updateNode(_ node: Node) {
        node.viewWrapper = ViewWrapper(view: self)
        node.children[0].update(using: ViewWrapper(view: content))
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

}

private class HStackControl: Control {
    var alignment: VerticalAlignment
    var spacing: Int

    init(alignment: VerticalAlignment, spacing: Int) {
        self.alignment = alignment
        self.spacing = spacing
    }

    // MARK: - Layout

    override func size(proposedSize: Size) -> Size {
        var size: Size = .zero
        var remainingItems = children.count
        for control in children.sorted(by: { $0.layoutPriority > $1.layoutPriority }) {
            let childSize = control.size(proposedSize: Size(width: (proposedSize.width - size.width) / remainingItems, height: proposedSize.height))
            size.width += childSize.width
            if remainingItems > 1 {
                size.width += spacing
            }
            if !control.isSpacer {
                size.height = max(size.height, childSize.height)
            }
            remainingItems -= 1
        }
        return size
    }

    override func layout(size: Size) {
        super.layout(size: size)
        var remainingItems = children.count
        var remainingWidth = size.width
        for control in children.sorted(by: { $0.layoutPriority > $1.layoutPriority }) {
            let childSize = control.size(proposedSize: Size(width: remainingWidth / remainingItems, height: size.height))
            control.layout(size: childSize)
            if remainingItems > 1 {
                remainingWidth -= spacing
            }
            remainingItems -= 1
            remainingWidth -= childSize.width
        }
        var column = 0
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

    override var layoutPriority: Double { children.filter { !$0.isSpacer }.map(\.layoutPriority).max() ?? 0 }

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
