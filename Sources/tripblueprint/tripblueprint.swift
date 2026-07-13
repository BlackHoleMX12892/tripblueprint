// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI
import MapKit

@main
struct tripblueprint: App {
    #if os(macOS)
    init() {
        NSApplication.shared.setActivationPolicy(.regular)
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
    #endif

    var body: some Scene {
        WindowGroup("Trip Blueprint") {
            ContentView()
        }
        
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}

struct SettingsView: View {
    var body: some View {
        TabView {
            Tab("General", systemImage: "gear") {
                Text("Hi there general")
            }
            Tab("Advanced", systemImage: "star") {
                Text("Hi there advanced")
            }
        }
        .scenePadding()
        .frame(maxWidth: 350, minHeight: 100)
    }
}

struct ContentView: View {
    struct Menu: Identifiable, Hashable {
        let name: String
        let icon: String
        let id: UUID = UUID()
    }

    private var menus: [ContentView.Menu] = [
        Menu(name: "Overview", icon: "pencil.and.list.clipboard"),
        Menu(name: "Places", icon: "map"),
        Menu(name: "Flights", icon: "airplane.up.right"),
        Menu(name: "Transport", icon: "bus.doubledecker")
    ]

    @State private var selectedMenuID: UUID? = nil

    init() {
        _selectedMenuID = State(initialValue: menus[0].id)
    }

    struct Overview: View {
        var body: some View {
            ScrollView {
                VStack {
                    RoundedRectangle(cornerRadius: 10).frame(height: 250).padding(10)
                    HStack {

                    }
                }
            }
        }
    }

    struct Places: View {
        var body: some View {
            Map {

            }
        }
    }

    struct Flights: View {
        var body: some View {
            Text("We have dreamed to fly since the first moments as humans")
        }
    }

    struct Transport: View {
        var body: some View {
            Text("Transportation exists because the world is physical")
        }
    }

    func getCurrentName(currentUUID: UUID) -> String {
        for item in menus {
            if item.id == currentUUID {
                return item.name
            }
        }
        return ""
    }

    var body: some View {
        NavigationSplitView {
            List(menus, selection: $selectedMenuID) { item in
                HStack {
                    Image(systemName: item.icon).resizable().aspectRatio(contentMode: .fit).frame(width: 25, height: 25)
                    Text(item.name)
                }.padding([.bottom, .top], 5).padding(.leading, 2)
            }
        } detail: {
            switch getCurrentName(currentUUID: selectedMenuID!) {
                case "Overview":
                    Overview()
                case "Places":
                    Places()
                case "Flights":
                    Flights()
                case "Transport":
                    Transport()
                default:
                    Overview()
            } // this should not be like this, but how am I supposed to provide a default UUID?
        }
    }
}
