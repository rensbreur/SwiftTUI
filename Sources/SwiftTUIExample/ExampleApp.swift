
import SwiftTUI

@main struct ExampleApp {
    static func main() {
        if #available(macOS 14.0, *) {
            Application(
                rootView: ExampleView(),
                runLoopType: .cocoa
            )
            .start()
        } else {
            // Fallback on earlier versions
            log("This ExampleApp requires macOS 14.0 or newer")
        }
    }
}

@available(macOS 14.0, *)
struct ExampleView: View {
    var body: some View {
        HStack {
            ObservationView().border()
            CombineView().border()
        }
    }
}

// MARK: Observation example
import Observation

@available(macOS 14.0, *)
struct ObservationView: View {
    let vm: CounterViewModel
    init(vm: CounterViewModel = .init()) {
        self.vm = vm
    }
    
    var body: some View {
        VStack {
            Text("ObservationView").underline()
            if vm.showCounter {
                Text("int: \(vm.int)")
            }
            VStack {
                Button("Show/Hide Counter") {
                    vm.showCounter.toggle()
                }
                Button("↑") {
                    log("Incrementing...")
                    vm.int += 1
                    log("Counter is now: \(vm.int)")
                }
                Button("↓") {
                    log("Decrementing...")
                    vm.int -= 1
                    log("Counter is now: \(vm.int)")
                }
            }
        }
    }
}

@available(macOS 14.0, *)
@Observable class CounterViewModel {
    var int: Int
    var showCounter: Bool
    
    init(int: Int = 0, showCounter: Bool = true) {
        self.int = int
        self.showCounter = showCounter
    }
}



// MARK: Combine Example
struct CombineView: View {
    @ObservedObject var vm: CombineViewModel = CombineViewModel()
    
    var body: some View {
        VStack {
            Text("CombineView").underline()
            if vm.showCounter {
                Text("int: \(vm.int)")
            }
            VStack {
                Button("Show/Hide Counter") {
                    vm.showCounter.toggle()
                }
                Button("↑") {
                                    log("Incrementing...")
                    vm.int += 1
                                    log("Counter is now: \(vm.int)")
                }
                Button("↓") {
                                    log("Decrementing...")
                    vm.int -= 1
                                    log("Counter is now: \(vm.int)")
                }
            }
        }
    }
}

import Combine
class CombineViewModel: ObservableObject {
    @Published var int = 0
    @Published var showCounter = true
    
    init(int: Int = 0, showCounter: Bool = true) {
        self.int = int
        self.showCounter = showCounter
    }
}
