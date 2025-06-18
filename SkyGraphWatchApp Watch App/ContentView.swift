import SwiftUI
import UIKit
import WatchKit

struct MinuteRain: Identifiable {
    let id = UUID()
    let minute: Int
    let precipChance: Double
}

struct HourForecast: Identifiable {
    let id = UUID()
    let hour: String
    let temp: Double
    let feelsLike: Double
    let precip: Double
    let icon: String
}

struct DayForecast: Identifiable {
    let id = UUID()
    let day: String
    let high: Double
    let low: Double
    let icon: String
    let precip: Double
}

struct Haptics {
    static func tap() { WKInterfaceDevice.current().play(.click) }
    static func success() { WKInterfaceDevice.current().play(.success) }
    static func fail() { WKInterfaceDevice.current().play(.failure) }
}

let sources = ["OpenWeather", "Tomorrow.io", "Apple Weather"]
let sourceDescriptions = [
    "OpenWeather provides global hyperlocal weather data.",
    "Tomorrow.io specializes in minute-by-minute rain prediction.",
    "Apple Weather is powered by Apple’s advanced weather service."
]

let fakeMinuteRain: [MinuteRain] = (0..<60).map {
    MinuteRain(minute: $0, precipChance: Double.random(in: $0 < 12 ? 50...80 : 0...30))
}

let fakeHourly: [HourForecast] = (0..<10).map { i in
    let hour = "\(6 + i)a"
    let icons = ["cloud.sun.fill", "sun.max.fill", "cloud.fill", "cloud.rain.fill", "cloud.bolt.rain.fill"]
    return HourForecast(
        hour: hour,
        temp: Double(62 + Int.random(in: 0...16)),
        feelsLike: Double(61 + Int.random(in: 0...16)),
        precip: Double(Int.random(in: 0...40)),
        icon: icons[i % icons.count]
    )
}

let fakeDaily: [DayForecast] = [
    .init(day: "Mon", high: 81, low: 68, icon: "cloud.sun.fill", precip: 0),
    .init(day: "Tue", high: 80, low: 67, icon: "cloud.sun.fill", precip: 0),
    .init(day: "Wed", high: 75, low: 63, icon: "cloud.rain.fill", precip: 40),
    .init(day: "Thu", high: 78, low: 65, icon: "cloud.bolt.rain.fill", precip: 80),
    .init(day: "Fri", high: 82, low: 70, icon: "sun.max.fill", precip: 0)
]

let fakeNWSAlert: [Alert] = [
    .init(
        title: "Severe Thunderstorm",
        description: "Wind gusts up to 60 mph and heavy rain expected.",
        severity: .warning,
        startTime: "2:00 PM",
        endTime: "6:00 PM"
    ),
    .init(
        title: "Flash Flood Watch",
        description: "Excessive rainfall may lead to flash flooding.",
        severity: .watch,
        startTime: "3:00 PM",
        endTime: "10:00 PM"
    ),
    .init(
        title: "Air Quality Advisory",
        description: "Unhealthy AQI for sensitive groups due to smoke.",
        severity: .advisory,
        startTime: "Now",
        endTime: "8:00 PM"
    )
]

struct ContentView: View {
    @AppStorage("provider") private var selectedSource = 1
    @AppStorage("minimalMode") private var minimalMode = false
    
    @State private var showSourceInfo = false
    @State private var locations = ["New York", "Miami", "Chicago", "Tokyo"]
    @State private var selectedLocation = 0
    @State private var showLocationPicker = false
    @State private var selectedHour = 3
    @State private var graphType = 0
    @State private var showSettings = false
    
    @State private var showAlertDetails = false
    @State private var showFakeNWS = true
    @State private var freezeInteraction = false
    @State private var selectedAlert: Alert? = nil
    
    
    var graphColor: Color {
        switch graphType {
        case 1: return Color("Graph Line 2")
        case 2: return .blue
        default: return Color("AccentColor")
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    HStack {
                        Spacer()
                        Button {
                            Haptics.tap()
                            showLocationPicker = true
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "location.fill").foregroundColor(.accentColor)
                                Text(locations[selectedLocation]).font(.headline).bold()
                            }
                            .padding(.horizontal, 18)
                            .padding(.vertical, 7)
                            .background(.ultraThinMaterial)
                            .cornerRadius(24)
                            .shadow(color: Color.background.opacity(0.07) as! Color, radius: 4, x: 0, y: 2)
                        }
                        .buttonStyle(.plain)
                        Spacer()
                    }
                    .padding(.vertical, 2)
                    
                    let h = fakeHourly[selectedHour]
                    GlassyCard {
                        VStack(spacing: 7) {
                            HStack(alignment: .firstTextBaseline, spacing: 10) {
                                Text("\(Int(h.temp))°")
                                    .font(.system(size: 38, weight: .bold))
                                    .foregroundColor(.primary)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Feels like \(Int(h.feelsLike))°")
                                        .font(.system(size: 14)).foregroundColor(.secondary)
                                    Text("UV \(Int.random(in: 2...8)), AQI \(Int.random(in: 15...60)), Pollen \(Int.random(in: 3...9))")
                                        .font(.system(size: 11)).foregroundColor(.secondary)
                                }
                            }
                            Image(systemName: h.icon)
                                .font(.system(size: 33))
                                .foregroundColor(Color("Graph Line 2"))
                                .shadow(radius: 2)
                            Text(Date.now, style: .date)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            MiniStatRing(precip: Int(h.precip), wind: 12, aqi: 40)
                        }
                    }
                    
                    if !fakeNWSAlert.isEmpty {
                        GlassyCard {
                            VStack(spacing: 6) {
                                ForEach(fakeNWSAlert.indices, id: \.self) { i in
                                    AlertPillBanner(alert: fakeNWSAlert[i]) {
                                        selectedAlert = fakeNWSAlert[i]
                                        showAlertDetails = true
                                    }
                                    if i != fakeNWSAlert.count - 1 {
                                        Divider().opacity(0.08)
                                    }
                                }
                            }
                            .padding(.vertical, 6)
                        }
                    }
                    
                    GlassyCard {
                        VStack(spacing: 7) {
                            HStack {
                                Image(systemName: "cloud.rain.fill").foregroundColor(.blue)
                                Text("Rain Timeline").font(.headline)
                                Spacer()
                            }
                            RainTimelineView(minutes: fakeMinuteRain)
                        }
                    }
                    
                    GlassyCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Next Hours").font(.caption).foregroundColor(.secondary)
                            ScrollableWeatherGraph(
                                hours: fakeHourly,
                                selectedHour: $selectedHour,
                                selectedType: $graphType,
                                graphColor: graphColor
                            )
                            HStack(spacing: 7) {
                                let titles = ["Temp", "Feels Like", "Precip"]
                                ForEach(0..<3, id: \.self) { i in
                                    let isSelected = graphType == i
                                    Button(action: { withAnimation { graphType = i } }) {
                                        Text(titles[i])
                                            .font(.system(size: 13, weight: isSelected ? .bold : .regular))
                                            .foregroundColor(isSelected ? graphColor : .primary)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 2)
                                            .background(isSelected ? graphColor.opacity(0.16) : Color.clear)
                                            .cornerRadius(7)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    
                    TwoDayTempGraphCard()
                    SunriseSunsetCard()
                    WindPressureCard()
                    
                    GlassyCard {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Next 5 Days").font(.caption).foregroundColor(.secondary)
                            ForEach(fakeDaily) { day in
                                FiveDayForecastRow(day: day)
                                if day.id != fakeDaily.last?.id {
                                    Divider().opacity(0.18)
                                }
                            }
                        }
                    }
                    
                    WeatherMoodQuoteCard()
                    
                    HStack(spacing: 8) {
                        Image(systemName: "bolt.horizontal.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.accentColor)
                        Text(sources[selectedSource])
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Button {
                            showSourceInfo = true
                        } label: {
                            Image(systemName: "info.circle")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical, 8)
                }
                .padding(.top, 10)
                .padding(.horizontal, 7)
            }
            .background(
                LinearGradient(colors: [Color(.darkGray).opacity(0.85), Color(.black)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            )
            .sheet(isPresented: $showSourceInfo) {
                SourceInfoSheet(
                    source: sources[selectedSource],
                    description: sourceDescriptions[selectedSource],
                    showSheet: $showSourceInfo
                )
            }
            .sheet(item: $selectedAlert) { alert in
                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Image(systemName: alert.severity.icon)
                                .font(.system(size: 34))
                                .foregroundColor(alert.severity.color)
                            Text(alert.severity.label)
                                .font(.headline)
                                .foregroundColor(alert.severity.color)
                        }
                        
                        Text(alert.title)
                            .font(.title3.bold())
                            .padding(.bottom, 4)
                        
                        HStack {
                            Label("Start", systemImage: "clock")
                            Spacer()
                            Text(alert.startTime)
                        }
                        
                        HStack {
                            Label("End", systemImage: "clock.fill")
                            Spacer()
                            Text(alert.endTime)
                        }
                        
                        Divider()
                        
                        Text(alert.description)
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                }
            }
            
            
            
            
            .navigationDestination(isPresented: $showLocationPicker) {
                LocationPicker(
                    locations: $locations,
                    selectedIndex: $selectedLocation,
                    dismiss: { showLocationPicker = false },
                    goToSettings: {},
                    addLocation: { locations.append("New Location") }
                )
            }
            .navigationDestination(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }
}

#Preview {
    ContentView()
}
