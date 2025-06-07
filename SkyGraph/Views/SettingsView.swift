import SwiftUI

struct SettingsView: View {
    @State private var useMetric = false
    @State private var theme: Int = 2 // 0 light,1 dark,2 auto
    @State private var provider = 0
    @State private var alertsEnabled = true

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                settingsGroup(title: "Units") {
                    Toggle("Use Metric Units", isOn: $useMetric)
                }

                settingsGroup(title: "Theme") {
                    Picker("Theme", selection: $theme) {
                        Text("Light").tag(0)
                        Text("Dark").tag(1)
                        Text("Auto").tag(2)
                    }
                    .pickerStyle(.segmented)
                }

                settingsGroup(title: "Weather Provider") {
                    Picker("Provider", selection: $provider) {
                        Text("Tomorrow.io").tag(0)
                        Text("OpenWeather").tag(1)
                        Text("WeatherKit").tag(2)
                    }
                    .pickerStyle(.menu)
                }

                settingsGroup(title: "Notifications") {
                    Toggle("Weather Alerts", isOn: $alertsEnabled)
                }

                settingsGroup(title: "About") {
                    HStack {
                        Text("Version 1.0")
                        Spacer()
                        Image("Logo")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }

                Spacer(minLength: 40)
            }
            .padding()
        }
        .background(Color("Background").ignoresSafeArea())
    }

    @ViewBuilder
    func settingsGroup<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(Color("Text Primary"))
            content()
                .tint(Color("Graph Line 1"))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            ZStack {
                GlassBackground(cornerRadius: 22)
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color("Card").opacity(0.6))
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color("Graph Line 1").opacity(0.15), lineWidth: 1.2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

#Preview {
    SettingsView()
}
