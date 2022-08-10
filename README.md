# SwiftTUI

![swift 5.6](https://user-images.githubusercontent.com/13484323/184016525-cb42a72c-1e2e-4d8d-8777-e7481386377c.svg)
![platform macos](https://user-images.githubusercontent.com/13484323/184016156-817e14dc-24b5-4b46-a4d4-0de9391a37a4.svg)
![platform linux](https://user-images.githubusercontent.com/13484323/184016263-afa5dd0c-8d9a-4fba-91fe-23e892d64cca.svg)

An innovative, exceptionally simple way to build text-based user interfaces.

SwiftTUI brings SwiftUI to the terminal. It provides an API similar to SwiftUI to build terminal applications with a text-based user interface.

![](screenshot.png)

### What is working

SwiftTUI is still in an experimental phase and might not yet be ready to power the next big terminal app. However, there are many things that are working:

✓ Using `VStack`, `HStack`, `ForEach` to build lists.<br>
✓ Dynamic view content with `if` statements.<br>
✓ Structural identity works in the same way as in SwiftUI.<br>
✓ `Button`, `TextField` and moving focus with the arrow keys.<br>
✓ Modifiers `.border()` and `.padding()` are applied to all views in a collection.<br>
✓ Using `@State` to store values and invalidate views.

### Getting started

Add the SwiftTUI package dependency. Import SwiftTUI in your files

```swift
import SwiftTUI
```

Write your terminal views like SwiftUI views.

```swift
struct MyTerminalView: View {
  var body: some View {
    Text("Hello, world!)
  }
}
```

Then, start the terminal application.

```swift
Application(rootView: MyTerminalView()).start()
```

Check out the Examples directory.

