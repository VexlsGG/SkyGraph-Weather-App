import SwiftUI

struct LocationWeatherPreview: Identifiable {
    let id = UUID()
    var name: String
    var temp: Int
    var icon: String
}

let mockCityData: [LocationWeatherPreview] = [
    .init(name: "New York", temp: 66, icon: "cloud.sun.fill"),
    .init(name: "Miami", temp: 86, icon: "sun.max.fill"),
    .init(name: "Chicago", temp: 58, icon: "cloud.rain.fill"),
    .init(name: "Tokyo", temp: 73, icon: "cloud.bolt.rain.fill")
]

struct LocationPicker: View {
    @Binding var locations: [String]
    @Binding var selectedIndex: Int
    let dismiss: () -> Void
    let goToSettings: () -> Void
    let addLocation: () -> Void

    @State private var showSettings = false
    @State private var showDictation = false
    @State private var showTextField = false
    @State private var newLocationName = ""

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color("Graph Line 1"), .clear], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Text("Locations")
                    .font(.system(size: 18, weight: .bold))
                    .padding(.top, 16)
                    .padding(.bottom, 8)

                List {
                    ForEach(locations.indices, id: \.self) { idx in
                        let name = locations[idx]

                        Button(action: {
                            selectedIndex = idx
                            dismiss()
                        }) {
                            HStack {
                                Text(shortLocationName(name))
                                    .font(.system(size: 18, weight: .semibold))
                                Spacer()
                                if selectedIndex == idx {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.accentColor)
                                }
                            }
                            .padding(.vertical, 14)
                            .padding(.horizontal, 22)
                            .background(
                                Capsule()
                                    .fill(selectedIndex == idx ? Color.accentColor.opacity(0.20) : Color("Card").opacity(0.72))
                            )
                            .overlay(
                                Capsule()
                                    .stroke(selectedIndex == idx ? Color.accentColor : Color.clear, lineWidth: 2)
                            )
                            .shadow(color: Color.black.opacity(selectedIndex == idx ? 0.14 : 0.07), radius: 2, x: 0, y: 2)
                        }
                        .listRowBackground(Color.clear)
                        .buttonStyle(.plain)
                    }
                    .onDelete(perform: deleteLocation)
                }
                .listStyle(.plain)
                .padding(.bottom, 8)

                Button(action: {
                    showDictation = true
                }) {
                    Label("Search by Voice", systemImage: "mic.fill")
                        .font(.system(size: 15, weight: .medium))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                }
                .padding(.bottom, 14)

                HStack(spacing: 34) {
                    Button {
                        Haptics.tap()
                        showTextField = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.accentColor)
                    }

                    Button {
                        Haptics.tap()
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 18))
                            .padding(6)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
                .padding(.bottom, 22)
            }
            .padding(.horizontal, 10)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showDictation) {
            VStack {
                Text("🎙️ Dictation Feature Coming Soon")
                    .font(.headline)
                    .padding()
                Button("Dismiss") { showDictation = false }
                    .padding(.top, 10)
            }
        }
        .alert("Add Location", isPresented: $showTextField) {
            TextField("Enter city name", text: $newLocationName)
            Button("Add", action: {
                let trimmed = newLocationName.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty {
                    locations.append(trimmed)
                    newLocationName = ""
                }
            })
            Button("Cancel", role: .cancel) {
                newLocationName = ""
            }
        }
    }

    func deleteLocation(at offsets: IndexSet) {
        locations.remove(atOffsets: offsets)
        if selectedIndex >= locations.count {
            selectedIndex = max(0, locations.count - 1)
        }
    }

    func shortLocationName(_ name: String) -> String {
        if name.lowercased().contains("current") { return "Current" }
        if name.count > 22 {
            let trimmed = name.prefix(22)
            return "\(trimmed)..."
        }
        return name
    }
}

#Preview {
    LocationPicker(
        locations: .constant(["New York", "Miami", "Chicago", "Tokyo"]),
        selectedIndex: .constant(0),
        dismiss: {},
        goToSettings: {},
        addLocation: {}
    )
}
