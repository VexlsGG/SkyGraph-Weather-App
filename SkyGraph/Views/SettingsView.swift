import SwiftUI

struct SettingsView: View {
    @AppStorage("theme") private var theme: Int = 2
    @AppStorage("useMetric") private var useMetric = false
    @AppStorage("provider") private var provider = 0
    @AppStorage("alertsEnabled") private var alertsEnabled = true
    @AppStorage("experimentalEnabled") private var experimentalEnabled = false
    @AppStorage("notificationTone") private var notificationTone = 0
    @AppStorage("appIcon") private var appIcon = 0
    @AppStorage("chartStyle") private var chartStyle = 1
    @AppStorage("showOnboarding") private var showOnboarding = false
    @AppStorage("isProUser") private var isProUser = false

    @State private var showChangelog = false
    @State private var showGlossary = false
    @State private var showEasterEgg = false
    @State private var showFeedbackSheet = false
    @State private var showPrivacy = false
    @State private var showGoPro = false

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                headerCard

                if !isProUser {
                    Button(action: { showGoPro = true }) {
                        HStack(spacing: 12) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.title2)
                            VStack(alignment: .leading, spacing: 1) {
                                Text("SkyGraph Pro")
                                    .font(.title3.bold())
                                    .foregroundStyle(
                                        LinearGradient(colors: [Color("Graph Line 1"), Color("Graph Line 2")], startPoint: .leading, endPoint: .trailing)
                                    )
                                Text("Unlock all features")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .opacity(0.2)
                        }
                        .padding(.vertical, 13)
                        .padding(.horizontal, 18)
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .shadow(color: Color("Graph Line 1").opacity(0.08), radius: 6, y: 2)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }

                settingsCard(title: "Personalization", systemIcon: "paintbrush.pointed.fill") {
                    Toggle(isOn: $useMetric) {
                        Label("Use Metric Units", systemImage: "ruler.fill")
                    }
                    Divider().opacity(0.5)
                    HStack {
                        Label("Theme", systemImage: "circle.lefthalf.filled")
                        Spacer()
                        Picker("", selection: $theme) {
                            Text("Light").tag(0)
                            Text("Dark").tag(1)
                            Text("Auto").tag(2)
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 170)
                    }
                    Divider().opacity(0.5)
                    HStack {
                        Label("Chart Style", systemImage: "chart.line.uptrend.xyaxis")
                        Spacer()
                        Picker("", selection: $chartStyle) {
                            Text("Icons").tag(0)
                            Text("Graph").tag(1)
                            Text("Bar").tag(2)
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 180)
                    }
                    Divider().opacity(0.5)
                    HStack {
                        Label("App Icon", systemImage: "app.dashed")
                        Spacer()
                        Picker("", selection: $appIcon) {
                            Text("Classic").tag(0)
                            Text("Glass").tag(1)
                            Text("Midnight").tag(2)
                        }
                        .pickerStyle(.menu)
                        .frame(width: 120)
                    }
                }

                settingsCard(title: "Weather Provider", systemIcon: "cloud.sun.rain.fill") {
                    HStack {
                        Label("Provider", systemImage: "network")
                        Spacer()
                        Picker("", selection: $provider) {
                            Text("Tomorrow.io").tag(0)
                            Text("OpenWeather").tag(1)
                            Text("WeatherKit").tag(2)
                        }
                        .pickerStyle(.menu)
                        .frame(width: 150)
                    }
                }

                settingsCard(title: "Notifications", systemIcon: "bell.badge.fill") {
                    Toggle(isOn: $alertsEnabled) {
                        Label("Weather Alerts", systemImage: "exclamationmark.triangle.fill")
                    }
                    .tint(Color.yellow.opacity(0.85))
                    Divider().opacity(0.5)
                    HStack {
                        Label("Alert Tone", systemImage: "music.note")
                        Spacer()
                        Picker("", selection: $notificationTone) {
                            Text("Default").tag(0)
                            Text("Radar Pulse").tag(1)
                            Text("Glass Pop").tag(2)
                        }
                        .pickerStyle(.menu)
                        .frame(width: 130)
                    }
                }

                settingsCard(title: "Experience", systemIcon: "star.square.fill") {
                    Toggle(isOn: $showOnboarding) {
                        Label("Show Onboarding", systemImage: "sparkles.tv")
                    }
                    Divider().opacity(0.5)
                    Button {
                        showFeedbackSheet.toggle()
                    } label: {
                        Label("Send Feedback", systemImage: "envelope.fill")
                    }
                    .buttonStyle(.borderless)
                    Divider().opacity(0.5)
                    Button {
                        showPrivacy.toggle()
                    } label: {
                        Label("Privacy & Data", systemImage: "hand.raised.fill")
                    }
                    .buttonStyle(.borderless)
                }

                settingsCard(title: "More Info", systemIcon: "info.bubble.fill") {
                    Button {
                        showChangelog.toggle()
                    } label: {
                        Label("Changelog", systemImage: "clock.arrow.circlepath")
                    }
                    .buttonStyle(.borderless)
                    Divider().opacity(0.5)
                    Button {
                        showGlossary.toggle()
                    } label: {
                        Label("Glossary", systemImage: "book.closed.fill")
                    }
                    .buttonStyle(.borderless)
                }

                settingsCard(title: "Experimental ⚡️", systemIcon: "sparkles", gradientBorder: true) {
                    Toggle(isOn: $experimentalEnabled) {
                        Label("Enable Beta Features", systemImage: "bolt.fill")
                    }
                    .tint(.purple)
                    Text("Beta features are unstable and may change without notice.")
                        .font(.caption2)
                        .foregroundColor(Color.yellow.opacity(0.7))
                        .padding(.top, -4)
                }

                settingsCard(title: "About", systemIcon: "info.circle.fill") {
                    HStack {
                        Label("Version", systemImage: "number")
                        Spacer()
                        Text("1.0")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 3)
                            .background(
                                Capsule()
                                    .fill(Color("Graph Line 2").opacity(0.18))
                            )
                            .foregroundColor(Color("Graph Line 1"))
                    }
                    Divider().opacity(0.5)
                    HStack {
                        Text("Made with ❤️ by VexlsGG")
                            .font(.caption)
                            .foregroundColor(Color("Text Secondary"))
                        Spacer()
                        Button(action: {
                            showEasterEgg.toggle()
                        }) {
                            Image(systemName: "sparkles")
                                .opacity(0.4)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .background(
            LinearGradient(
                colors: [Color("Background"), Color("Card").opacity(0.36)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .sheet(isPresented: $showChangelog) { ChangelogView() }
        .sheet(isPresented: $showGlossary) { GlossaryView() }
        .sheet(isPresented: $showFeedbackSheet) { FeedbackSheet() }
        .sheet(isPresented: $showPrivacy) { PrivacySheet() }
        .sheet(isPresented: $showGoPro) { GoProView(isProUser: $isProUser) }
        .alert("✨ Welcome to SkyGraph! ✨", isPresented: $showEasterEgg) {
            Button("Nice!") {}
        } message: {
            Text("You found the hidden Easter Egg! Thanks for exploring SkyGraph 🦄")
        }
    }

    var headerCard: some View {
        HStack(spacing: 16) {
            Image("Logo")
                .resizable()
                .frame(width: 54, height: 54)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color("Graph Line 1").opacity(0.19), radius: 12, x: 0, y: 4)
            VStack(alignment: .leading, spacing: 2) {
                Text("SkyGraph")
                    .font(.largeTitle.bold())
                    .foregroundStyle(LinearGradient(
                        colors: [Color("Graph Line 1"), Color("Graph Line 2")],
                        startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                Text("Weather, reimagined.")
                    .font(.callout)
                    .foregroundColor(Color("Text Secondary"))
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 12)
        .padding(.bottom, 6)
    }

    @ViewBuilder
    func settingsCard<Content: View>(
        title: String,
        systemIcon: String,
        gradientBorder: Bool = false,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 9) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color("Graph Line 1").opacity(0.22), Color("Graph Line 2").opacity(0.18)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 28, height: 28)
                    Image(systemName: systemIcon)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color("Graph Line 1"))
                }
                Text(title)
                    .font(.title3.bold())
                    .foregroundStyle(
                        LinearGradient(colors: [Color("Graph Line 1"), Color("Graph Line 2")], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
            }
            content()
        }
        .padding()
        .background(
            ZStack {
                GlassBackground(cornerRadius: 24)
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color("Card").opacity(0.62))
                if gradientBorder {
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(
                            LinearGradient(colors: [Color.purple, Color("Graph Line 2"), Color("Graph Line 1")], startPoint: .topLeading, endPoint: .bottomTrailing),
                            lineWidth: 2
                        )
                        .blur(radius: 0.5)
                        .opacity(0.85)
                        .padding(-2)
                        .animation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true), value: gradientBorder)
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color("Graph Line 1").opacity(0.10), lineWidth: 1.2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color("Graph Line 1").opacity(0.045), radius: 10, x: 0, y: 3)
    }
}
// MARK: - CHANGELOG MODAL, GLOSSARY, FEEDBACK, PRIVACY, PREVIEW

struct ChangelogView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("SkyGraph Changelog")
                        .font(.title.bold())
                        .padding(.bottom, 8)
                    Group {
                        Text("**v1.0 - Launch**")
                        Text("• Redesigned radar and forecast\n• Customizable themes\n• Multiple weather providers\n• Live notifications\n• Icon-based graphs and more!")
                    }
                    .font(.body)
                }
                .padding()
            }
            .navigationTitle("Changelog")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct GlossaryView: View {
    let glossaryItems: [(icon: String, meaning: String)] = [
        ("cloud.sun.fill", "Partly Cloudy"),
        ("sun.max.fill", "Clear & Sunny"),
        ("cloud.bolt.rain.fill", "Thunderstorm"),
        ("cloud.snow.fill", "Snow"),
        ("thermometer", "Temperature"),
        ("drop.fill", "Precipitation"),
        ("wind", "Wind Speed"),
        ("bell.badge.fill", "Weather Alert"),
        ("exclamationmark.triangle.fill", "Severe Alert"),
        ("chart.line.uptrend.xyaxis", "Graph Style"),
        ("paintbrush.pointed.fill", "Personalization")
    ]

    var body: some View {
        NavigationView {
            List(glossaryItems, id: \.icon) { item in
                HStack(spacing: 20) {
                    Image(systemName: item.icon)
                        .font(.system(size: 24))
                        .frame(width: 36)
                    Text(item.meaning)
                        .font(.body)
                }
                .padding(.vertical, 6)
            }
            .navigationTitle("Glossary")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct FeedbackSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var feedback = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Send us your feedback!")
                    .font(.title3.bold())
                TextEditor(text: $feedback)
                    .frame(height: 130)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("Graph Line 1").opacity(0.16)))
                    .padding(.vertical, 8)
                Button("Submit") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                Spacer()
            }
            .padding()
            .navigationTitle("Feedback")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct PrivacySheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Privacy & Data")
                        .font(.title.bold())
                    Text("SkyGraph does not sell or share your data. Your location and settings are stored locally, and weather requests are sent securely to your chosen provider.")
                        .font(.body)
                        .padding(.bottom, 6)
                    Text("**Your privacy, always first.**")
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .navigationTitle("Privacy")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    struct Container: View {
        @AppStorage("isProUser") var isProUser = false
        var body: some View {
            SettingsView()
        }
    }
    static var previews: some View {
        Container()
    }
}
