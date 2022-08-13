# SwiftTUI

![swift 5.6](https://user-images.githubusercontent.com/13484323/184016525-cb42a72c-1e2e-4d8d-8777-e7481386377c.svg)
![platform macos](https://user-images.githubusercontent.com/13484323/184016156-817e14dc-24b5-4b46-a4d4-0de9391a37a4.svg)
![platform linux](https://user-images.githubusercontent.com/13484323/184016263-afa5dd0c-8d9a-4fba-91fe-23e892d64cca.svg)

An innovative, exceptionally simple way to build text-based user interfaces.

SwiftTUI brings SwiftUI to the terminal. It provides an API similar to SwiftUI to build terminal applications with a text-based user interface.

![](screenshot.png)

### What is working

SwiftTUI is still in an experimental phase and might not yet be ready to power the next big terminal app. However, there are many things that are working:

✓ Using `VStack`, `HStack`, `ForEach` and `Spacer` to build lists.<br>
✓ Dynamic view content with `if` statements.<br>
✓ Structural identity works in the same way as in SwiftUI.<br>
✓ `Button`, `TextField` and moving focus with the arrow keys.<br>
✓ Static views `Text` and `Color`<br>
✓ Modifiers `.border()`, `.padding()` and `background()`, which are applied to all views in a collection like in SwiftUI.<br>
✓ Using `@State` and `@Binding` to store values and invalidate views.

### Getting started

To use SwiftTUI, you need to add the SwiftTUI package dependency. Import SwiftTUI in your files, and write your views like SwiftUI views with the supported features. Then, start the terminal application using one of your views as the root view. This is the easiest SwiftTUI app you can write:

```swift
import SwiftTUI

struct MyTerminalView: View {
  var body: some View {
    Text("Hello, world!)
  }
}

Application(rootView: MyTerminalView()).start()
```

### Examples

The following examples of how to use SwiftTUI can be found in the Examples directory.

#### Examples/ToDoList

![](Examples/ToDoList/screenshot.png)

This is a very simple to-do list application. Use the arrow keys to move around. To complete a to-do item, select it, and then press the enter key or space bar. To add a new to-do item, move to the text field, enter a description, and press the enter key to add it to the list. Completed items are automatically removed from the list after half a second.

#### Examples/Flags

![](Examples/Flags/screenshot.png)

This is a flag editor, which you will agree to if you come from a country which has a simple flag consisting of colors stacked horizontally or vertically. Select one of the colors of the flag to change it. Use the options on the right to change the number of colors or the flag orientation.

### More

See a screen recording of SwiftTUI [in action](https://www.reddit.com/r/SwiftUI/comments/wlabyn/im_making_a_version_of_swiftui_for_terminal/) on Reddit.
