# ``SwiftTUI``

SwiftUI for terminal applications.

## Documentation

This generated documentation can serve as a reference for the currently supported functionality. Also check out `README.md` and the included example projects.

## Getting started

Create an executable type Swift package and add SwiftTUI as a dependency. Use the `main` branch to use the latest functions. Import SwiftTUI in your files, and write your views like you're used to in SwiftUI, using the supported views and modifiers.

```swift
import SwiftTUI

struct MyTerminalView: View {
  var body: some View {
    Text("Hello, world!")
  }
}
```

Add the following to `main.swift` to start the terminal application using one of your views as the root view.

```swift
Application(
  rootView: MyTerminalView()
)
.start()
```

To run the app, open a terminal emulator such as macOS's Terminal app, change to your package's directory and run

```bash
swift run
```

## Topics

### Application

- ``Application``

### View

- ``View``
- ``ViewBuilder``
- ``Group``
- ``ForEach``
- ``EmptyView``

### Layout

- ``VStack``
- ``HStack``
- ``ZStack``
- ``Spacer``
- ``Divider``
- ``View/frame(width:height:alignment:)``
- ``View/frame(minWidth:maxWidth:minHeight:maxHeight:alignment:)``
- ``View/padding(_:)``
- ``View/padding(_:_:)``
- ``GeometryReader``
- ``Alignment``
- ``HorizontalAlignment``
- ``VerticalAlignment``
- ``Edges``
- ``Extended``
- ``Size``

### Style

- ``Color``
- ``View/foregroundColor(_:)``
- ``View/background(_:)``
- ``View/border(_:style:)``
- ``BorderStyle``
- ``DividerStyle``

### Text

- ``Text``
- ``View/bold(_:)``
- ``View/italic(_:)``
- ``View/strikethrough(_:)``
- ``View/underline(_:)``

### Controls

- ``ScrollView``
- ``Button``
- ``TextField``
- ``EnvironmentValues/placeholderColor``

### View lifecycle

- ``View/onAppear(_:)``

### Property wrappers

- ``State``
- ``Binding``
- ``ObservedObject``
- ``Environment``
- ``View/environment(_:_:)``
- ``EnvironmentKey``
- ``EnvironmentValues``

### Debugging

- ``log(_:terminator:)``
