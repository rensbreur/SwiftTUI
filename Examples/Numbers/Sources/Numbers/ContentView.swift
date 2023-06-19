import SwiftTUI

struct ContentView: View {
    @State var counter = 1

    var body: some View {
        VStack {
            Button {
                counter += 1
            } label: {
                Text("Add number")
                    .foregroundColor(.green)
                    .bold()
            }
            if counter > 1 {
                Button {
                    counter -= 1
                } label: {
                    Text("Remove number")
                        .foregroundColor(.red)
                        .bold()
                }
            }
            ForEach(1 ... counter, id: \.self) { i in
                Text("Number \(i)")
            }
            .border()
        }
        .padding()
    }
}
