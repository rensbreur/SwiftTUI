import Foundation

public extension View {
    // Aligns content to the top leading corner by default.
    func frame(width: Extended? = nil, height: Extended? = nil, alignment: Alignment = .topLeading) -> some View {
        FixedFrame(content: self, width: width, height: height, alignment: alignment)
    }
}

private struct FixedFrame<Content: View>: View, PrimitiveView, ModifierView {
    let content: Content
    let width: Extended?
    let height: Extended?
    let alignment: Alignment

    init(content: Content, width: Extended?, height: Extended?, alignment: Alignment) {
        self.content = content
        self.width = width
        self.height = height
        self.alignment = alignment
    }

    static var size: Int? { Content.size }

    func buildNode(_ node: Node) {
        node.controls = WeakSet<Control>()
        node.addNode(at: 0, Node(view: content.view))
    }

    func updateNode(_ node: Node) {
        node.view = self
        node.children[0].update(using: content.view)
        for control in node.controls?.values ?? [] {
            let control = control as! FixedFrameControl
            control.width = width
            control.height = height
            control.alignment = alignment
        }
    }

    func passControl(_ control: Control, node: Node) -> Control {
        if let fixedFrameControl = control.parent { return fixedFrameControl }
        let fixedFrameControl = FixedFrameControl(width: width, height: height, alignment: alignment)
        fixedFrameControl.addSubview(control, at: 0)
        node.controls?.add(fixedFrameControl)
        return fixedFrameControl
    }

    private class FixedFrameControl: Control {
        var width: Extended?
        var height: Extended?
        var alignment: Alignment

        init(width: Extended?, height: Extended?, alignment: Alignment) {
            self.width = width
            self.height = height
            self.alignment = alignment
        }

        override func size(proposedSize: Size) -> Size {
            var proposedSize = proposedSize
            proposedSize.width = width ?? proposedSize.width
            proposedSize.height = height ?? proposedSize.height
            var size = children[0].size(proposedSize: proposedSize)
            size.width = width ?? size.width
            size.height = height ?? size.height
            return size
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
