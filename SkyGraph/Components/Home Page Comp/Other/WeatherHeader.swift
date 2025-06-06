import SwiftUI

struct WeatherHeader: View {
    let city = "Cupertino"
    let temp = 65
    let feelsLike = 63
    let weatherIcon = "cloud.fill"
    let weatherDescription = "Cloudy"
    let nextEvent = "Rain in hr."
    let aiSummary = "Cooler than yesterday, but muggy. Isolated thunderstorms around the area."
    let sunrise = "5:58 am"
    let sunset = "9:06 pm"
    let dayProgress: CGFloat = 0.45
    let confidence = "Confidence"
    let userName = "Username"
    let tempTrend = [65, 66, 67, 66, 66, 64, 63, 62]

    @State private var pressedPill: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack {
                HStack {
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    Spacer()
                    Button(action: { }) {
                        Image(systemName: "location.circle.fill")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Color("Text Secondary"))
                    }
                }
                HStack(spacing: 0) {
                    Spacer()
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color("Graph Line 1"),
                            Color("Graph Line 2")
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .mask(
                        Text("SkyGraph")
                            .font(.system(size: 38, weight: .heavy, design: .rounded))
                    )
                    Spacer()
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, -50)
            .padding(.bottom, 30)

            Text("Good afternoon, \(userName)")
                .font(.footnote)
                .foregroundColor(Color("Text Secondary"))
                .padding(.bottom, 2)

            Text(city)
                .font(.system(size: 28, weight: .heavy, design: .rounded))
                .foregroundColor(Color("Text Primary"))
                .padding(.bottom, -2)

            HStack(spacing: 10) {
                PillButton(
                    label: {
                        HStack(spacing: 6) {
                            Image(systemName: "cloud.rain.fill")
                                .font(.caption)
                            Text(nextEvent)
                                .fontWeight(.medium)
                        }
                    },
                    background: LinearGradient(
                        colors: [Color("Graph Line 2"), Color("Graph Line 1")],
                        startPoint: .leading, endPoint: .trailing),
                    isPressed: pressedPill == "event"
                ) { pressedPill = $0 ? "event" : nil }

                PillButton(
                    label: {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.caption)
                            Text(confidence)
                                .font(.caption)
                        }
                    },
                    background: Color.green.opacity(0.15),
                    foreground: .green,
                    isPressed: pressedPill == "confidence"
                ) { pressedPill = $0 ? "confidence" : nil }
                Spacer()
            }

            HStack(alignment: .center, spacing: 14) {
                Text("\(temp)°")
                    .font(.system(size: 62, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color("Graph Line 1"), Color("Graph Line 2")],
                            startPoint: .top, endPoint: .bottom
                        )
                    )
                    .shadow(color: Color("Graph Line 1").opacity(0.13), radius: 8, x: 0, y: 4)
                Image(systemName: weatherIcon)
                    .font(.system(size: 44, weight: .bold))
                    .foregroundColor(Color("Graph Line 2"))
                    .shadow(color: Color("Graph Line 2").opacity(0.22), radius: 8, x: 0, y: 3)
                    .offset(x: -8)
                PillButton(
                    label: {
                        Text("Feels like \(feelsLike)°")
                            .font(.callout)
                    },
                    background: Color("Text Secondary").opacity(0.19),
                    isPressed: pressedPill == "feelslike"
                ) { pressedPill = $0 ? "feelslike" : nil }
            }
            .padding(.vertical, 2)

            SparklineView(values: tempTrend)
                .frame(height: 14)
                .padding(.vertical, 2)

            Text(weatherDescription)
                .font(.title3.bold())
                .foregroundColor(Color("Text Primary"))

            Text(aiSummary)
                .font(.callout)
                .foregroundColor(Color("Text Secondary"))
                .italic()

            HStack(spacing: 8) {
                Image(systemName: "sunrise.fill")
                    .foregroundColor(Color("Graph Line 1"))
                Text(sunrise)
                    .font(.footnote)
                    .foregroundColor(Color("Text Secondary"))
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color("Card").opacity(0.25))
                            .frame(height: 8)
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Color("Graph Line 1"), Color("Graph Line 2")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * dayProgress, height: 8)
                    }
                }
                .frame(width: 110, height: 12)
                Text(sunset)
                    .font(.footnote)
                    .foregroundColor(Color("Text Secondary"))
                Image(systemName: "sunset.fill")
                    .foregroundColor(Color("Graph Line 2"))
            }
            .frame(height: 16)
            .padding(.top, 2)
        }
        .padding([.horizontal, .top])
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct PillButton<Label: View>: View {
    let label: () -> Label
    var background: AnyView
    var foreground: Color = .white
    var isPressed: Bool
    var onPress: (Bool) -> Void

    init(label: @escaping () -> Label, background: LinearGradient, foreground: Color = .white, isPressed: Bool, onPress: @escaping (Bool) -> Void) {
        self.label = label
        self.background = AnyView(background)
        self.foreground = foreground
        self.isPressed = isPressed
        self.onPress = onPress
    }
    init(label: @escaping () -> Label, background: Color, foreground: Color = .white, isPressed: Bool, onPress: @escaping (Bool) -> Void) {
        self.label = label
        self.background = AnyView(background)
        self.foreground = foreground
        self.isPressed = isPressed
        self.onPress = onPress
    }

    var body: some View {
        label()
            .padding(.horizontal, 14).padding(.vertical, 6)
            .foregroundColor(foreground)
            .background(background)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.10), radius: 2, x: 0, y: 2)
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .animation(.easeOut(duration: 0.15), value: isPressed)
            .onLongPressGesture(minimumDuration: 0.07, maximumDistance: 16, pressing: onPress, perform: {})
    }
}

struct SparklineView: View {
    let values: [Int]
    var body: some View {
        GeometryReader { geo in
            let maxValue = values.max() ?? 1
            let minValue = values.min() ?? 0
            let stepX = geo.size.width / CGFloat(values.count - 1)
            let points = values.enumerated().map { index, value in
                CGPoint(
                    x: stepX * CGFloat(index),
                    y: geo.size.height - (CGFloat(value - minValue) / CGFloat(maxValue - minValue)) * geo.size.height
                )
            }
            Path { path in
                if let first = points.first {
                    path.move(to: first)
                    for point in points.dropFirst() {
                        path.addLine(to: point)
                    }
                }
            }
            .stroke(
                LinearGradient(
                    colors: [Color("Graph Line 1"), Color("Graph Line 2")],
                    startPoint: .leading, endPoint: .trailing
                ),
                style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round)
            )
            .shadow(color: Color("Graph Line 1").opacity(0.16), radius: 4)
        }
    }
}

#Preview {
    WeatherHeader()
        .preferredColorScheme(.dark)
}
