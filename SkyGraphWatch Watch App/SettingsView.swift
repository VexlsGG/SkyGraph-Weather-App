// SkyGraph - WatchOS Settings Page (No Theme Option)
import SwiftUI

struct SettingsView: View {
    @AppStorage("useMetric") private var useMetric = false
    @AppStorage("provider") private var provider = 1 // 0: OpenWeather, 1: Tomorrow.io, 2: Apple Weather

    let providers = ["OpenWeather", "Tomorrow.io", "Apple Weather"]

    var body: some View {
        Form {
            Section(header: Text("UNITS")) {
                Toggle(isOn: $useMetric) {
                    Text("Use Metric Units")
                }
            }

            Section(header: Text("WEATHER PROVIDER")) {
                Picker("Provider", selection: $provider) {
                    ForEach(0..<providers.count, id: \.\self) { index in
                        Text(providers[index])
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }
}

// MARK: - Preview
#Preview {
    SettingsView()
}
