import SwiftTUI
import Foundation

struct ToDoView: View {
    let toDo: ToDo
    let onDelete: () -> Void

    @State var deleting = false 

    var body: some View {
        HStack {
            if deleting {
                Text("[x]")
                Text(toDo.text).strikethrough()
            } else {
                Button("[ ]", action: delete)
                Text(toDo.text)
            }
        }
    }

    private func delete() {
        deleting = true 
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            onDelete()
        }
    }
}
