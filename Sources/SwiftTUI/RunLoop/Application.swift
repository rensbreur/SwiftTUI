import Foundation

public class Application<I: View> {
    public let rootView: I

    private let node: Node
    private let window: Window
    private let control: Control
    private let renderer: Renderer

    private var arrowKeyParser = ArrowKeyParser()

    public init(rootView: I) {
        self.rootView = rootView

        node = Node(viewWrapper: ViewWrapper(view: VStack(content: rootView)))
        node.build()

        control = node.control!

        window = Window()
        window.addControl(control)

        window.firstResponder = control.firstSelectableElement
        window.firstResponder?.becomeFirstResponder()

        renderer = Renderer(layer: window.layer)
    }

    public func start() {
        setInputMode()
        updateWindowSize()
        control.layout(size: window.layer.frame.size)
        renderer.draw()

        let stdInSource = DispatchSource.makeReadSource(fileDescriptor: STDIN_FILENO, queue: .main)
        stdInSource.setEventHandler(qos: .default, flags: [], handler: self.handleInput)
        stdInSource.resume()

        let sigWinChSource = DispatchSource.makeSignalSource(signal: SIGWINCH, queue: .main)
        sigWinChSource.setEventHandler(qos: .default, flags: [], handler: self.handleWindowSizeChange)
        sigWinChSource.resume()

        dispatchMain()

    }

    private func setInputMode() {
        var tattr = termios()
        tcgetattr(STDIN_FILENO, &tattr)
#if os(Linux)
        tattr.c_lflag &= ~UInt32(ECHO | ICANON)
#else
        tattr.c_lflag &= ~UInt(ECHO | ICANON)
#endif
        tcsetattr(STDIN_FILENO, TCSAFLUSH, &tattr);
    }

    private func handleInput() {
        var char: UInt8 = 0
        _ = read(STDIN_FILENO, &char, 1)

        if arrowKeyParser.parse(character: char) {
            guard let key = arrowKeyParser.arrowKey else { return }
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

        runLoopCycleEnd()
    }

    private func runLoopCycleEnd() {
        for node in Node.invalidatedNodes {
            node.update(using: node.viewWrapper)
        }
        Node.invalidatedNodes = []

        control.layout(size: window.layer.frame.size)
        renderer.update()
    }

    private func handleWindowSizeChange() {
        updateWindowSize()
        runLoopCycleEnd()
    }

    private func updateWindowSize() {
        var size = winsize()
        guard ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &size) == 0 else {
            assertionFailure("Could not get window size")
            return
        }
        window.layer.frame.size = Size(width: Int(size.ws_col), height: Int(size.ws_row))
    }

}

