#if os(macOS)
import Foundation
import Combine

extension View {
    func setupObservedObjectProperties(node: Node) {
        log("Inside setupObservedObjectProperties")
        
        for (label, value) in Mirror(reflecting: self).children {
            if let label, let observedObject = value as? AnyObservedObject {
                log("subscribing to label: \(label)")
                node.subscriptions[label] = observedObject.subscribe {
                    log("ObservableObject observed a change. invalidating node...")
                    node.root.application?.invalidateNode(node)
                }
            }
        }
    }
}
#endif
