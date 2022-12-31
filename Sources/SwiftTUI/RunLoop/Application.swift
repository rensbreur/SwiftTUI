import Foundation

public class Application {
    private let node: Node
    private let window: Window
    private let control: Control
    private let renderer: Renderer

    private var arrowKeyParser = ArrowKeyParser()

    private var invalidatedNodes: [Node] = []
    private var updateScheduled = false

    public init<I: View>(rootView: I) {
        node = Node(nodeBuilder: VStack(content: rootView).nodeBuilder)
        node.build()

        control = node.control!

        window = Window()
        window.addControl(control)

        window.firstResponder = control.firstSelectableElement
        window.firstResponder?.becomeFirstResponder()

        renderer = Renderer(layer: window.layer)
        window.layer.renderer = renderer

        node.application = self
        renderer.application = self
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

        signal(SIGINT, SIG_IGN)
        let sigIntSource = DispatchSource.makeSignalSource(signal: SIGINT, queue: .main)
        sigIntSource.setEventHandler(qos: .default, flags: [], handler: self.stop)
        sigIntSource.resume()

        dispatchMain()

    }

    private func setInputMode() {
        var tattr = termios()
        tcgetattr(STDIN_FILENO, &tattr)
        tattr.c_lflag &= ~tcflag_t(ECHO | ICANON)
        tcsetattr(STDIN_FILENO, TCSAFLUSH, &tattr);
    }

    private func handleInput() {
        let data = FileHandle.standardInput.availableData

        guard let string = String(data: data, encoding: .utf8) else {
            return
        }

        for char in string {
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
                } else if key == .right {
                    if let next = window.firstResponder?.selectableElement(rightOf: 0) {
                        window.firstResponder?.resignFirstResponder()
                        window.firstResponder = next
                        window.firstResponder?.becomeFirstResponder()
                    }
                } else if key == .left {
                    if let next = window.firstResponder?.selectableElement(leftOf: 0) {
                        window.firstResponder?.resignFirstResponder()
                        window.firstResponder = next
                        window.firstResponder?.becomeFirstResponder()
                    }
                }
            } else if char == ASCII.EOT {
                stop()
            } else {
                window.firstResponder?.handleEvent(char)
            }
        }
    }

    func invalidateNode(_ node: Node) {
        invalidatedNodes.append(node)
        scheduleUpdate()
    }

    func scheduleUpdate() {
        if !updateScheduled {
            DispatchQueue.main.async { self.update() }
            updateScheduled = true
        }
    }

    private func update() {
        updateScheduled = false

        for node in invalidatedNodes {
            node.update(using: node.nodeBuilder)
        }
        invalidatedNodes = []

        control.layout(size: window.layer.frame.size)
        renderer.update()
    }

    private func handleWindowSizeChange() {
        updateWindowSize()
        control.layer.invalidate()
        update()
    }

    private func updateWindowSize() {
        var size = winsize()
        guard ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &size) == 0,
              size.ws_col > 0, size.ws_row > 0 else {
            assertionFailure("Could not get window size")
            return
        }
        window.layer.frame.size = Size(width: Int(size.ws_col), height: Int(size.ws_row))
        renderer.setCache()
    }

    private func stop() {
        renderer.stop()
        exit(0)
    }

}

