# 🍒 Compote

Swift Web framework based on SwiftNIO and inspired by SwiftUI

```swift
import ArgumentParser
import Compote

struct HelloApp: App {
    @OptionGroup()
    var options: LaunchOptions

    var route: some Route {
        GET {
            $0.response(body: .string("Hello"))
        }
    }
}

NotesApp.main()
```
