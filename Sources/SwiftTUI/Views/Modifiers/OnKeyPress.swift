import Foundation

public extension View {
    /// Use this modifier to provide a closure to be executed when the user presses one or more keys, while the view has the focus.
    func onKeyPress(_ char: Character, _ action: @escaping () -> Void) -> some View {
        log("inside onKeyPress modifier")
        return OnKeyPress(
            content: self,
            keyPress: char,
            action: action
        )
    }
}

struct OnKeyPress<Content: View>: View, PrimitiveView, ModifierView {
    let content: Content
    let keyPress: Character
    let action: () -> Void
    
    static var size: Int? { Content.size }
    
    func buildNode(_ node: Node) {
        node.addNode(at: 0, Node(view: content.view))
    }
    
    func updateNode(_ node: Node) {
        node.view = self
        node.children[0].update(using: content.view)
    }
    
    func passControl(_ control: Control, node: Node) -> Control {
        // I'm not sure if parent views or child views should take precedence for key press handling
        // or perhaps they both handle it, with no precedence.
//        if let onKeyPressControl = control.parent { return onKeyPressControl }
        
        let onKeyPressControl = OnKeyPressControl(keyPress: keyPress, action: action)
        onKeyPressControl.addSubview(control, at: 0)
        
        return onKeyPressControl
    }
    
}

class OnKeyPressControl: Control {
    let keyPress: Character
    let action: () -> Void
    
    init(keyPress: Character, action: @escaping () -> Void) {
        log("inside OnKeyPressControl init")
        self.keyPress = keyPress
        self.action = action
    }
    
    override func size(proposedSize: Size) -> Size {
        log("inside OnKeyPressControl size(proposedSize:)")
        return children[0].size(proposedSize: proposedSize)
    }
    
    override func layout(size: Size) {
        log("inside OnKeyPressControl layout(size:)")
        super.layout(size: size)
        children[0].layout(size: size)
        
    }
    
    override func handleEvent(_ char: Character) {
        log("inside OnKeyPressControl handleEvent(_:\(char))")
        super.handleEvent(char) // let children handle the event
        if char == keyPress {
            //                self.root.window?.runKeyPressAction(char: char, actionLabel: actionLabel)
        }
    }
}

// MARK: Example Usage
public struct ExampleOnKeyPressView: View {
    @State var isASelected: Bool
    @State var isBSelected: Bool
    
    public init(isASelected: Bool = false, isBSelected: Bool = false) {
        self.isASelected = isASelected
        self.isBSelected = isBSelected
    }
    
    public var body: some View {
        let _ = log("inside ExampleOnKeyPressView body")
        
        return VStack {
            Text("a (onKeyPress modifier is APPLIED)")
                .padding()
                .border()
                .background(isASelected ? .green : .default)
                .onKeyPress("a") {
                    log("isASelected.toggle()")
                    isASelected.toggle()
                }
            
            Text("b (onKeyPress modifier is NOT APPLIED)")
                .padding()
                .border()
                .background(isBSelected ? .cyan : .default)
            //                    .onKeyPress("b") {
            //                        log("isBSelected.toggle()")
            //                        isBSelected.toggle()
            //                    }
            
        }
    }
}
