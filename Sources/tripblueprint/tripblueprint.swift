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

    struct Place: Identifiable, Equatable {
        let name: String
        let latitude: Double
        let longitude: Double
        let color: Color
        let id: UUID = UUID()
    }

    struct PlacesMap: View {
        let storedplaces: [ContentView.Place] = [
            Place(name: "TruthBBQ", latitude: 29.7690978, longitude: -95.3976466, color: .orange),
            Place(name: "Pinkerton's Barbecue", latitude: 29.427150, longitude: -98.494151, color: .green),
            Place(name: "Buc-ee's", latitude: 29.726440765116635, longitude: -98.07863723203057, color: .blue)
        ]

        var body: some View {
            Map {
                ForEach(storedplaces) { place in
                    Marker(place.name, coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)).tint(place.color)
                }
            }
        }
    }

    struct Overview: View {
        var body: some View {
            ScrollView {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10).fill(.blue.gradient)
                        Text("Suggested places").foregroundColor(Color.red).font(.largeTitle)
                    }.frame(height: 250)
                    HStack {
                        ZStack {
                            PlacesMap().clipShape(.rect(cornerRadius: 20))
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                        }
                    }.frame(height: 400).padding(.top, 10)
                }.padding([.horizontal, .bottom], 20)
            }
        }
    }

    struct PlaceAdditionPopoverContent: View {
        @State private var placename: String = ""
        var body: some View {
            VStack {
                Text("Add new place:")
                TextField("", text: $placename)
            }
        }
    }

    struct Places: View {
        @State private var isShowingPlaceAdditionPopover = false

        func ShowPlaceAdditionPopover() -> Void {
            self.isShowingPlaceAdditionPopover = true
        }

        var body: some View {
            ZStack(alignment: .bottomTrailing) {
                PlacesMap()
                Button(action: ShowPlaceAdditionPopover) {
                    ZStack {
                        Circle().fill(Color.white)
                        Image(systemName: "plus").foregroundColor(Color.black).font(.title2)
                    }
                }.frame(width: 35, height: 35).padding(.bottom, 55).padding(.trailing, 10).buttonStyle(.plain).popover(isPresented: $isShowingPlaceAdditionPopover, attachmentAnchor: .point(.leading), arrowEdge: .leading) {PlaceAdditionPopoverContent().padding()}
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    struct Flights: View {
        var body: some View {
            TabView {
                Tab("Manage", systemImage: "airplane.ticket") {
                    ScrollView {
                        Text("Manage")
                    }
                }
                Tab("Book", systemImage: "pencil.and.list.clipboard") {
                    ScrollView {
                        Text("Book")
                    }
                }
            }
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
            }
        }
    }
}
