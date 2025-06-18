import SwiftUI

struct LocationWeatherCard: View {
    let location: LocationModel
    let isActive: Bool
    var isUserLocation: Bool = false
    var alertTitle: String? = nil
    var trend: WeatherTrend = .neutral
    var animateAlert: Bool = false
    var expand: Bool = false
    var cardStyle: CardStyle = .glass
    var onExpand: () -> Void = {}
    var importantText: String = ""

    enum CardStyle: String, CaseIterable, Codable, Equatable {
        case glass, neon, minimal
    }
    enum WeatherTrend: String, CaseIterable, Codable, Equatable {
        case hot, cold, up, down, neutral
    }
    
    @State private var animateBadge = false
    @State private var animateCard = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Card background and overlays (same as your latest)
            Group {
                if cardStyle == .glass {
                    GlassBackground(cornerRadius: 28)
                } else if cardStyle == .neon {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(
                            LinearGradient(colors: [Color("Graph Line 1").opacity(0.55), Color("Graph Line 2").opacity(0.33)], startPoint: .top, endPoint: .bottom)
                        )
                        .blur(radius: 2)
                } else {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color("Card"))
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .strokeBorder(
                        LinearGradient(
                            colors: isActive
                                ? [Color("Graph Line 1"), Color("Graph Line 2")]
                                : [Color("Card").opacity(0.32), Color("Card").opacity(0.32)],
                            startPoint: .top, endPoint: .bottom
                        ),
                        lineWidth: isActive ? 3 : 1.2
                    )
                    .shadow(color: isActive ? Color("Graph Line 1").opacity(0.18) : .clear, radius: isActive ? 10 : 0, x: 0, y: 3)
            )
            .overlay(
                Group {
                    if isActive {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [Color("Graph Line 1"), Color("Graph Line 2")],
                                    startPoint: .top, endPoint: .bottom
                                )
                            )
                            .frame(width: 7)
                            .padding(.vertical, 13)
                            .padding(.leading, 2)
                            .opacity(animateCard ? 0.8 : 1)
                            .scaleEffect(animateCard ? 1.08 : 1)
                            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animateCard)
                    }
                },
                alignment: .leading
            )
            .onAppear {
                animateCard = true
            }

            GeometryReader { _ in Color.clear }

            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(spacing: 7) {
                            Text(location.city)
                                .font(.system(size: 23, weight: .bold, design: .rounded))
                                .foregroundColor(Color("Text Primary"))
                            if isUserLocation {
                                Image(systemName: "location.north.circle.fill")
                                    .foregroundColor(Color("Graph Line 1"))
                                    .font(.system(size: 18, weight: .bold))
                            }
                        }
                        Text(location.condition)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color("Text Secondary"))
                            .padding(.bottom, alertTitle == nil ? 5 : 0)
                        if let alertTitle = alertTitle {
                            HStack(spacing: 7) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 15, weight: .bold))
                                    .scaleEffect(animateBadge ? 1.15 : 1)
                                    .rotationEffect(.degrees(animateBadge ? 8 : -8))
                                    .animation(animateAlert ? .easeInOut(duration: 0.2).repeatForever(autoreverses: true) : .default, value: animateBadge)
                                Text(alertTitle)
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.yellow)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            .onAppear { animateBadge = true }
                        }
                        HStack(spacing: 6) {
                            MiniWeatherGraph(
                                data: location.hourlyTemps,
                                lineColor: trend == .hot ? .red : (trend == .cold ? .blue : Color("Graph Line 1"))
                            )
                            .frame(height: 22)
                            .padding(.top, 5)
                            .padding(.trailing, 0)
                            .opacity(0.96)
                            if trend == .hot {
                                Image(systemName: "arrow.up").foregroundColor(.red)
                            } else if trend == .cold {
                                Image(systemName: "arrow.down").foregroundColor(.blue)
                            }
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 0) {
                        Text("\(location.temp)°")
                            .font(.system(size: 40, weight: .heavy, design: .rounded))
                            .foregroundColor(isActive ? Color("Graph Line 1") : Color("Text Primary"))
                            .shadow(color: isActive ? Color("Graph Line 1").opacity(0.38) : Color("Background").opacity(0.09), radius: 12, x: 0, y: 1)
                            .animation(.spring(), value: isActive)
                        Image(systemName: location.weatherIconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color("Graph Line 2"))
                            .shadow(color: Color("Graph Line 2").opacity(0.33), radius: 9, x: 0, y: 3)
                            .scaleEffect(isActive ? 1.1 : 1)
                            .opacity(isActive ? 1 : 0.85)
                            .animation(.spring(response: 0.32, dampingFraction: 0.75), value: isActive)
                    }
                    if alertTitle != nil {
                        VStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 22, weight: .heavy))
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.black.opacity(0.18))
                                        .frame(width: 26, height: 26)
                                )
                                .scaleEffect(animateBadge ? 1.07 : 1)
                                .offset(y: animateBadge ? -2 : 0)
                                .animation(animateAlert ? .easeInOut(duration: 0.3).repeatForever(autoreverses: true) : .default, value: animateBadge)
                        }
                        .padding(.top, -7)
                        .padding(.trailing, -2)
                    }
                }
                // Card expansion for extra details
                if expand {
                    VStack(alignment: .leading, spacing: 8) {
                        Divider()
                        Text(importantText)
                            .font(.footnote)
                            .foregroundColor(Color("Text Secondary"))
                    }
                    .transition(.opacity.combined(with: .slide))
                }
            }
            .padding(.vertical, expand ? 34 : 28)
            .padding(.horizontal, 30)
        }
        .padding(.horizontal, 2)
        .padding(.vertical, 7)
        .scaleEffect(isActive ? 1.04 : 1)
        .animation(.spring(response: 0.38, dampingFraction: 0.75), value: isActive)
        .onTapGesture {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            onExpand()
        }
    }
}

#Preview {
    VStack(spacing: 28) {
        LocationWeatherCard(
            location: LocationModel(
                city: "Cupertino",
                temp: 68,
                condition: "Partly Cloudy",
                weatherIconName: "cloud.sun.fill",
                hourlyTemps: [68, 67, 66, 65, 66, 69, 72, 75]
            ),
            isActive: true,
            isUserLocation: true,
            alertTitle: "Tornado Warning",
            trend: .hot,
            animateAlert: true,
            expand: true,
            cardStyle: .glass,
            importantText: "Severe Thunderstorm Risk: High"
        )
        LocationWeatherCard(
            location: LocationModel(
                city: "Phoenix",
                temp: 106,
                condition: "Hot",
                weatherIconName: "sun.max.trianglebadge.exclamationmark.fill",
                hourlyTemps: [104, 106, 107, 108, 110, 108, 105, 103]
            ),
            isActive: false,
            isUserLocation: false,
            alertTitle: "Excessive Heat Warning",
            trend: .hot,
            animateAlert: true,
            expand: true,
            cardStyle: .neon,
            importantText: "Heat Advisory: Stay Hydrated"
        )
    }
    .background(Color("Background"))
    .padding()
}
