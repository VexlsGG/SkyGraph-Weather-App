import SwiftUI

// This MUST conform to Codable & Identifiable for saving/loading to work!
struct LocationDisplay: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var model: LocationModel
    var isUserLocation: Bool
    var alertTitle: String?
    var cardStyle: LocationWeatherCard.CardStyle = .glass
}

// Make sure LocationModel and LocationWeatherCard.CardStyle are Codable/Equatable too!

private let defaultLocations: [LocationDisplay] = [
    LocationDisplay(
        model: LocationModel(city: "Cupertino", temp: 68, condition: "Partly Cloudy", weatherIconName: "cloud.sun.fill", hourlyTemps: [68, 67, 66, 65, 66, 69, 72, 75]),
        isUserLocation: true,
        alertTitle: nil,
        cardStyle: .glass
    ),
    LocationDisplay(
        model: LocationModel(city: "Detroit", temp: 84, condition: "Sunny", weatherIconName: "sun.max.fill", hourlyTemps: [84, 87, 90, 92, 88, 83, 81, 79]),
        isUserLocation: false,
        alertTitle: "Severe Thunderstorm Warning",
        cardStyle: .glass
    ),
    LocationDisplay(
        model: LocationModel(city: "Orlando", temp: 91, condition: "Thunderstorm", weatherIconName: "cloud.bolt.rain.fill", hourlyTemps: [91, 88, 85, 83, 87, 90, 92, 89]),
        isUserLocation: false,
        alertTitle: "Tornado Warning",
        cardStyle: .glass
    )
]

struct LocationsView: View {
    @AppStorage("savedLocations") private var savedLocationsData: Data = Data()
    @State private var locations: [LocationDisplay] = []
    @State private var showingAddLocation = false
    @State private var selectedLocationID: UUID? = nil
    @State private var expandedLocationID: UUID? = nil
    @State private var isEditMode = false
    @State private var showDeleteAlert = false
    @State private var locationToDelete: LocationDisplay?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.backward")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(Color("Graph Line 1"))
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .cornerRadius(16)
                            .shadow(color: Color("Graph Line 1").opacity(0.13), radius: 2, x: 0, y: 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Text("Locations")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Color("Text Primary"))
                        .shadow(color: Color("Graph Line 1"), radius: 12, x: 0, y: 4)
                    Spacer()
                    Button {
                        withAnimation(.spring()) { isEditMode.toggle() }
                    } label: {
                        Image(systemName: isEditMode ? "checkmark" : "pencil")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(isEditMode ? Color("Graph Line 2") : Color("Text Primary"))
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .cornerRadius(16)
                            .shadow(color: Color("Graph Line 2").opacity(0.13), radius: 2, x: 0, y: 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Button {
                        withAnimation(.spring()) { showingAddLocation = true }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "plus")
                                .rotationEffect(.degrees(showingAddLocation ? 90 : 0))
                                .scaleEffect(showingAddLocation ? 1.2 : 1)
                                .animation(.spring(response: 0.36, dampingFraction: 0.7), value: showingAddLocation)
                            Text("Add")
                        }
                        .foregroundColor(Color("Text Primary"))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color("Background"))
                                .shadow(color: Color("Graph Line 1").opacity(0.09), radius: 4, x: 0, y: 2)
                        )
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("Graph Line 1"), lineWidth: 1.2))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal)
                .padding(.top, 12)
                List {
                    ForEach(locations) { location in
                        HStack(alignment: .top, spacing: 0) {
                            if isEditMode {
                                Image(systemName: "line.3.horizontal")
                                    .foregroundColor(Color("Text Secondary"))
                                    .opacity(0.25)
                                    .padding(.top, 24)
                                    .padding(.trailing, 10)
                            }
                            VStack(alignment: .leading, spacing: 0) {
                                LocationWeatherCard(
                                    location: location.model,
                                    isActive: location.id == (selectedLocationID ?? locations.first?.id),
                                    isUserLocation: location.isUserLocation,
                                    alertTitle: location.alertTitle,
                                    trend: .neutral,
                                    animateAlert: location.alertTitle != nil,
                                    expand: !isEditMode && expandedLocationID == location.id,
                                    cardStyle: location.cardStyle,
                                    onExpand: {
                                        if !isEditMode {
                                            let gen = UIImpactFeedbackGenerator(style: .medium)
                                            gen.impactOccurred()
                                            withAnimation(.spring()) {
                                                expandedLocationID = expandedLocationID == location.id ? nil : location.id
                                                selectedLocationID = location.id
                                            }
                                        }
                                    },
                                    importantText: importantWeatherText(for: location.model)
                                )
                                if isEditMode {
                                    HStack(spacing: 8) {
                                        Text("Style:")
                                            .foregroundColor(Color("Text Secondary"))
                                        Picker("", selection: Binding(
                                            get: { location.cardStyle },
                                            set: { newValue in
                                                if let idx = locations.firstIndex(where: { $0.id == location.id }) {
                                                    locations[idx].cardStyle = newValue
                                                }
                                            }
                                        )) {
                                            Text("Glass").tag(LocationWeatherCard.CardStyle.glass)
                                            Text("Neon").tag(LocationWeatherCard.CardStyle.neon)
                                            Text("Minimal").tag(LocationWeatherCard.CardStyle.minimal)
                                        }
                                        .pickerStyle(.segmented)
                                        .frame(width: 230)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.top, 8)
                                }
                            }
                        }
                        .onTapGesture {
                            if !isEditMode {
                                let gen = UIImpactFeedbackGenerator(style: .light)
                                gen.impactOccurred()
                                withAnimation(.spring()) {
                                    expandedLocationID = expandedLocationID == location.id ? nil : location.id
                                    selectedLocationID = location.id
                                }
                            }
                        }
                        .listRowBackground(Color.clear)
                        .swipeActions(edge: .leading, allowsFullSwipe: !isEditMode) {
                            Button {
                                if let idx = locations.firstIndex(where: { $0.id == location.id }) {
                                    for j in locations.indices {
                                        locations[j].isUserLocation = (j == idx)
                                    }
                                }
                            } label: {
                                Label("Set as Home", systemImage: "house.fill")
                            }
                            .tint(Color("Graph Line 1"))
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: !isEditMode) {
                            Button(role: .destructive) {
                                locationToDelete = location
                                showDeleteAlert = true
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                    .onMove { from, to in
                        if isEditMode {
                            withAnimation(.spring()) {
                                locations.move(fromOffsets: from, toOffset: to)
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .environment(\.editMode, .constant(isEditMode ? EditMode.active : EditMode.inactive))
                .padding(.top, 4)
            }
            AddLocationOverlay(show: $showingAddLocation) { newLocation in
                withAnimation(.spring()) {
                    locations.insert(newLocation, at: 0)
                }
            }
        }
        .alert("Delete this location?", isPresented: $showDeleteAlert, presenting: locationToDelete) { loc in
            Button("Delete", role: .destructive) {
                locations.removeAll(where: { $0.id == loc.id })
            }
            Button("Cancel", role: .cancel) { }
        } message: { loc in
            Text("Are you sure you want to delete \(loc.model.city)?")
        }
        .background(
            LinearGradient(
                colors: [Color("Background"), Color("Graph Line 2").opacity(0.13)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationBarBackButtonHidden(true)
        .onAppear { loadLocations() }
        .onChange(of: locations) {
            saveLocations()
        }
    }

    private func loadLocations() {
        if let decoded = try? JSONDecoder().decode([LocationDisplay].self, from: savedLocationsData), !decoded.isEmpty {
            locations = decoded
        } else {
            locations = defaultLocations
        }
    }

    private func saveLocations() {
        if let encoded = try? JSONEncoder().encode(locations) {
            savedLocationsData = encoded
        }
    }

    func importantWeatherText(for model: LocationModel) -> String {
        if model.condition.lowercased().contains("thunderstorm") {
            return "Severe Thunderstorm Risk: High"
        } else if model.condition.lowercased().contains("fog") {
            return "Visibility: Low"
        } else if model.temp > 100 {
            return "Heat Advisory: Stay Hydrated"
        } else if model.condition.lowercased().contains("rain") {
            return "Rain Chance: 80%"
        } else if model.temp < 32 {
            return "Freezing Risk: Take Care"
        }
        return "Humidity: 78%"
    }
}

#Preview {
    LocationsView()
}
