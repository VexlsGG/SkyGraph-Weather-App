import SwiftUI

struct SunProgressCard: View {
    let sunrise: Date
    let sunset: Date
    let now: Date

    @State private var showInfo = false
    @State private var isPressed = false

    var sunColor: Color { Color("Graph Line 1") }
    var arcColor: Color { Color("Graph Line 2") }
    
    var progress: Double {
        guard now >= sunrise, now <= sunset else { return now < sunrise ? 0 : 1 }
        let total = sunset.timeIntervalSince(sunrise)
        let elapsed = now.timeIntervalSince(sunrise)
        return min(max(elapsed / total, 0), 1)
    }
    var nextEventText: String {
        if now < sunrise {
            let mins = Int(sunrise.timeIntervalSince(now) / 60)
            return "Sunrise in \(mins / 60)h \(mins % 60)m"
        } else if now < sunset {
            let mins = Int(sunset.timeIntervalSince(now) / 60)
            return "Sunset in \(mins / 60)h \(mins % 60)m"
        } else {
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: sunrise)!
            let mins = Int(tomorrow.timeIntervalSince(now) / 60)
            return "Sunrise in \(mins / 60)h \(mins % 60)m"
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            sunColor.opacity(0.11),
                            Color("Card").opacity(0.92)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .background(.ultraThinMaterial)
                .shadow(color: sunColor.opacity(0.10), radius: 8, y: 2)
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "sunrise.fill")
                        .font(.title2)
                        .foregroundColor(sunColor.opacity(0.85))
                    Spacer()
                    Text("Day Progress")
                        .font(.caption.weight(.bold))
                        .foregroundColor(sunColor)
                    Spacer()
                    Image(systemName: "sunset.fill")
                        .font(.title2)
                        .foregroundColor(arcColor.opacity(0.8))
                }
                .padding(.horizontal, 8)
                ZStack {
                    SunPathArc()
                        .stroke(arcColor.opacity(0.18), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .frame(width: 105, height: 60)
                    SunPathArc()
                        .trim(from: 0, to: progress)
                        .stroke(sunColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .frame(width: 105, height: 60)
                        .animation(.easeInOut(duration: 0.8), value: progress)
                    GeometryReader { geo in
                        let arcWidth: CGFloat = geo.size.width
                        let arcHeight: CGFloat = geo.size.height
                        let angle = .pi * progress
                        let radius = arcWidth / 2
                        let x = cos(angle - .pi) * (radius - 5) + arcWidth / 2
                        let y = sin(angle - .pi) * (arcHeight - 10) + arcHeight
                        Image(systemName: "sun.max.fill")
                            .font(.system(size: 28))
                            .foregroundColor(sunColor)
                            .shadow(color: sunColor.opacity(0.28), radius: 4, y: 2)
                            .position(x: x, y: y)
                            .animation(.easeInOut(duration: 0.8), value: progress)
                    }
                    .frame(width: 105, height: 60)
                }
                .frame(width: 110, height: 66)
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(arcColor.opacity(0.12))
                        .frame(height: 8)
                    Capsule()
                        .fill(LinearGradient(
                            colors: [sunColor, arcColor],
                            startPoint: .leading, endPoint: .trailing
                        ))
                        .frame(width: CGFloat(progress) * 106, height: 8)
                        .animation(.easeInOut(duration: 0.7), value: progress)
                }
                .frame(width: 106)
                Text(nextEventText)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(sunColor)
                    .padding(.top, 4)
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Sunrise")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(format(sunrise))
                            .font(.callout.weight(.bold))
                            .foregroundColor(sunColor)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 0) {
                        Text("Sunset")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(format(sunset))
                            .font(.callout.weight(.bold))
                            .foregroundColor(arcColor)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 4)
            }
            .padding(.top, 10)
            .padding(.bottom, 10)
            .padding(.horizontal, 8)
        }
        .frame(maxWidth: .infinity, minHeight: 195)
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(sunColor.opacity(0.12), lineWidth: 1.6)
        )
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .scaleEffect(isPressed ? 0.96 : 1)
        .onTapGesture {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.45)) { isPressed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                withAnimation(.spring()) { isPressed = false }
                showInfo = true
            }
        }
        .sheet(isPresented: $showInfo) {
            SunProgressInfoSheet(
                sunrise: sunrise,
                sunset: sunset
            )
        }
    }
    func format(_ date: Date) -> String {
        let f = DateFormatter()
        f.timeStyle = .short
        return f.string(from: date)
    }
}

struct SunPathArc: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = rect.width / 2
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.maxY),
            radius: radius,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )
        return path
    }
}

struct SunProgressInfoSheet: View {
    let sunrise: Date
    let sunset: Date

    var body: some View {
        VStack(spacing: 22) {
            Capsule()
                .fill(Color.gray.opacity(0.24))
                .frame(width: 44, height: 5)
                .padding(.top, 8)
            Text("Daylight & Golden Hour")
                .font(.title2.bold())
                .padding(.top, 8)
            HStack {
                VStack(alignment: .leading) {
                    Text("Sunrise").font(.headline).foregroundColor(.secondary)
                    Text(formatted(sunrise)).font(.title2.bold())
                    Text("Golden hour is the hour after sunrise. The soft light is perfect for photos and morning activities.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Sunset").font(.headline).foregroundColor(.secondary)
                    Text(formatted(sunset)).font(.title2.bold())
                    Text("Golden hour is the hour before sunset. Enjoy warm light and great views.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }
            }
            .padding(.horizontal, 8)
            Spacer()
        }
        .padding()
        .presentationDetents([.medium, .large])
    }

    func formatted(_ date: Date) -> String {
        let f = DateFormatter()
        f.timeStyle = .short
        return f.string(from: date)
    }
}

#Preview {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    let sunrise = formatter.date(from: "2023-07-01 06:15")!
    let sunset = formatter.date(from: "2023-07-01 20:45")!
    let now = formatter.date(from: "2023-07-01 14:34")!
    return SunProgressCard(sunrise: sunrise, sunset: sunset, now: now)
        .padding()
        .background(Color("Background"))
}
