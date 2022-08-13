import SwiftTUI

struct FlagView: View {
    let flag: Flag
    @Binding var selected: Int

    var body: some View {
        Group {
            switch flag.orientation {
            case .horizontal: horizontal
            case .vertical: vertical
            }
        }
        .frame(width: 30, height: 12)
    }

    private var horizontal: some View {
        VStack(spacing: 0) {
            ForEach(0 ..< flag.colors.count, id: \.self) { i in
                HStack(alignment: .center) {
                    Button(i == selected ? ">" : " ") { selected = i }
                    flag.colors[i]
                }
            }
        }
    }

    private var vertical: some View {
        HStack(spacing: 0) {
            ForEach(0 ..< flag.colors.count, id: \.self) { i in
                VStack(alignment: .center) {
                    Button(i == selected ? "v" : " ") { selected = i }
                    flag.colors[i]
                }
            }
        }
    }

}
