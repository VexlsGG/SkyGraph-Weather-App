import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var activeTab: NavBarTab = .home
    @State private var showLocations = false  // Add this for navigation

    var body: some View {
        NavigationStack {   // <---- WRAP THE WHOLE APP
            ZStack(alignment: .bottom) {
                Group {
                    switch activeTab {
                    case .home:
                        HomePageView(showLocations: $showLocations)  // Pass binding
                    case .forecast:
                        ForecastView()
                    case .maps:
                        RadarView()
                    case .ai:
                        AIChatView()
                    case .settings:
                        SettingsView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("Background").ignoresSafeArea())
                
                Navbar(activeTab: activeTab) { tab in
                    withAnimation(.spring()) {
                        activeTab = tab
                    }
                }
            }
            .ignoresSafeArea(.container, edges: .bottom)
            // THIS IS WHAT TRIGGERS THE LOCATIONS PAGE
            .navigationDestination(isPresented: $showLocations) {
                LocationsView()
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
}
