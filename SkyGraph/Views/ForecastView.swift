import SwiftUI
import UIKit

struct Haptics {
    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    static func lightImpact() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

extension View {
    func shimmering(active: Bool = true) -> some View {
        self
            .overlay(
                active ?
                LinearGradient(
                    gradient: Gradient(colors: [Color.white.opacity(0.05), Color.white.opacity(0.25), Color.white.opacity(0.05)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .blendMode(.plusLighter)
                .blur(radius: 1.5)
                : nil
            )
            .animation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true), value: active)
    }
}


struct ForecastView: View {
    @State private var selectedDay: Int = 0
    @State private var showShareSheet = false

    let weatherAlerts: [WeatherAlert] = [
        WeatherAlert(type: .severe, title: "Thunderstorm Warning", detail: "Possible severe storms tonight."),
        WeatherAlert(type: .airQuality, title: "Air Quality Alert", detail: "Sensitive groups should limit outdoor activity.")
    ]

    let forecast: [ForecastDayModel] = (0..<14).map { i in
        ForecastDayModel(
            date: Calendar.current.date(byAdding: .day, value: i, to: Date())!,
            icon: ["cloud.fill", "cloud.sun.fill", "sun.max.fill", "cloud.bolt.rain.fill", "cloud.rain.fill"].randomElement()!,
            high: Double.random(in: 60...90),
            low: Double.random(in: 40...70),
            summary: ["Partly cloudy", "Sunny", "Thunderstorms", "Showers", "Overcast"].randomElement()!,
            hourly: (0..<8).map { _ in Int.random(in: 50...90) },
            precipChance: Double.random(in: 0...1)
        )
    }

    var hottestDay: ForecastDayModel? { forecast.max(by: { $0.high < $1.high }) }
    var coldestNight: ForecastDayModel? { forecast.min(by: { $0.low < $1.low }) }
    var wettestDay: ForecastDayModel? { forecast.max(by: { $0.precipChance < $1.precipChance }) }
    var sunniestDay: ForecastDayModel? { forecast.filter { $0.icon.contains("sun") }.max(by: { $0.high < $1.high }) }

    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 26) {
                    cleanHeader
                    if !weatherAlerts.isEmpty { alertPills }
                    highlightsRow
                    forecastGraph
                    precipChart
                    forecastCards
                    Spacer().frame(height: 24)
                    shareButton
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 4)
                .padding(.top, 14)
            }
        }
    }

    // Split up each major section as a computed property

    var cleanHeader: some View {
        let day = forecast[selectedDay]
        return VStack(spacing: 6) {
            Image(systemName: day.icon)
                .font(.system(size: 45, weight: .semibold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color("Graph Line 1"), Color("Graph Line 2")],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color("Graph Line 1").opacity(0.17), radius: 7, y: 2)
                .padding(4)
                .animation(.spring(response: 0.55, dampingFraction: 0.75), value: selectedDay)

            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("\(Int(day.high.rounded()))°")
                    .font(.system(size: 44, weight: .heavy, design: .rounded))
                    .foregroundColor(Color("Graph Line 1"))
                Text("/")
                    .font(.system(size: 38, weight: .bold))
                    .foregroundColor(.white.opacity(0.38))
                Text("\(Int(day.low.rounded()))°")
                    .font(.system(size: 35, weight: .bold, design: .rounded))
                    .foregroundColor(Color("Graph Line 2"))
            }
            Text("“\(day.summary)”")
                .font(.title3.weight(.medium))
                .foregroundColor(Color("Text Primary").opacity(0.82))
                .lineLimit(1)
            Text(longDay(day.date))
                .font(.subheadline.weight(.medium))
                .foregroundColor(Color("Text Secondary").opacity(0.54))
                .lineLimit(1)
        }
    }

    var alertPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(weatherAlerts) { alert in
                    WeatherAlertBadge(alert: alert)
                }
            }
            .padding(.vertical, 2)
            .padding(.horizontal, 2)
        }
    }

    var highlightsRow: some View {
        WeeklyHighlightsRow(
            hottestDay: hottestDay,
            coldestNight: coldestNight,
            wettestDay: wettestDay,
            sunniestDay: sunniestDay
        )
        .padding(.bottom, 2)
    }

    var forecastGraph: some View {
        ScrollableForecastGraph(forecast: forecast, selectedDay: $selectedDay)
            .frame(height: 180)
            .padding(.bottom, 2)
    }

    var precipChart: some View {
        PrecipBarChart(forecast: forecast, selectedDay: $selectedDay)
            .frame(height: 54)
            .padding(.bottom, 2)
    }

    var forecastCards: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 32) {
                ForEach(forecast.indices, id: \.self) { i in
                    GlassyForecastCard(
                        day: forecast[i],
                        isSelected: selectedDay == i,
                        onTap: {
                            withAnimation(.spring(response: 0.44, dampingFraction: 0.82)) {
                                selectedDay = i
                            }
                            Haptics.selection()
                        }
                    )
                    .scaleEffect(selectedDay == i ? 1.13 : 1.0)
                    .offset(y: selectedDay == i ? -12 : 0)
                    .zIndex(selectedDay == i ? 2 : 1)
                    .shadow(
                        color: Color("Graph Line 2").opacity(selectedDay == i ? 0.48 : 0.14),
                        radius: selectedDay == i ? 30 : 10,
                        y: selectedDay == i ? 14 : 3
                    )
                    .animation(.spring(response: 0.44, dampingFraction: 0.78), value: selectedDay)
                }
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 12)
            .padding(.bottom, 48)
        }

    }

    var shareButton: some View {
        Button {
            showShareSheet = true
        } label: {
            HStack {
                Image(systemName: "square.and.arrow.up")
                    .font(.title3.bold())
                Text("Share this Forecast")
                    .font(.title3.weight(.bold))
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 26)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color("Card").opacity(0.96))
                    .shadow(color: Color("Graph Line 2").opacity(0.09), radius: 8, y: 3)
            )
            .foregroundColor(Color("Graph Line 1"))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color("Graph Line 2").opacity(0.23), lineWidth: 1.3)
            )
            .padding(.top, 8)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showShareSheet) {
            ActivityView(activityItems: ["Check out my 14-day weather forecast!"])
        }
    }

    func longDay(_ date: Date) -> String {
        let f = DateFormatter()
        f.setLocalizedDateFormatFromTemplate("MMM d, EEE")
        return f.string(from: date)
    }
}

// MARK: - Weekly Highlights (3)
struct WeeklyHighlightsRow: View {
    var hottestDay: ForecastDayModel?
    var coldestNight: ForecastDayModel?
    var wettestDay: ForecastDayModel?
    var sunniestDay: ForecastDayModel?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 13) {
                if let hottest = hottestDay {
                    HighlightCard(
                        title: "Hottest",
                        value: "\(Int(hottest.high.rounded()))°",
                        subtitle: shortDay(hottest.date),
                        icon: "flame.fill",
                        color: .orange
                    )
                }
                if let coldest = coldestNight {
                    HighlightCard(
                        title: "Coldest Night",
                        value: "\(Int(coldest.low.rounded()))°",
                        subtitle: shortDay(coldest.date),
                        icon: "snowflake",
                        color: .blue
                    )
                }
                if let wettest = wettestDay, wettest.precipChance > 0.2 {
                    HighlightCard(
                        title: "Wettest",
                        value: "\(Int((wettest.precipChance * 100).rounded()))%",
                        subtitle: shortDay(wettest.date),
                        icon: "cloud.rain.fill",
                        color: .cyan
                    )
                }
                if let sunniest = sunniestDay {
                    HighlightCard(
                        title: "Sunniest",
                        value: "\(Int(sunniest.high.rounded()))°",
                        subtitle: shortDay(sunniest.date),
                        icon: "sun.max.fill",
                        color: .yellow
                    )
                }
            }
        }
    }
    func shortDay(_ date: Date) -> String {
        let f = DateFormatter(); f.dateFormat = "E"
        return f.string(from: date)
    }
}
struct HighlightCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(color)
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(color)
            }
            Text(value)
                .font(.title.bold())
                .foregroundColor(color)
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 11).padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color("Card").opacity(0.97))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(color.opacity(0.17), lineWidth: 1.2)
        )
        .shadow(color: color.opacity(0.12), radius: 6, y: 2)
    }
}

// MARK: - 4: Precipitation Bar Chart
struct PrecipBarChart: View {
    let forecast: [ForecastDayModel]
    @Binding var selectedDay: Int
    @State private var tooltipDay: Int? = nil

    var body: some View {
        HStack(alignment: .bottom, spacing: -2) {
            ForEach(forecast.indices, id: \.self) { i in
                let precip = forecast[i].precipChance
                let barHeight = CGFloat(44) * precip
                let isSelected = (i == selectedDay)
                let hasStorm = precip > 0.6
                VStack(spacing: 0) {
                    // --- Mini Rain/Storm Icon ---
                    if hasStorm {
                        Image(systemName: precip > 0.85 ? "cloud.bolt.rain.fill" : "cloud.rain.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.cyan)
                            .opacity(isSelected ? 1 : 0.6)
                            .padding(.bottom, 1)
                            .scaleEffect(isSelected ? 1.2 : 0.95)
                    } else {
                        Spacer().frame(height: 14)
                    }
                    
                    // --- Tooltip Bubble ---
                    ZStack {
                        if tooltipDay == i {
                            TooltipBubble(
                                text: "\(Int(precip * 100))% \(precip > 0.5 ? "Showers" : "Dry")"
                            )
                            .transition(.asymmetric(
                                insertion: .move(edge: .top).combined(with: .opacity),
                                removal: .move(edge: .bottom).combined(with: .opacity)
                            ))
                            .zIndex(10)
                        }
                    }
                    
                    // --- Bar ---
                    RoundedRectangle(cornerRadius: 5)
                        .fill(
                            LinearGradient(
                                colors: isSelected
                                    ? [Color("Graph Line 1"), Color("Graph Line 2")]
                                    : [Color("Graph Line 2").opacity(0.28 + precip*0.55),
                                       Color("Graph Line 1").opacity(0.20 + precip*0.35)],
                                startPoint: .bottom, endPoint: .top
                            )
                        )
                        .frame(width: isSelected ? 16 : 12, height: barHeight)
                        .shadow(color: isSelected ? Color("Graph Line 2").opacity(0.22) : .clear, radius: 8, y: 2)
                        .animation(.easeOut(duration: 0.85), value: barHeight)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.82)) {
                                // Always select this day, always show tooltip for THIS day only
                                if tooltipDay == i {
                                    tooltipDay = nil // Tap again to hide
                                } else {
                                    tooltipDay = i
                                    selectedDay = i
                                }
                            }
                        }
                    
                    // --- Precipitation % ---
                    Text("\(Int(precip * 100))%")
                        .font(.caption2.bold())
                        .foregroundColor(isSelected ? Color("Graph Line 2") : .white.opacity(0.33))
                        .padding(.top, 2)
                    
                    // --- Day of Week Label ---
                    Text(shortDay(forecast[i].date))
                        .font(.caption2)
                        .foregroundColor(isSelected ? Color("Graph Line 1") : .white.opacity(0.44))
                        .padding(.top, 2)
                }
                .padding(.horizontal, isSelected ? 3 : 1)
                .zIndex(isSelected ? 2 : 1)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color("Card").opacity(0.96))
        )
        .animation(.easeOut(duration: 0.6), value: selectedDay)
        .onChange(of: selectedDay) { newVal in
            // Remove tooltip if switching to a new day (prevents "big view stays" bug)
            withAnimation(.easeOut(duration: 0.38)) {
                tooltipDay = nil
            }
        }
    }
    func shortDay(_ date: Date) -> String {
        let f = DateFormatter(); f.dateFormat = "E"
        return f.string(from: date)
    }
}

struct HourlyPreviewBar: View {
    let hourly: [Int] // Each hour's temp (or rain chance)

    var body: some View {
        HStack(alignment: .bottom, spacing: 2) {
            ForEach(hourly.indices, id: \.self) { idx in
                Capsule()
                    .fill(LinearGradient(colors: [Color("Graph Line 1"), Color("Graph Line 2")], startPoint: .bottom, endPoint: .top))
                    .frame(width: 8, height: CGFloat(hourly[idx]) / 2) // 50...90 maps to 25...45
                    .opacity(0.88)
                    .shadow(color: Color("Graph Line 1").opacity(0.11), radius: 3, y: 2)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 40)
        .padding(.top, 6)
    }
}


struct GlassyForecastCard: View {
    let day: ForecastDayModel
    let isSelected: Bool
    let onTap: () -> Void

    var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.setLocalizedDateFormatFromTemplate("EEEE")
        return formatter.string(from: day.date)
    }

    var body: some View {
        VStack(spacing: isSelected ? 12 : 7) {
            Image(systemName: day.icon)
                .font(.system(size: isSelected ? 33 : 22, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color("Graph Line 1"), Color("Graph Line 2")],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                .shadow(color: isSelected ? Color("Graph Line 1").opacity(0.22) : .clear, radius: isSelected ? 8 : 0, y: 2)
                .padding(.top, isSelected ? 8 : 2)

            Text(dayOfWeek)
                .font(.caption2.weight(.medium))
                .foregroundColor(isSelected ? Color("Graph Line 2") : .white.opacity(0.55))

            HStack(spacing: 4) {
                Text("\(Int(day.high.rounded()))°")
                    .font(.system(size: isSelected ? 28 : 17, weight: .bold, design: .rounded))
                    .foregroundColor(Color("Graph Line 1"))
                Text("\(Int(day.low.rounded()))°")
                    .font(.system(size: isSelected ? 18 : 13, weight: .medium, design: .rounded))
                    .foregroundColor(Color("Graph Line 2"))
            }

            Text("“\(day.summary)”")
                .font(.caption)
                .foregroundColor(.white.opacity(0.66))
                .padding(.bottom, isSelected ? 2 : 0)

            if isSelected {
                SparklineGraph(values: day.hourly.map { Double($0) })
                    .frame(height: 20)
                    .padding(.top, 2)
                    .padding(.bottom, 3)

                Button {
                    CalendarManager.shared.addWeatherEvent(for: day) { _, _ in }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "calendar.badge.plus")
                            .font(.subheadline.bold())
                        Text("Calendar")
                            .font(.caption.weight(.bold))
                    }
                    .frame(maxWidth: .infinity) // Make button fill width
                    .padding(.vertical, 15)
                    .background(
                        Capsule()
                            .fill(Color("Card").opacity(0.95))
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color("Graph Line 2").opacity(0.18), lineWidth: 1)
                    )
                    .foregroundColor(Color("Graph Line 2"))
                    .shadow(color: Color("Graph Line 2").opacity(0.09), radius: 3, y: 2)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 7)
                .padding(.top, 4)
            }
        }
        .frame(width: isSelected ? 125 : 105, height: isSelected ? 156 : 110)
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.ultraThinMaterial)
                .background(
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color("Card").opacity(isSelected ? 0.97 : 0.91))
                        .blur(radius: isSelected ? 1.2 : 0.5)
                )
                .shadow(color: Color("Graph Line 1").opacity(isSelected ? 0.19 : 0.07), radius: isSelected ? 17 : 5, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .strokeBorder(
                    AnyShapeStyle(
                        LinearGradient(
                            colors: [Color("Graph Line 2"), Color("Graph Line 1").opacity(0.85)],
                            startPoint: .top, endPoint: .bottom
                        )
                    ),
                    lineWidth: isSelected ? 2.7 : 1
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .stroke(Color.white.opacity(isSelected ? 0.13 : 0.08), lineWidth: 2.2)
                .blur(radius: 1.3)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring()) {
                onTap()
            }
        }
    }
}

struct SparklineGraph: View {
    let values: [Double]

    var normalized: [CGFloat] {
        guard let min = values.min(), let max = values.max(), max != min else {
            return values.map { _ in 0.5 }
        }
        return values.map { CGFloat(($0 - min) / (max - min)) }
    }

    var body: some View {
        GeometryReader { geo in
            Path { path in
                for (i, value) in normalized.enumerated() {
                    let x = geo.size.width * CGFloat(i) / CGFloat(max(values.count - 1, 1))
                    let y = geo.size.height * (1 - value)
                    if i == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(
                LinearGradient(
                    colors: [Color("Graph Line 1"), Color("Graph Line 2")],
                    startPoint: .leading, endPoint: .trailing
                ),
                lineWidth: 2.7
            )
        }
    }
}



// Tooltip Bubble View
struct TooltipBubble: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.caption2.bold())
            .padding(.vertical, 5).padding(.horizontal, 11)
            .background(
                Capsule()
                    .fill(Color("Card").opacity(0.98))
                    .shadow(color: .black.opacity(0.13), radius: 3, y: 2)
            )
            .foregroundColor(.cyan)
            .shadow(radius: 3)
    }
}

// MARK: - 8: Alerts/Warnings Pills
struct WeatherAlertBadge: View {
    let alert: WeatherAlert
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: alert.type.icon)
                .font(.system(size: 14, weight: .bold))
            Text(alert.title)
                .font(.subheadline.bold())
        }
        .padding(.horizontal, 13).padding(.vertical, 7)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color("Card").opacity(0.98))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(alert.type.color.opacity(0.19), lineWidth: 1)
        )
        .foregroundColor(alert.type.color)
        .shadow(color: alert.type.color.opacity(0.13), radius: 5, y: 2)
    }
}
struct WeatherAlert: Identifiable {
    let id = UUID()
    enum AlertType { case severe, airQuality
        var icon: String {
            switch self {
            case .severe: return "exclamationmark.triangle.fill"
            case .airQuality: return "aqi.low"
            }
        }
        var color: Color {
            switch self {
            case .severe: return .orange
            case .airQuality: return .mint
            }
        }
    }
    let type: AlertType
    let title: String
    let detail: String
}

// MARK: - 11: Share Sheet Helper
struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}

struct ScrollableForecastGraph: View {
    let forecast: [ForecastDayModel]
    @Binding var selectedDay: Int

    let dayWidth: CGFloat = 64
    let graphHeight: CGFloat = 100
    let iconSectionHeight: CGFloat = 78

    var body: some View {
        let totalWidth = CGFloat(forecast.count) * dayWidth

        ScrollView(.horizontal, showsIndicators: false) {
            ZStack(alignment: .topLeading) {
                // --- ICON, HIGH, LOW for each day ---
                HStack(alignment: .top, spacing: 0) {
                    ForEach(forecast.indices, id: \.self) { i in
                        VStack(spacing: 3) {
                            // HIGH
                            Text("\(Int(forecast[i].high.rounded()))°")
                                .font(.system(size: selectedDay == i ? 20 : 15, weight: .bold, design: .rounded))
                                .foregroundColor(selectedDay == i ? Color("Graph Line 1") : Color("Graph Line 1").opacity(0.68))
                                .shadow(color: selectedDay == i ? Color("Graph Line 1").opacity(0.16) : .clear, radius: 3, y: 1)

                            // ICON
                            Image(systemName: forecast[i].icon)
                                .font(.system(size: selectedDay == i ? 34 : 25, weight: .semibold))
                                .foregroundStyle(
                                    selectedDay == i ?
                                        LinearGradient(
                                            colors: [Color("Graph Line 1"), Color("Graph Line 2")],
                                            startPoint: .topLeading, endPoint: .bottomTrailing
                                        ) :
                                        LinearGradient(
                                            colors: [Color("Graph Line 1").opacity(0.48), Color("Graph Line 2").opacity(0.33)],
                                            startPoint: .top, endPoint: .bottom
                                        )
                                )
                                .opacity(selectedDay == i ? 1.0 : 0.72)
                                .scaleEffect(selectedDay == i ? 1.1 : 1)
                                .shadow(color: selectedDay == i ? Color("Graph Line 1").opacity(0.17) : .clear, radius: 6, y: 2)
                                .padding(.vertical, 1)

                            // LOW
                            Text("\(Int(forecast[i].low.rounded()))°")
                                .font(.system(size: selectedDay == i ? 16 : 13, weight: .medium, design: .rounded))
                                .foregroundColor(selectedDay == i ? Color("Graph Line 2") : Color("Graph Line 2").opacity(0.57))
                                .shadow(color: selectedDay == i ? Color("Graph Line 2").opacity(0.13) : .clear, radius: 3, y: 1)
                        }
                        .frame(width: dayWidth, height: iconSectionHeight)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.spring(response: 0.44, dampingFraction: 0.82)) {
                                selectedDay = i
                            }
                        }
                    }
                }
                // --- Graph Line & Dots Overlay ---
                GraphLinesAndDots(
                    forecast: forecast,
                    selectedDay: $selectedDay,
                    dayWidth: dayWidth,
                    graphHeight: graphHeight
                )
                .frame(width: totalWidth, height: graphHeight)
                .offset(y: iconSectionHeight - 12)
            }
            .frame(width: totalWidth, height: iconSectionHeight + graphHeight)
        }
        .frame(height: iconSectionHeight + graphHeight)
    }
}

struct GraphLinesAndDots: View {
    let forecast: [ForecastDayModel]
    @Binding var selectedDay: Int
    let dayWidth: CGFloat
    let graphHeight: CGFloat

    var body: some View {
        let minTemp = forecast.map { $0.low }.min() ?? 0
        let maxTemp = forecast.map { $0.high }.max() ?? 1
        let yRange = max(maxTemp - minTemp, 1)

        ZStack {
            // --- Graph Line ---
            Path { path in
                for i in forecast.indices {
                    let x = CGFloat(i) * dayWidth + dayWidth/2
                    let y = graphHeight - ((CGFloat(forecast[i].high - minTemp) / CGFloat(yRange)) * graphHeight)
                    if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                    else { path.addLine(to: CGPoint(x: x, y: y)) }
                }
            }
            .stroke(
                LinearGradient(
                    colors: [Color("Graph Line 1"), Color("Graph Line 2")],
                    startPoint: .leading, endPoint: .trailing
                ),
                lineWidth: 3
            )

            // --- Dots ---
            ForEach(forecast.indices, id: \.self) { i in
                let x = CGFloat(i) * dayWidth + dayWidth/2
                let y = graphHeight - ((CGFloat(forecast[i].high - minTemp) / CGFloat(yRange)) * graphHeight)
                Circle()
                    .fill(selectedDay == i ? Color("Graph Line 1") : Color.white.opacity(0.16))
                    .frame(width: selectedDay == i ? 17 : 11, height: selectedDay == i ? 17 : 11)
                    .shadow(color: selectedDay == i ? Color("Graph Line 1").opacity(0.18) : .clear, radius: 7, y: 2)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(selectedDay == i ? 0.32 : 0.07), lineWidth: selectedDay == i ? 2 : 0.5)
                    )
                    .position(x: x, y: y)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.42, dampingFraction: 0.8)) {
                            selectedDay = i
                        }
                        Haptics.lightImpact()
                    }
            }
        }
    }
}



#Preview {
    ForecastView()
}
