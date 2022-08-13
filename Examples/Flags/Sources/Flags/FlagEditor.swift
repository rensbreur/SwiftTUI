import SwiftTUI

struct FlagEditor: View {
    @State var flag = Flag(colors: [.green, .white])
    @State var selected = 0

    var body: some View {
        HStack {
            VStack {
                FlagView(flag: flag, selected: $selected)
            }
            VStack(spacing: 1) {
                ColorPicker(pickColor: { flag.colors[selected] = $0 })
            }
            VStack {
                Button("Add color") { flag.colors.append(.white) }
                Button("Remove color") { if selected < flag.colors.count { flag.colors.remove(at: selected) } }
                Button("Rotate") { if flag.orientation == .horizontal { flag.orientation = .vertical } else { flag.orientation = .horizontal } }
            }
            .border()
        }
    }
}
