import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var selectedTab: String = NavBarTab.home.id
    
    @State private var showLocations = false 
    
    @State private var weatherType: WeatherType = .night

    
    private var tabItems: [NavBarTabItem] {
        [
            NavBarTab.home.toItem,
            NavBarTab.forecast.toItem,
            NavBarTab.ai.toItem,
            NavBarTab.settings.toItem
        ]
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Group {
                    switch selectedTab {
                    case NavBarTab.home.id:
                        HomePageView(showLocations: $showLocations)
                    case NavBarTab.forecast.id:
                        ForecastView()
                    case NavBarTab.ai.id:
                        AIChatHomeView()
                    case NavBarTab.settings.id:
                        SettingsView()
                    default:
                        HomePageView(showLocations: $showLocations)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("Background").ignoresSafeArea())
                
                Navbar(selected: $selectedTab, tabs: tabItems, weatherType: weatherType)
            }
            .ignoresSafeArea(.container, edges: .bottom)
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
