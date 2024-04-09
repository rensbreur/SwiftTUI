import SwiftTUI

struct ContentView: View {
    @State var counter = 1

    var body: some View {
        VStack {
            Button("Add number") { counter += 1 }
            if counter > 1 {
                Button("Remove number") { counter -= 1 }
            }
            ForEach(1 ... counter, id: \.self) { i in
                Text("Number \(i)")
            }
            .border()
        }
        .padding()
    }
}
