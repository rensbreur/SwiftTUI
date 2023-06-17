import SwiftTUI

struct ToDoList: View {
    @State var toDos: [ToDo] = [
        ToDo(text: "Hello"),
        ToDo(text: "World")
    ]

    var body: some View {
        VStack(spacing: 1) {
            VStack {
                ForEach(toDos) { toDo in
                    ToDoView(toDo: toDo, onDelete: { toDos.removeAll(where: { $0.id == toDo.id }) })
                }
            }
            addToDo
            Spacer()
        }
    }

    private var addToDo: some View {
        HStack {
            Text("New to-do: ")
                .italic()
            TextField() { toDos.append(ToDo(text: $0)) }
            Spacer()
        }
    }
}
