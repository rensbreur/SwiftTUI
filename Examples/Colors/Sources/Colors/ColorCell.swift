import SwiftTUI

struct ColorCell: View {
    let colorState: ColorState

    init(colorState: ColorState) {
        self.colorState = colorState
    }

    var body: some View {
        VStack(alignment: .center) {
            colorState.color
                .frame(width: 7, height: 3)
                .padding(.horizontal, 1)
                .border()
            Text(colorState.name)
            Text("(\(colorState.fgCode), \(colorState.bgCode))")
        }
        .frame(width: 16, alignment: .center)
    }
}
