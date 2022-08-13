import SwiftTUI
import Foundation
import Dispatch

struct ToDo: Identifiable {
    let id = UUID()
    let text: String
}

struct ToDoView: View {
    let toDo: ToDo
    let onDelete: () -> Void

    @State var deleting = false 

    var body: some View {
        if deleting {
            Text("[*] \(toDo.text)")
                .background(.red)
        } else {
            Button("[ ] \(toDo.text)", action: delete)
        }
    }

    private func delete() {
        deleting = true 
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            onDelete()
        }
    }
}

struct ContentView: View {
    @State var toDos: [ToDo] = [
        ToDo(text: "Hello"),
        ToDo(text: "World")
    ]

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("My To-Do's")
                Spacer()
            }
            .background(.blue)
            VStack {
                ForEach(toDos) { toDo in
                    ToDoView(toDo: toDo, onDelete: { toDos.removeAll(where: { $0.id == toDo.id }) })
                }
                HStack {
                    Text("New to-do: ")
                    TextField() { toDos.append(ToDo(text: $0)) }
                    Spacer()
                }
                Spacer()
            }
            .padding()
        }
    }
}
