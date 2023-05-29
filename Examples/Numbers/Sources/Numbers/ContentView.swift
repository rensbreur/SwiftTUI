import Foundation
import SwiftTUI

struct ContentView: View {
    @State var counter = 1

    let numberAttributes = AttributeContainer().underlineStyle(Text.LineStyle(pattern: .solid))

    var body: some View {
        VStack {
            Button("Add number") { counter += 1 }
            if counter > 1 {
                Button("Remove number") { counter -= 1 }
            }
            ForEach(1 ... counter, id: \.self) { i in
                Text(AttributedString("Number ") + AttributedString("\(i)", attributes: numberAttributes))
            }
            .border()
        }
        .padding()
    }
}
