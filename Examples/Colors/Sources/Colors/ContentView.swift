import SwiftTUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 3) {
            Text("ANSI Colors")
                .bold()
                .padding(.horizontal, 1)
                .border(style: .double)
            ColorRow(colorStates: ColorState.normalColors)
            ColorRow(colorStates: ColorState.brightColors)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
