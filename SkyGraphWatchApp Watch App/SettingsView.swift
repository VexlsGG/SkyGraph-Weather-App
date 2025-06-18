import SwiftUI
import WatchKit

struct SettingsView: View {
    @AppStorage("useMetric") private var useMetric = false
    @AppStorage("provider") private var provider = 1 // 0: OpenWeather, 1: Tomorrow.io, 2: Apple Weather
    @AppStorage("minimalMode") private var minimalMode = false
    @AppStorage("enableHaptics") private var enableHaptics = true
    @AppStorage("smartMode") private var smartMode = false

    let providers = ["OpenWeather", "Tomorrow.io", "Apple Weather"]
    let fakeTemps = [72, 70, 69] // Simulated side-by-side temps

    var body: some View {
        Form {
            Section(header: Text("UNITS")) {
                Toggle("Use Metric Units", isOn: Binding(
                    get: { useMetric },
                    set: {
                        useMetric = $0
                        triggerHaptic()
                    }
                ))
            }

            Section(header: Text("WEATHER PROVIDER")) {
                Picker("Provider", selection: Binding(
                    get: { provider },
                    set: {
                        provider = $0
                        triggerHaptic(style: .success)
                    }
                )) {
                    ForEach(0..<providers.count, id: \.self) { index in
                        Text(providers[index])
                    }
                }
            }

            Section(header: Text("LIVE COMPARISON")) {
                ForEach(0..<providers.count, id: \.self) { i in
                    HStack {
                        Text(providers[i])
                        Spacer()
                        Text("\(fakeTemps[i])°")
                            .foregroundColor(.secondary)
                    }
                }
            }

            Section(header: Text("LAYOUT")) {
                Toggle("Enable Minimal Mode", isOn: Binding(
                    get: { minimalMode },
                    set: {
                        minimalMode = $0
                        triggerHaptic()
                    }
                ))
            }

            Section(header: Text("SMART MODE")) {
                Toggle("Auto Layout & Theme", isOn: Binding(
                    get: { smartMode },
                    set: {
                        smartMode = $0
                        triggerHaptic(style: .success)
                    }
                ))
                Text("Smart Mode picks the best provider, layout and theme based on time & location.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.top, 2)
            }
        }
        .navigationTitle("Settings")
    }

    // MARK: - Trigger Haptic (Only if enabled)
    func triggerHaptic(style: WKHapticType = .click) {
        if enableHaptics {
            WKInterfaceDevice.current().play(style)
        }
    }
}

#Preview {
    SettingsView()
}
