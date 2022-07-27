import Foundation

public class Application<I: View> {
    public let rootView: I

    public init(rootView: I) {
        self.rootView = rootView
    }

    public func start() {
        let node = Node(viewWrapper: ViewWrapper(view: VStack { rootView }))
        node.build()

        let view = node.control!

        let window = Window()
        window.layer.frame.size = Size(width: 100, height: 50)
        window.addControl(view)

        window.firstResponder = view.firstSelectableElement
        window.firstResponder?.becomeFirstResponder()

        view.layout(size: Size(width: 100, height: 50))
        let renderer = Renderer(layer: window.layer)
        renderer.draw()

        setInputMode()

        var char: UInt8 = 0
        var arrowKeyParser = ArrowKeyParser()

        while read(STDIN_FILENO, &char, 1) == 1 {
            // Handle key
            if arrowKeyParser.parse(character: char) {
                guard let key = arrowKeyParser.arrowKey else { continue }
                arrowKeyParser.arrowKey = nil
                if key == .down {
                    if let next = window.firstResponder?.selectableElement(below: 0) {
                        window.firstResponder?.resignFirstResponder()
                        window.firstResponder = next
                        window.firstResponder?.becomeFirstResponder()
                    }
                } else if key == .up {
                    if let next = window.firstResponder?.selectableElement(above: 0) {
                        window.firstResponder?.resignFirstResponder()
                        window.firstResponder = next
                        window.firstResponder?.becomeFirstResponder()
                    }
                }
            } else if char == 4 {
                renderer.stop()
                exit(0)
            } else {
                window.firstResponder?.handleEvent(char)
            }

            // Update
            for node in Node.invalidatedNodes {
                node.update(using: node.viewWrapper)
            }
            Node.invalidatedNodes = []

            node.control!.layout(size: Size(width: 100, height: 50))
            renderer.update()
        }

    }

    private func setInputMode() {
        var tattr = termios()
        tcgetattr(STDIN_FILENO, &tattr)
        tattr.c_lflag &= ~UInt(ECHO | ICANON)
        tcsetattr(STDIN_FILENO, TCSAFLUSH, &tattr);
    }

}
