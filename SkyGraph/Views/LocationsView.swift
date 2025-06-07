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

private enum WeatherAnimationStyle: CaseIterable {
    case wind, lightning, tornado
}

struct LocationsView: View {
    @AppStorage("savedLocations") private var savedLocationsData: Data = Data()
    @State private var locations: [LocationDisplay] = []
    @State private var showingAddLocation = false
    @State private var selectedLocationID: UUID? = nil
    @State private var expandedLocationID: UUID? = nil
    @State private var isEditMode = false
    @State private var showDeleteAlert = false
    @State private var locationToDelete: LocationDisplay?
    @State private var deletedLocation: (item: LocationDisplay, index: Int)?
    @State private var showUndo = false
    @State private var undoProgress: Double = 1.0
    @State private var weatherMessage: String = ""
    @State private var undoTimer: Timer?
    @State private var removalStyle: [UUID: WeatherAnimationStyle] = [:]
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
                        .transition(transition(for: location.id))
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
                .animation(.easeInOut, value: locations)
                .environment(\.editMode, .constant(isEditMode ? EditMode.active : EditMode.inactive))
                .padding(.top, 4)
            }
            AddLocationOverlay(show: $showingAddLocation) { newLocation in
                withAnimation(.spring()) {
                    locations.insert(newLocation, at: 0)
                }
            }
        }
        .overlay(
            Group {
                if let toDelete = locationToDelete, showDeleteAlert {
                    DeleteConfirmDialog(location: toDelete) { confirmed in
                        if confirmed { performDelete(toDelete) }
                        withAnimation { showDeleteAlert = false; locationToDelete = nil }
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
        )
        .overlay(
            Group {
                if showUndo, let deleted = deletedLocation {
                    UndoSnackbarView(message: weatherMessage, progress: undoProgress, undo: undoDelete, preview: deleted.item)
                        .padding(.bottom, 30)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }, alignment: .bottom
        )
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

// MARK: - Delete & Undo Helpers

private extension LocationsView {
    func performDelete(_ loc: LocationDisplay) {
        guard let index = locations.firstIndex(where: { $0.id == loc.id }) else { return }
        let style = WeatherAnimationStyle.allCases.randomElement() ?? .wind
        removalStyle[loc.id] = style
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
        withAnimation(.easeInOut) {
            deletedLocation = (loc, index)
            locations.remove(at: index)
        }
        weatherMessage = message(for: loc)
        startUndoTimer()
    }

    func startUndoTimer() {
        showUndo = true
        undoProgress = 1.0
        undoTimer?.invalidate()
        undoTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            undoProgress -= 0.05 / 5
            if undoProgress <= 0 {
                timer.invalidate()
                finalizeDelete()
            }
        }
    }

    func finalizeDelete() {
        withAnimation { showUndo = false }
        deletedLocation = nil
        undoTimer?.invalidate(); undoTimer = nil
    }

    func undoDelete() {
        guard let deleted = deletedLocation else { return }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        withAnimation(.spring()) {
            locations.insert(deleted.item, at: deleted.index)
        }
        finalizeDelete()
    }

    func message(for loc: LocationDisplay) -> String {
        [
            "\(loc.model.city) just blew away!",
            "That location's in the cloud now... literally.",
            "\(loc.model.city) was whisked away by the wind."].randomElement() ?? "Location deleted"
    }
}

// MARK: - Weather Transitions

private struct IdentityModifier: ViewModifier {
    func body(content: Content) -> some View { content }
}

private struct WindModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.offset(x: -300).opacity(0)
    }
}

private struct LightningModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.scaleEffect(0.1).opacity(0)
    }
}

private struct TornadoModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(720)).scaleEffect(0.1).opacity(0)
    }
}

private extension AnyTransition {
    static var wind: AnyTransition { .modifier(active: WindModifier(), identity: IdentityModifier()) }
    static var lightning: AnyTransition { .modifier(active: LightningModifier(), identity: IdentityModifier()) }
    static var tornado: AnyTransition { .modifier(active: TornadoModifier(), identity: IdentityModifier()) }
}

private extension LocationsView {
    func transition(for id: UUID) -> AnyTransition {
        switch removalStyle[id] ?? .wind {
        case .wind: return .wind
        case .lightning: return .lightning
        case .tornado: return .tornado
        }
    }
}

// MARK: - Delete Confirmation Dialog

private struct DeleteConfirmDialog: View {
    var location: LocationDisplay
    var onAction: (Bool) -> Void
    @State private var animateIcon = false

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cloud.bolt.fill")
                .font(.system(size: 40))
                .foregroundColor(Color("Graph Line 1"))
                .rotationEffect(.degrees(animateIcon ? 0 : -20))
                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: animateIcon)
            Text("Delete this location?")
                .font(.headline)
                .foregroundColor(Color("Text Primary"))
            Text(location.model.city)
                .font(.subheadline)
                .foregroundColor(Color("Text Secondary"))
            HStack(spacing: 30) {
                Button("Cancel") { onAction(false) }
                Button("Delete") { onAction(true) }
                    .tint(.red)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(24)
        .shadow(radius: 20)
        .onAppear {
            let gen = UIImpactFeedbackGenerator(style: .medium)
            gen.impactOccurred()
            animateIcon = true
        }
    }
}

// MARK: - Undo Snackbar

private struct UndoSnackbarView: View {
    var message: String
    var progress: Double
    var undo: () -> Void
    var preview: LocationDisplay

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: preview.model.weatherIconName)
                .foregroundColor(Color("Graph Line 2"))
            VStack(alignment: .leading) {
                Text(message)
                    .foregroundColor(Color("Text Primary"))
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color("Graph Line 1")))
                    .frame(width: 120)
            }
            Spacer()
            Button(action: undo) {
                Image(systemName: "arrow.uturn.left")
                    .padding(8)
                    .background(Circle().fill(Color("Graph Line 1")))
                    .foregroundColor(.white)
            }
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}
