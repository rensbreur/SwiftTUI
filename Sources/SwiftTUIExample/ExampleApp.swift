
import SwiftTUI

@main struct ExampleApp {
    static func main() {
        if #available(macOS 14.0, *) {
            Application(
                rootView: ExampleOnKeyPressView(),
                runLoopType: .cocoa
            )
            .start()
        } else {
            // Fallback on earlier versions
            log("This ExampleApp requires macOS 14.0 or newer")
        }
    }
}
