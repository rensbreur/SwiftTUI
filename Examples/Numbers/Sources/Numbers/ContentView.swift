import SwiftTUI

struct ContentView: View {
    @State var counter = 1

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Color.blue
                    .frame(width: 5, height: 2)
                    .border()
                Color.blue
                    .frame(width: 5, height: 2)
                    .border()
            }
            HStack(spacing: 0) {
                Color.blue
                    .frame(width: 5, height: 2)
                    .border()
                Color.blue
                    .frame(width: 5, height: 2)
                    .border()
                    .padding(.left, -1)
            }
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
