import SwiftUI

struct TemperatureGraphCard: View {
    let temps: [Double] = [
        65, 64, 63, 62, 61, 62, 63, 65, 68, 70, 72, 75,
        78, 81, 83, 85, 84, 82, 79, 75, 72, 70, 68, 66
    ]
    let hours: [String] = [
        "12a","1a","2a","3a","4a","5a","6a","7a","8a","9a","10a","11a",
        "12p","1p","2p","3p","4p","5p","6p","7p","8p","9p","10p","11p"
    ]
    let icons: [String] = [
        "cloud.moon.fill","cloud.moon.fill","cloud.moon.fill","cloud.moon","cloud.moon",
        "cloud.sun.fill","sun.max.fill","sun.max.fill","cloud.sun.fill","cloud.sun.fill",
        "cloud.sun.fill","cloud.sun.fill","sun.max.fill","cloud.sun.fill","cloud.fill",
        "cloud.rain.fill","cloud.rain.fill","cloud.sun.bolt.fill","cloud.sun.fill",
        "sun.max.fill","sun.max.fill","cloud.sun.fill","cloud.moon.fill","cloud.moon.fill"
    ]
    
    @State private var animLine: CGFloat = 0
    @State private var animIcons: [Bool] = Array(repeating: false, count: 24)
    @State private var animSpin: [Double] = Array(repeating: 0, count: 24)
    @State private var scrollOffset: CGFloat = 0
    @State private var scrollWidth: CGFloat = 1
    @State private var isFirstAppear = true
    
    private var recordHigh: Int? { temps.firstIndex(of: temps.max() ?? 0) }
    private var recordLow: Int? { temps.firstIndex(of: temps.min() ?? 0) }
    
    private func centerIndex(proxy: GeometryProxy) -> Int {
        let cardWidth = proxy.size.width
        let hourWidth: CGFloat = 54
        let scrollX = scrollOffset
        let center = scrollX + cardWidth / 2
        let i = Int((center - 40) / hourWidth)
        return min(max(i, 0), temps.count - 1)
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .background(
                    LinearGradient(
                        colors: [
                            Color("Card").opacity(0.98),
                            Color("Graph Line 1").opacity(0.13)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color("Graph Line 1").opacity(0.16), radius: 16, y: 4)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Temperature")
                        .font(.title3.bold())
                        .foregroundColor(Color("Graph Line 1"))
                    Spacer()
                    Image(systemName: "thermometer.sun.fill")
                        .foregroundColor(Color("Graph Line 1"))
                        .font(.title2)
                }
                .padding(.bottom, 2)
                
                GeometryReader { outerProxy in
                    ScrollViewReader { scrollProxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 0) {
                                TempGraphWithAnimatedIcons(
                                    temps: temps,
                                    hours: hours,
                                    icons: icons,
                                    animLine: animLine,
                                    animIcons: animIcons,
                                    animSpin: animSpin,
                                    scrollCenterIndex: centerIndex(proxy: outerProxy),
                                    recordHigh: recordHigh,
                                    recordLow: recordLow
                                )
                                .frame(width: CGFloat(temps.count) * 54 + 40, height: 170)
                            }
                            .background(
                                GeometryReader { scrollArea in
                                    Color.clear
                                        .onAppear {
                                            scrollWidth = scrollArea.size.width
                                        }
                                        .onChange(of: scrollArea.frame(in: .global).minX) { oldOffset, newOffset in
                                            scrollOffset = -newOffset
                                        }
                                }
                            )
                        }
                        .frame(height: 170)
                        .onAppear {
                            if isFirstAppear {
                                withAnimation(.easeOut(duration: 1.0)) { animLine = 1 }
                                for i in 0..<temps.count {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.12 * Double(i)) {
                                        withAnimation(.spring(response: 0.62, dampingFraction: 0.57)) {
                                            animIcons[i] = true
                                            animSpin[i] += 360
                                        }
                                    }
                                }
                                isFirstAppear = false
                            }
                        }
                    }
                }
                .frame(height: 170)
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 18)
        }
        .frame(height: 230)
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color("Graph Line 1").opacity(0.14), lineWidth: 1.6)
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.horizontal, 4)
    }
}


struct TempGraphWithAnimatedIcons: View {
    let temps: [Double]
    let hours: [String]
    let icons: [String]
    let animLine: CGFloat
    let animIcons: [Bool]
    let animSpin: [Double]
    let scrollCenterIndex: Int
    let recordHigh: Int?
    let recordLow: Int?
    
    private let edgePadding: CGFloat = 28
    private let verticalInset: CGFloat = 28

    private let rainIcons = ["cloud.rain.fill","cloud.sun.rain.fill","cloud.heavyrain.fill"]
    private let stormIcons = ["cloud.bolt.rain.fill","cloud.sun.bolt.fill"]

    var body: some View {
        GeometryReader { geo in
            let minTemp = temps.min() ?? 0
            let maxTemp = temps.max() ?? 1
            let yRange = max(maxTemp - minTemp, 1)
            let widthPerHour = (geo.size.width - edgePadding * 2) / CGFloat(temps.count - 1)
            let iconSize: CGFloat = 28

            ZStack {
                ForEach(0..<4) { i in
                    let y = verticalInset + (geo.size.height - verticalInset * 2) * CGFloat(i) / 3
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: geo.size.width, y: y))
                    }
                    .stroke(Color("Text Secondary").opacity(0.13), style: StrokeStyle(lineWidth: 1, dash: [2,2]))
                }
                TempSmoothGraphLineEdgePad(
                    temps: temps,
                    minTemp: minTemp,
                    yRange: yRange,
                    widthPerHour: widthPerHour,
                    edgePadding: edgePadding,
                    verticalInset: verticalInset
                )
                .trim(from: 0, to: animLine)
                .stroke(
                    LinearGradient(
                        colors: [Color("Graph Line 1"), Color("Graph Line 2")],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .shadow(color: Color("Graph Line 1").opacity(0.2), radius: 8, y: 0)
                
                TempSmoothGraphFillEdgePad(
                    temps: temps,
                    minTemp: minTemp,
                    yRange: yRange,
                    widthPerHour: widthPerHour,
                    edgePadding: edgePadding,
                    verticalInset: verticalInset
                )
                .fill(
                    LinearGradient(
                        colors: [
                            Color("Graph Line 1").opacity(0.12),
                            Color("Graph Line 2").opacity(0.07),
                            .clear
                        ],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                
                ForEach(temps.indices, id: \.self) { i in
                    let temp = temps[i]
                    let x = edgePadding + CGFloat(i) * widthPerHour
                    let y = verticalInset + (geo.size.height - verticalInset * 2)
                        - (CGFloat((temp - minTemp) / yRange) * (geo.size.height - verticalInset * 2))
                    let isCurrent = i == Calendar.current.component(.hour, from: Date()) % 24
                    let isCenter = i == scrollCenterIndex
                    let isRain = rainIcons.contains(icons[i])
                    let isStorm = stormIcons.contains(icons[i])
                    let isRecord = i == recordHigh || i == recordLow

                    VStack(spacing: 0) {
                        Text("\(Int(temp.rounded()))°")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(isCurrent || isCenter ? Color("Graph Line 1") : Color("Text Secondary"))
                            .shadow(color: isCurrent || isCenter ? Color("Graph Line 1").opacity(0.3) : .clear, radius: 2)
                            .opacity(animIcons[i] ? 1 : 0)
                            .offset(y: animIcons[i] ? 0 : 10)
                            .animation(.easeOut.delay(Double(i) * 0.05), value: animIcons[i])
                        ZStack {
                            if isRecord {
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                Color.yellow.opacity(0.8),
                                                Color("Graph Line 2").opacity(0.8)
                                            ],
                                            startPoint: .top, endPoint: .bottom
                                        ),
                                        lineWidth: 3.5
                                    )
                                    .frame(width: iconSize+16, height: iconSize+16)
                                    .blur(radius: 2)
                                    .opacity(animIcons[i] ? 0.5 : 0)
                                    .scaleEffect(animIcons[i] ? 1.12 : 0.8)
                                    .animation(.easeInOut(duration: 0.85).repeatForever(autoreverses: true), value: animIcons[i])
                            }
                            Circle()
                                .fill(Color("Background").opacity(0.68))
                                .frame(width: iconSize+8, height: iconSize+8)
                                .shadow(color: Color("Graph Line 1").opacity(0.10), radius: 3, y: 0)
                            Image(systemName: icons[i])
                                .font(.system(size: isCurrent || isCenter ? iconSize+4 : iconSize))
                                .foregroundColor(Color("Graph Line 1"))
                                .scaleEffect(animIcons[i] ? (isCurrent || isCenter ? 1.18 : 1.0) : 0.7)
                                .rotationEffect(.degrees(animSpin[i]))
                                .animation(.spring(response: 0.66, dampingFraction: 0.55).delay(Double(i) * 0.09), value: animIcons[i])
                                .animation(.easeOut(duration: 0.5), value: animSpin[i])
                            if isRain && animIcons[i] {
                                RainOverlay()
                                    .frame(width: iconSize+10, height: iconSize+10)
                            } else if isStorm && animIcons[i] {
                                ThunderOverlay()
                                    .frame(width: iconSize+12, height: iconSize+12)
                            }
                        }
                        .offset(y: 0)
                        Text(hours[i])
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                            .foregroundColor(isCurrent || isCenter ? Color("Graph Line 1") : Color("Text Secondary").opacity(0.85))
                            .scaleEffect(isCurrent || isCenter ? 1.13 : 1)
                            .opacity(animIcons[i] ? 1 : 0)
                            .offset(y: 2)
                            .animation(.easeOut.delay(Double(i) * 0.06), value: animIcons[i])
                    }
                    .position(x: x, y: y)
                }
            }
        }
    }
}

struct RainOverlay: View {
    @State private var dropY: CGFloat = -10
    var body: some View {
        ZStack {
            ForEach(0..<5) { i in
                Capsule()
                    .fill(Color("Graph Line 1").opacity(0.7))
                    .frame(width: 2, height: 10)
                    .offset(x: CGFloat(i) * 4 - 8, y: dropY)
                    .animation(.linear(duration: 0.6).repeatForever(autoreverses: false).delay(Double(i) * 0.08), value: dropY)
            }
        }
        .onAppear { dropY = 10 }
    }
}

struct ThunderOverlay: View {
    @State private var flash: Bool = false
    var body: some View {
        ZStack {
            Image(systemName: "bolt.fill")
                .font(.system(size: 16))
                .foregroundColor(flash ? .yellow : .gray)
                .shadow(color: .yellow.opacity(flash ? 0.9 : 0), radius: 8)
                .animation(.easeInOut(duration: 0.18).repeatForever(autoreverses: true), value: flash)
        }
        .onAppear { flash.toggle() }
    }
}


struct TempSmoothGraphLineEdgePad: Shape {
    let temps: [Double]
    let minTemp: Double
    let yRange: Double
    let widthPerHour: CGFloat
    let edgePadding: CGFloat
    let verticalInset: CGFloat

    func path(in rect: CGRect) -> Path {
        let points = temps.enumerated().map { (i, temp) in
            CGPoint(
                x: edgePadding + CGFloat(i) * widthPerHour,
                y: verticalInset + (rect.height - verticalInset * 2)
                    - (CGFloat((temp - minTemp) / yRange) * (rect.height - verticalInset * 2))
            )
        }
        return Path.smoothLine(points: points)
    }
}

struct TempSmoothGraphFillEdgePad: Shape {
    let temps: [Double]
    let minTemp: Double
    let yRange: Double
    let widthPerHour: CGFloat
    let edgePadding: CGFloat
    let verticalInset: CGFloat

    func path(in rect: CGRect) -> Path {
        let points = temps.enumerated().map { (i, temp) in
            CGPoint(
                x: edgePadding + CGFloat(i) * widthPerHour,
                y: verticalInset + (rect.height - verticalInset * 2)
                    - (CGFloat((temp - minTemp) / yRange) * (rect.height - verticalInset * 2))
            )
        }
        var path = Path.smoothLine(points: points)
        if let last = points.last, let first = points.first {
            path.addLine(to: CGPoint(x: last.x, y: rect.height - verticalInset))
            path.addLine(to: CGPoint(x: first.x, y: rect.height - verticalInset))
            path.closeSubpath()
        }
        return path
    }
}

extension Path {
    static func smoothLine(points: [CGPoint]) -> Path {
        var path = Path()
        guard points.count > 1 else { return path }
        path.move(to: points[0])
        for i in 1..<points.count {
            let prev = points[i-1]
            let curr = points[i]
            let mid = CGPoint(x: (prev.x + curr.x) / 2, y: (prev.y + curr.y) / 2)
            path.addQuadCurve(to: mid, control: prev)
            path.addQuadCurve(to: curr, control: curr)
        }
        return path
    }
}

#Preview {
    TemperatureGraphCard()
        .padding()
        .background(Color("Background"))
}
