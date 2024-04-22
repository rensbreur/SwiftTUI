import Foundation

public extension View {
    /// Aligns content to the top leading corner by default. Use the `.infinity` value for
    /// `maxWidth` or `maxHeight` to allow views to take up all space.
    func frame(
        minWidth: Extended? = nil,
        maxWidth: Extended? = nil,
        minHeight: Extended? = nil,
        maxHeight: Extended? = nil,
        alignment: Alignment = .center
    ) -> some View {
        FlexibleFrame(content: self, minWidth: minWidth, maxWidth: maxWidth, minHeight: minHeight, maxHeight: maxHeight, alignment: alignment)
    }
}

private struct FlexibleFrame<Content: View>: View, PrimitiveView, ModifierView {
    let content: Content
    let minWidth: Extended?
    let maxWidth: Extended?
    let minHeight: Extended?
    let maxHeight: Extended?
    let alignment: Alignment
    
    static var size: Int? { Content.size }
    
    func buildNode(_ node: Node) {
        node.controls = WeakSet<Control>()
        node.addNode(at: 0, Node(view: content.view))
    }
    
    func updateNode(_ node: Node) {
        node.view = self
        node.children[0].update(using: content.view)
        for control in node.controls?.values ?? [] {
            let control = control as! FlexibleFrameControl
            control.minWidth = minWidth
            control.maxWidth = maxWidth
            control.minWidth = minHeight
            control.maxHeight = maxHeight
            control.alignment = alignment
        }
    }
    
    func passControl(_ control: Control, node: Node) -> Control {
        if let fixedFrameControl = control.parent { return fixedFrameControl }
        let fixedFrameControl = FlexibleFrameControl(minWidth: minWidth, maxWidth: maxWidth, minHeight: minHeight, maxHeight: maxHeight, alignment: alignment)
        fixedFrameControl.addSubview(control, at: 0)
        node.controls?.add(fixedFrameControl)
        return fixedFrameControl
    }
    
    private class FlexibleFrameControl: Control {
        var minWidth: Extended?
        var maxWidth: Extended?
        var minHeight: Extended?
        var maxHeight: Extended?
        var alignment: Alignment
        
        init(minWidth: Extended?, maxWidth: Extended?, minHeight: Extended?, maxHeight: Extended?, alignment: Alignment) {
            self.minWidth = minWidth
            self.maxWidth = maxWidth
            self.minHeight = minHeight
            self.maxHeight = maxHeight
            self.alignment = alignment
        }
        
        override func size(proposedSize: Size) -> Size {
            var proposedSize = proposedSize
            proposedSize.width = min(maxWidth ?? .infinity, max(minWidth ?? 0, proposedSize.width))
            proposedSize.height = min(maxHeight ?? .infinity, max(minHeight ?? 0, proposedSize.height))
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
}
