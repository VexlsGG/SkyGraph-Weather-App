import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var activeTab: NavBarTab = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch activeTab {
                case .home:
                    HomePageView()
                case .forecast:
                    Text("Forecast Page")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                case .maps:
                    RadarView()
                case .ai:
                    Text("AI Page")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                case .settings:
                    NavigationView {
                        List {
                            ForEach(items) { item in
                                NavigationLink {
                                    Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                                } label: {
                                    Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                                }
                            }
                            .onDelete(perform: deleteItems)
                        }
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                EditButton()
                            }
                            ToolbarItem {
                                Button(action: addItem) {
                                    Label("Add Item", systemImage: "plus")
                                }
                            }
                        }
                        .navigationTitle("Settings / Items")
                    }
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
