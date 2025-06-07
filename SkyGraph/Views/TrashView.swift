import SwiftUI

/// View for displaying and managing trashed locations
struct TrashView: View {
    @AppStorage("trashedLocations") private var trashedData: Data = Data()
    @State private var trashedLocations: [TrashedLocation] = []
    @State private var editMode = false
    @State private var selection = Set<UUID>()
    @State private var showUndo = false
    @State private var undoAction: (() -> Void)?

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 24) {
                header
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(trashedLocations) { trash in
                            LocationWeatherCard(
                                location: trash.location.model,
                                isActive: false,
                                alertTitle: trash.location.alertTitle,
                                cardStyle: .glass,
                                onExpand: {},
                                importantText: importantWeatherText(for: trash.location.model)
                            )
                            .overlay(actionButtons(for: trash))
                            .transition(.asymmetric(insertion: .scale.combined(with: .opacity),
                                                    removal: .move(edge: .trailing).combined(with: .opacity)))
                            .animation(.spring(), value: trashedLocations)
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(Color.red.opacity(selection.contains(trash.id) ? 0.8 : 0), lineWidth: 3)
                            )
                            .onTapGesture {
                                if editMode {
                                    toggleSelection(trash)
                                }
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel(Text("\(trash.location.model.city) trashed"))
                        }
                    }
                    .padding()
                }
            }
            if showUndo {
                UndoSnackbar { undoAction?(); hideUndo() }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.spring(), value: showUndo)
            }
        }
        .background(Color("Background").ignoresSafeArea())
        .navigationTitle("Trash")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(editMode ? "Done" : "Select") {
                    withAnimation { editMode.toggle(); selection.removeAll() }
                }
            }
            if editMode {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: batchRestore) { Text("Restore") }
                        .disabled(selection.isEmpty)
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(role: .destructive, action: batchDelete) { Text("Delete") }
                        .disabled(selection.isEmpty)
                }
            }
        }
        .onAppear {
            load()
            removeExpiredAnimated()
        }
    }

    private var header: some View {
        HStack {
            Text("Trashed Locations")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(Color("Text Primary"))
            Spacer()
        }
        .padding(.horizontal)
    }

    private func actionButtons(for trash: TrashedLocation) -> some View {
        HStack {
            Spacer()
            VStack {
                Button {
                    restore(trash)
                } label: {
                    Image(systemName: "arrow.uturn.left")
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel(Text("Restore \(trash.location.model.city)"))

                Button(role: .destructive) {
                    deleteForever(trash)
                } label: {
                    Image(systemName: "trash")
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel(Text("Delete \(trash.location.model.city) forever"))
            }
        }
        .padding(.trailing, 12)
    }

    private func toggleSelection(_ trash: TrashedLocation) {
        if selection.contains(trash.id) {
            selection.remove(trash.id)
        } else {
            selection.insert(trash.id)
        }
    }

    private func batchRestore() {
        let selected = trashedLocations.filter { selection.contains($0.id) }
        selection.removeAll()
        for trash in selected { restore(trash, showSnack: false) }
        showUndo(action: { moveAllToTrash(selected) })
    }

    private func batchDelete() {
        let selected = trashedLocations.filter { selection.contains($0.id) }
        selection.removeAll()
        for trash in selected { deleteForever(trash, showSnack: false) }
        showUndo(action: { trashedLocations.append(contentsOf: selected); save() })
    }

    private func restore(_ trash: TrashedLocation, showSnack: Bool = true) {
        guard let index = trashedLocations.firstIndex(where: { $0.id == trash.id }) else { return }
        withAnimation {
            trashedLocations.remove(at: index)
        }
        save()
        if showSnack {
            showUndo(action: { trashedLocations.insert(trash, at: index); save() })
        }
    }

    private func deleteForever(_ trash: TrashedLocation, showSnack: Bool = true) {
        guard let index = trashedLocations.firstIndex(where: { $0.id == trash.id }) else { return }
        withAnimation(.easeIn(duration: 0.35)) {
            trashedLocations.remove(at: index)
        }
        save()
        if showSnack {
            showUndo(action: { trashedLocations.insert(trash, at: index); save() })
        }
    }

    private func moveAllToTrash(_ items: [TrashedLocation]) {
        trashedLocations.append(contentsOf: items)
        save()
    }

    private func showUndo(action: @escaping () -> Void) {
        undoAction = action
        withAnimation { showUndo = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            hideUndo()
        }
    }

    private func hideUndo() {
        withAnimation { showUndo = false }
        undoAction = nil
    }

    private func load() {
        if let decoded = try? JSONDecoder().decode([TrashedLocation].self, from: trashedData) {
            trashedLocations = decoded
        }
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(trashedLocations) {
            trashedData = encoded
        }
    }

    private func removeExpiredAnimated() {
        let expired = trashedLocations.filter { $0.isExpired }
        if !expired.isEmpty {
            for item in expired {
                if let idx = trashedLocations.firstIndex(where: { $0.id == item.id }) {
                    withAnimation(.easeOut) {
                        trashedLocations.remove(at: idx)
                    }
                }
            }
            save()
        }
    }

    func importantWeatherText(for model: LocationModel) -> String {
        if model.condition.lowercased().contains("thunderstorm") { return "Severe Thunderstorm Risk: High" }
        if model.condition.lowercased().contains("fog") { return "Visibility: Low" }
        if model.temp > 100 { return "Heat Advisory: Stay Hydrated" }
        if model.condition.lowercased().contains("rain") { return "Rain Chance: 80%" }
        if model.temp < 32 { return "Freezing Risk: Take Care" }
        return "Humidity: 78%"
    }
}

private struct UndoSnackbar: View {
    var undo: () -> Void
    @State private var visible = true

    var body: some View {
        if visible {
            HStack {
                Text("Action completed")
                Spacer()
                Button("Undo", action: undo)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .padding()
            .onAppear {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
            .onTapGesture { withAnimation { visible = false } }
        }
    }
}

#Preview {
    TrashView()
}
