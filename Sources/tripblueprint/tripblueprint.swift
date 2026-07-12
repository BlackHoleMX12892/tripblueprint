// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI

@main
struct tripblueprint: App {
    init() {
        NSApplication.shared.setActivationPolicy(.regular)
        NSApplication.shared.activate(ignoringOtherApps: true)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView : View {
    var body: some View {
        Text("Hello SwiftUI")
    }
}
