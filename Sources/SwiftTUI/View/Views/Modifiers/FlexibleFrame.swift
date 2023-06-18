import Foundation

public extension View {
    func frame(
        minWidth: Int? = nil,
        maxWidth: Int? = nil,
        minHeight: Int? = nil,
        maxHeight: Int? = nil,
        alignment: Alignment = .center
    ) -> some View {
        FlexibleFrame(content: self, minWidth: minWidth, maxWidth: maxWidth, minHeight: minHeight, maxHeight: maxHeight, alignment: alignment)
    }
}

private struct FlexibleFrame<Content: View>: View, PrimitiveView, Modifier {
    let content: Content
    let minWidth: Int?
    let maxWidth: Int?
    let minHeight: Int?
    let maxHeight: Int?
    let alignment: Alignment

    static var size: Int? { Content.size }

    func buildNode(_ node: Node) {
        node.addNode(at: 0, Node(view: content.view))
    }

    func updateNode(_ node: Node) {
        node.view = self
        node.children[0].update(using: content.view)
    }

    func passControl(_ control: Control) -> Control {
        if let fixedFrameControl = control.parent { return fixedFrameControl }
        let fixedFrameControl = FlexibleFrameControl(minWidth: minWidth, maxWidth: maxWidth, minHeight: minHeight, maxHeight: maxHeight, alignment: alignment)
        fixedFrameControl.addSubview(control, at: 0)
        return fixedFrameControl
    }

}

private class FlexibleFrameControl: Control {
    var minWidth: Int?
    var maxWidth: Int?
    var minHeight: Int?
    var maxHeight: Int?
    var alignment: Alignment

    init(minWidth: Int?, maxWidth: Int?, minHeight: Int?, maxHeight: Int?, alignment: Alignment) {
        self.minWidth = minWidth
        self.maxWidth = maxWidth
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.alignment = alignment
    }

    override func size(proposedSize: Size) -> Size {
        var proposedSize = proposedSize
        proposedSize.width = min(maxWidth ?? .max, max(minWidth ?? 0, proposedSize.width))
        proposedSize.height = min(maxHeight ?? .max, max(minHeight ?? 0, proposedSize.height))
        let size = children[0].size(proposedSize: proposedSize)
        if minHeight == nil, maxHeight == nil {
            proposedSize.height = size.height
        }
        if minWidth == nil, maxWidth == nil {
            proposedSize.width = size.width
        }
        return proposedSize
    }

    override func layout(size: Size) {
        super.layout(size: size)
        children[0].layout(size: children[0].size(proposedSize: size))
        switch alignment.verticalAlignment {
        case .top: children[0].layer.frame.position.line = 0
        case .center: children[0].layer.frame.position.line = (size.height - children[0].layer.frame.size.height) / 2
        case .bottom: children[0].layer.frame.position.line = size.height - children[0].layer.frame.size.height
        }
        switch alignment.horizontalAlignment {
        case .leading: children[0].layer.frame.position.column = 0
        case .center: children[0].layer.frame.position.column = (size.width - children[0].layer.frame.size.width) / 2
        case .trailing: children[0].layer.frame.position.column = size.width - children[0].layer.frame.size.width
        }
    }

}
