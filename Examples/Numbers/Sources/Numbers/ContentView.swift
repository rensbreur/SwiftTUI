import SwiftTUI

struct ContentView: View {
    @State var counter = 1

    var body: some View {
        VStack {
            Button("More") { counter += 1 }
            Button("Less") { counter -= 1 }
            HStack {
                if counter > 0 {
                    ForEach(1 ... counter, id: \.self) { i in
                        Text("Number \(i)")
                    }
                    .border()
                } else {
                    Text("Create more items")
                }
            }
        }
        .padding()
    }
}
