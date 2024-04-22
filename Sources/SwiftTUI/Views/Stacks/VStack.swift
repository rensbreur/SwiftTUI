import Foundation

public struct VStack<Content: View>: View, PrimitiveView, LayoutRootView {
    public let content: Content
    let alignment: HorizontalAlignment
    let spacing: Extended?

    /// Horizontally aligns content to the leading edge by default.
    public init(alignment: HorizontalAlignment = .leading, spacing: Extended? = nil, @ViewBuilder _ content: () -> Content) {
        self.content = content()
        self.alignment = alignment
        self.spacing = spacing
    }
    
    init(content: Content, alignment: HorizontalAlignment = .leading, spacing: Extended? = nil) {
        self.content = content
        self.alignment = alignment
        self.spacing = spacing
    }
    
    static var size: Int? { 1 }
    
    func loadData(node: Node) {
        for i in 0 ..< node.children[0].size {
            (node.control as! VStackControl).addSubview(node.children[0].control(at: i), at: i)
        }
    }
    
    func buildNode(_ node: Node) {
        node.addNode(at: 0, Node(view: content.view))
        node.control = VStackControl(alignment: alignment, spacing: spacing ?? 0)
        node.environment = { $0.stackOrientation = .vertical }
    }
    
    func updateNode(_ node: Node) {
        node.view = self
        node.children[0].update(using: content.view)
        let control = node.control as! VStackControl
        control.alignment = alignment
        control.spacing = spacing ?? 0
    }
    
    func insertControl(at index: Int, node: Node) {
        (node.control as! VStackControl).addSubview(node.children[0].control(at: index), at: index)
    }
    
    func removeControl(at index: Int, node: Node) {
        (node.control as! VStackControl).removeSubview(at: index)
    }
    
    private class VStackControl: Control {
        var alignment: HorizontalAlignment
        var spacing: Extended

        init(alignment: HorizontalAlignment, spacing: Extended) {
            self.alignment = alignment
            self.spacing = spacing
        }
        
        // MARK: - Layout
        
        override func size(proposedSize: Size) -> Size {
            var size: Size = .zero
            var remainingItems = children.count
            for control in children.sorted(by: { $0.verticalFlexibility(width: proposedSize.width) < $1.verticalFlexibility(width: proposedSize.width) }) {
                let remainingHeight = size.height == .infinity ? .infinity : (proposedSize.height - size.height)
                let childSize = control.size(proposedSize: Size(width: proposedSize.width, height: remainingHeight / Extended(remainingItems)))
                size.height += childSize.height
                if remainingItems > 1 {
                    size.height += spacing
                }
                size.width = max(size.width, childSize.width)
                remainingItems -= 1
            }
            return size
        }
        
        override func layout(size: Size) {
            super.layout(size: size)
            var remainingItems = children.count
            var remainingHeight = size.height
            for control in children.sorted(by: { $0.verticalFlexibility(width: size.width) < $1.verticalFlexibility(width: size.width) }) {
                let childSize = control.size(proposedSize: Size(width: size.width, height: remainingHeight / Extended(remainingItems)))
                control.layout(size: childSize)
                if remainingItems > 1 {
                    remainingHeight -= spacing
                }
                remainingItems -= 1
                remainingHeight -= childSize.height
            }
            var line: Extended = 0
            for control in children {
                control.layer.frame.position.line = line
                line += control.layer.frame.size.height
                line += spacing
                switch alignment {
                case .leading: control.layer.frame.position.column = 0
                case .center: control.layer.frame.position.column = (size.width - control.layer.frame.size.width) / 2
                case .trailing: control.layer.frame.position.column = size.width - control.layer.frame.size.width
                }
            }
        }
        
        // MARK: - Selection
        
        override func selectableElement(below index: Int) -> Control? {
            var index = index + 1
            while index < children.count {
                if let element = children[index].firstSelectableElement {
                    return element
                }
                index += 1
            }
            return super.selectableElement(below: index)
        }
        
        override func selectableElement(above index: Int) -> Control? {
            var index = index - 1
            while index >= 0 {
                if let element = children[index].firstSelectableElement {
                    return element
                }
                index -= 1
            }
            return super.selectableElement(above: index)
        }
    }
}
