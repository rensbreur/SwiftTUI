import Foundation

public extension View {
    func padding(_ edges: Edges = .all, _ length: Extended? = nil) -> some View {
        return Padding(content: self, edges: edges, length: length)
    }

    func padding(_ length: Extended) -> some View {
        return Padding(content: self, edges: .all, length: length)
    }
  
    func padding(_ edges: Edges = .all, _ length: Int) -> some View {
        return Padding(content: self, edges: edges, length: .init(length))
    }
}

private struct Padding<Content: View>: View, PrimitiveView, ModifierView {
    let content: Content
    let edges: Edges
    let length: Extended?

    static var size: Int? { Content.size }
    
    func buildNode(_ node: Node) {
        node.controls = WeakSet<Control>()
        node.addNode(at: 0, Node(view: content.view))
    }
    
    func updateNode(_ node: Node) {
        node.view = self
        node.children[0].update(using: content.view)
        for control in node.controls?.values ?? [] {
            let control = control as! PaddingControl
            control.edges = edges
            control.length = length
        }
    }
    
    func passControl(_ control: Control, node: Node) -> Control {
        if let paddingControl = control.parent { return paddingControl }
        let paddingControl = PaddingControl(edges: edges, length: length)
        paddingControl.addSubview(control, at: 0)
        node.controls?.add(paddingControl)
        return paddingControl
    }
    
    private class PaddingControl: Control {
        var edges: Edges
        var length: Extended?

        let defaultLength: Extended = 1

        init(edges: Edges, length: Extended?) {
            self.edges = edges
            self.length = length
        }

        override func size(proposedSize: Size) -> Size {
            var proposedSize = proposedSize
            proposedSize.width -= horizontalPadding
            proposedSize.height -= verticalPadding
            var size = children[0].size(proposedSize: proposedSize)
            size.width += horizontalPadding
            size.height += verticalPadding
            return size
        }
        
        override func layout(size: Size) {
            var contentSize = size
            contentSize.width -= horizontalPadding
            contentSize.height -= verticalPadding
            children[0].layout(size: contentSize)
            children[0].layer.frame.position = Position(column: leftPadding, line: topPadding)
            self.layer.frame.size = size
        }

        private var leftPadding: Extended {
            edges.contains(.left) ? (length ?? defaultLength) : 0
        }

        private var topPadding: Extended {
            edges.contains(.top) ? (length ?? defaultLength) : 0
        }

        private var horizontalPadding: Extended {
            var horizontalPadding: Extended = 0
            if edges.contains(.left) {
                horizontalPadding += length ?? defaultLength
            }
            if edges.contains(.right) {
                horizontalPadding += length ?? defaultLength
            }
            return horizontalPadding
        }

        private var verticalPadding: Extended {
            var verticalPadding: Extended = 0
            if edges.contains(.top) {
                verticalPadding += length ?? defaultLength
            }
            if edges.contains(.bottom) {
                verticalPadding += length ?? defaultLength
            }
            return verticalPadding
        }
    }
}
