import SwiftTUI

struct ColorPicker: View {
    var pickColor: (Color) -> Void

    var body: some View {
        VStack {
            Button("Black") { pickColor(.black) }
            Button("White") { pickColor(.white) }
            Button("Red") { pickColor(.red) }
            Button("Green") { pickColor(.green) }
            Button("Yellow") { pickColor(.yellow) }
            Button("Blue") { pickColor(.blue) }
            Button("Magenta") { pickColor(.magenta) }
        }
        .border()
    }
}
