import SwiftUI

struct ForecastDay: Identifiable, Equatable {
    let id = UUID()
    let day: String
    let icon: String
    let high: String
    let low: String
    let rain: String?
    let hourly: [Int]
    let wind: String
    let humidity: String
}

struct ForecastRow: View {
    let days: [ForecastDay] = [
        .init(day: "Tue", icon: "cloud.rain.fill", high: "68°", low: "59°", rain: "30%", hourly: [61, 62, 65, 66, 68, 67, 63, 62], wind: "7 mph", humidity: "74%"),
        .init(day: "Wed", icon: "cloud.sun.fill", high: "71°", low: "60°", rain: nil, hourly: [60, 62, 65, 69, 71, 69, 65, 63], wind: "5 mph", humidity: "64%"),
        .init(day: "Thu", icon: "cloud.sun.fill", high: "75°", low: "63°", rain: "10%", hourly: [63, 65, 67, 71, 75, 73, 68, 64], wind: "6 mph", humidity: "59%"),
        .init(day: "Fri", icon: "sun.max.fill", high: "84°", low: "66°", rain: nil, hourly: [66, 70, 74, 80, 84, 82, 75, 70], wind: "8 mph", humidity: "48%"),
        .init(day: "Sat", icon: "sun.max.fill", high: "83°", low: "65°", rain: nil, hourly: [65, 69, 73, 78, 83, 81, 76, 72], wind: "7 mph", humidity: "51%"),
        .init(day: "Sun", icon: "sun.max.fill", high: "81°", low: "64°", rain: nil, hourly: [64, 67, 71, 76, 81, 79, 74, 70], wind: "6 mph", humidity: "53%"),
        .init(day: "Mon", icon: "cloud.bolt.rain.fill", high: "70°", low: "59°", rain: "50%", hourly: [59, 60, 63, 65, 70, 68, 63, 60], wind: "12 mph", humidity: "81%"),
        .init(day: "Tue", icon: "cloud.rain.fill", high: "67°", low: "57°", rain: "20%", hourly: [57, 59, 62, 65, 67, 65, 61, 58], wind: "9 mph", humidity: "70%"),
        .init(day: "Wed", icon: "cloud.sun.fill", high: "69°", low: "58°", rain: nil, hourly: [58, 60, 63, 66, 69, 67, 63, 60], wind: "7 mph", humidity: "66%"),
        .init(day: "Thu", icon: "sun.max.fill", high: "76°", low: "62°", rain: nil, hourly: [62, 65, 69, 73, 76, 74, 70, 67], wind: "6 mph", humidity: "57%")
    ]

    @State private var expandedDay: ForecastDay? = nil
    @Namespace private var cardAnim

    var body: some View {
        ZStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(days) { day in
                        Button {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                expandedDay = day
                            }
                        } label: {
                            VStack(spacing: 10) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color("Graph Line 1").opacity(0.27),
                                                    Color("Graph Line 2").opacity(0.15)
                                                ],
                                                startPoint: .topLeading, endPoint: .bottomTrailing
                                            )
                                        )
                                        .blur(radius: 7)
                                        .frame(width: 46, height: 46)
                                    Image(systemName: day.icon)
                                        .font(.system(size: 30, weight: .bold))
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: [
                                                    Color("Graph Line 1"),
                                                    Color("Graph Line 2")
                                                ],
                                                startPoint: .topLeading, endPoint: .bottomTrailing
                                            )
                                        )
                                        .shadow(color: Color("Graph Line 1").opacity(0.19), radius: 7, y: 3)
                                }
                                Text(day.day)
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(Color("Text Primary"))
                                    .opacity(0.96)
                                    .shadow(color: .black.opacity(0.08), radius: 1, y: 1)
                                HStack(spacing: 6) {
                                    Text(day.high)
                                        .font(.system(size: 15, weight: .bold, design: .rounded))
                                        .foregroundColor(Color("Graph Line 1"))
                                    Text(day.low)
                                        .font(.system(size: 15, weight: .bold, design: .rounded))
                                        .foregroundColor(Color("Graph Line 2"))
                                }
                                .padding(.top, 2)
                                if let rain = day.rain {
                                    Text(rain)
                                        .font(.system(size: 13, weight: .medium, design: .rounded))
                                        .foregroundColor(Color("Graph Line 1"))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(
                                            Capsule()
                                                .fill(Color("Graph Line 1").opacity(0.15))
                                                .blur(radius: 0.2)
                                        )
                                        .overlay(
                                            Capsule()
                                                .stroke(Color("Graph Line 1").opacity(0.20), lineWidth: 1)
                                        )
                                        .shadow(color: Color("Graph Line 1").opacity(0.09), radius: 2, y: 1)
                                }
                            }
                            .frame(width: 74)
                            .padding(.vertical, 10)
                            .background(
                                Color.white.opacity(0.03)
                                    .cornerRadius(16)
                                    .matchedGeometryEffect(id: day.id, in: cardAnim)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 10)
            }
            .background(
                ZStack {
                    GlassBackground(cornerRadius: 28)
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    .white.opacity(0.09),
                                    Color("Card").opacity(0.19)
                                ]),
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.22),
                                    Color("Graph Line 1").opacity(0.11),
                                    .clear
                                ],
                                startPoint: .top, endPoint: .bottom
                            ),
                            lineWidth: 1.2
                        )
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .shadow(color: Color("Graph Line 1").opacity(0.10), radius: 16, x: 0, y: 6)
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(Color.white.opacity(0.04), lineWidth: 0.8)
            )
            .padding(.horizontal, 6)

            if let expandedDay = expandedDay {
                Color.black.opacity(0.24)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            self.expandedDay = nil
                        }
                    }

                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        VStack(spacing: 16) {
                            HStack(spacing: 14) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color("Graph Line 1").opacity(0.27),
                                                    Color("Graph Line 2").opacity(0.15)
                                                ],
                                                startPoint: .topLeading, endPoint: .bottomTrailing
                                            )
                                        )
                                        .blur(radius: 8)
                                        .frame(width: 66, height: 66)
                                    Image(systemName: expandedDay.icon)
                                        .font(.system(size: 48, weight: .bold))
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: [
                                                    Color("Graph Line 1"),
                                                    Color("Graph Line 2")
                                                ],
                                                startPoint: .topLeading, endPoint: .bottomTrailing
                                            )
                                        )
                                        .shadow(color: Color("Graph Line 1").opacity(0.19), radius: 7, y: 3)
                                }
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(expandedDay.day)
                                        .font(.system(size: 22, weight: .bold, design: .rounded))
                                        .foregroundColor(Color("Text Primary"))
                                    HStack(spacing: 10) {
                                        HStack(spacing: 4) {
                                            Text(expandedDay.high)
                                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                                .foregroundColor(Color("Graph Line 1"))
                                            Text("H")
                                                .font(.caption).bold()
                                                .foregroundColor(Color("Graph Line 1"))
                                                .opacity(0.5)
                                        }
                                        HStack(spacing: 4) {
                                            Text(expandedDay.low)
                                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                                .foregroundColor(Color("Graph Line 2"))
                                            Text("L")
                                                .font(.caption).bold()
                                                .foregroundColor(Color("Graph Line 2"))
                                                .opacity(0.5)
                                        }
                                        if let rain = expandedDay.rain {
                                            HStack(spacing: 4) {
                                                Image(systemName: "cloud.rain.fill")
                                                    .font(.system(size: 16))
                                                    .foregroundColor(Color("Graph Line 1"))
                                                Text(rain)
                                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                                    .foregroundColor(Color("Graph Line 1"))
                                            }
                                        }
                                    }
                                }
                                Spacer()
                            }
                            .padding(.top, 4)
                            Divider().background(Color("Card").opacity(0.7))
                            HourlyGraph(temps: expandedDay.hourly)
                                .frame(height: 56)
                            HStack(spacing: 18) {
                                StatIcon(icon: "wind", label: expandedDay.wind)
                                StatIcon(icon: "humidity", label: expandedDay.humidity)
                            }
                        }
                        .padding(20)
                        .background(
                            GlassBackground(cornerRadius: 30)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .matchedGeometryEffect(id: expandedDay.id, in: cardAnim)
                        .padding(.horizontal, 16)
                    }
                    Button {
                        withAnimation(.easeInOut(duration: 0.23)) {
                            self.expandedDay = nil
                        }
                    } label: {
                        Text("Close")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.horizontal, 40)
                            .padding(.vertical, 12)
                            .background(
                                Capsule().fill(Color.white.opacity(0.18))
                            )
                    }
                }
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .scale(scale: 1.08)),
                    removal: .opacity
                ))
                .zIndex(10)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: expandedDay)
    }
}


struct HourlyGraph: View {
    let temps: [Int]

    var body: some View {
        GeometryReader { geo in
            let points = temps.enumerated().map { idx, temp in
                CGPoint(
                    x: geo.size.width * CGFloat(idx) / CGFloat(max(temps.count - 1, 1)),
                    y: geo.size.height - (geo.size.height * CGFloat(temp - (temps.min() ?? 0)) / CGFloat(max((temps.max() ?? 1) - (temps.min() ?? 0), 1)))
                )
            }
            Path { path in
                if points.count > 1 {
                    path.move(to: points.first!)
                    for pt in points.dropFirst() {
                        path.addLine(to: pt)
                    }
                }
            }
            .stroke(
                LinearGradient(
                    colors: [Color("Graph Line 1"), Color("Graph Line 2")],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                ),
                style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round)
            )
            ForEach(Array(points.enumerated()), id: \.offset) { i, pt in
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color("Graph Line 1"), Color("Graph Line 2")],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 9, height: 9)
                    .position(pt)
            }
        }
    }
}

struct StatIcon: View {
    let icon: String
    let label: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(LinearGradient(colors: [Color("Graph Line 1"), Color("Graph Line 2")], startPoint: .topLeading, endPoint: .bottomTrailing))
            Text(label)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(Color("Text Primary"))
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.09))
        )
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color("Background"), Color("Graph Line 2").opacity(0.32)],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        ForecastRow()
    }
}
