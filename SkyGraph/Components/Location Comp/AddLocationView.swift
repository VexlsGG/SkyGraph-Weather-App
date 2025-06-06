import SwiftUI

struct AddLocationView: View {
    @Environment(\.dismiss) var dismiss
    @State var city: String = ""
    @State var temp: String = ""
    @State var condition: String = ""
    @State var icon: String = ""
    @State var alertTitle: String = ""
    @State var isUserLocation: Bool = false

    var onAdd: (LocationDisplay) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Location Info")) {
                    TextField("City Name", text: $city)
                    TextField("Temperature", text: $temp)
                        .keyboardType(.numberPad)
                    TextField("Condition", text: $condition)
                    TextField("SF Symbol for Icon", text: $icon)
                    Toggle("Set as My Location", isOn: $isUserLocation)
                }
                Section(header: Text("Weather Alert (Optional)")) {
                    TextField("Alert Title", text: $alertTitle)
                }
                Section {
                    Button("Add Location") {
                        if let tempInt = Int(temp), !city.isEmpty {
                            let newLocation = LocationDisplay(
                                model: LocationModel(
                                    city: city,
                                    temp: tempInt,
                                    condition: condition.isEmpty ? "Clear" : condition,
                                    weatherIconName: icon.isEmpty ? "sun.max.fill" : icon,
                                    hourlyTemps: Array(repeating: tempInt, count: 8)
                                ),
                                isUserLocation: isUserLocation,
                                alertTitle: alertTitle.isEmpty ? nil : alertTitle
                            )
                            onAdd(newLocation)
                            dismiss()
                        }
                    }
                    .disabled(city.isEmpty || temp.isEmpty)
                }
            }
            .navigationTitle("Add Location")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
