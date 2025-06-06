import SwiftUI

struct WindMiniCard: View {
    let speed: Double
    let directionDegrees: Double
    let directionLabel: String
    let gusts: Double?

    var mainColor: Color { Color("Graph Line 1") }
    var secondaryColor: Color { Color("Graph Line 2") }

    @State private var showInfo = false
    @State private var isPressed = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            mainColor.opacity(0.15),
                            Color("Card").opacity(0.92)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .background(.ultraThinMaterial)
                .shadow(color: mainColor.opacity(0.10), radius: 8, y: 2)

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Text(windStatus)
                        .font(.caption2.weight(.semibold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(mainColor.opacity(0.13))
                        .foregroundColor(mainColor)
                        .clipShape(Capsule())
                }
                .padding(.top, 4)
                .padding(.bottom, 2)

                ZStack {
                    Circle()
                        .strokeBorder(
                            AngularGradient(
                                gradient: Gradient(colors: [
                                    mainColor.opacity(0.32),
                                    secondaryColor.opacity(0.23),
                                    mainColor.opacity(0.36)
                                ]),
                                center: .center
                            ),
                            lineWidth: 8
                        )
                        .blur(radius: 0.4)
                        .frame(width: 66, height: 66)

                    ForEach(0..<36) { tick in
                        Rectangle()
                            .fill(mainColor.opacity(tick % 3 == 0 ? 0.16 : 0.09))
                            .frame(width: tick % 3 == 0 ? 2 : 1, height: tick % 3 == 0 ? 10 : 5)
                            .offset(y: -33)
                            .rotationEffect(.degrees(Double(tick) * 10))
                    }
                    CompassLabels(font: .system(size: 11, weight: .semibold), offset: 33, color: mainColor)
                    
                    ArrowPointer(angle: directionDegrees, mainColor: mainColor)
                        .frame(width: 12, height: 32)
                        .offset(y: -2)
                        .shadow(color: mainColor.opacity(0.24), radius: 4, y: 2)

                    VStack(spacing: -2) {
                        Text("\(Int(speed))")
                            .font(.system(size: 23, weight: .heavy, design: .rounded))
                            .foregroundColor(.primary)
                        Text("mph")
                            .font(.caption2.weight(.bold))
                            .foregroundColor(mainColor.opacity(0.84))
                    }
                    .shadow(color: Color.black.opacity(0.09), radius: 1, y: 1)
                    .offset(y: 8)
                }
                .frame(width: 66, height: 66)
                .padding(.top, 2)
                .padding(.bottom, 2)
                Text(directionLabel)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color("Text Secondary"))
                    .padding(.bottom, 4)

                if let gusts = gusts {
                    Text("Gusts up to \(Int(gusts)) mph")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.secondary)
                        .padding(.bottom, 4)
                }
            }
            .padding(.top, 3)
            .padding(.bottom, 10)
            .padding(.horizontal, 6)
        }
        .frame(maxWidth: .infinity, minHeight: 162)
        .scaleEffect(isPressed ? 0.96 : 1)
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(mainColor.opacity(0.13), lineWidth: 1.6)
        )
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .onTapGesture {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.45)) { isPressed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                withAnimation(.spring()) { isPressed = false }
                showInfo = true
            }
        }
        .sheet(isPresented: $showInfo) {
            WindInfoSheet(
                speed: speed,
                gusts: gusts,
                direction: directionLabel,
                directionDegrees: directionDegrees,
                status: windStatus,
                tips: windDescription
            )
        }
    }

    var windStatus: String {
        switch speed {
        case 0...7: return "Calm"
        case 8...20: return "Breezy"
        default: return "Windy"
        }
    }

    var windDescription: String {
        switch speed {
        case 0...7: return "Gentle breeze, comfortable for all activities."
        case 8...20: return "Noticeable wind, consider securing loose items."
        default: return "Strong wind, caution outdoors."
        }
    }
}

struct CompassLabels: View {
    let font: Font
    let offset: CGFloat
    let color: Color
    var body: some View {
        ZStack {
            Text("N").font(font).foregroundColor(color).offset(y: -offset)
            Text("E").font(font).foregroundColor(color).offset(x: offset)
            Text("S").font(font).foregroundColor(color).offset(y: offset)
            Text("W").font(font).foregroundColor(color).offset(x: -offset)
        }
    }
}

struct ArrowPointer: View {
    let angle: Double
    let mainColor: Color
    var body: some View {
        ArrowShape()
            .fill(LinearGradient(
                colors: [mainColor.opacity(0.85), mainColor.opacity(0.35)],
                startPoint: .top,
                endPoint: .bottom
            ))
            .frame(width: 13, height: 26)
            .offset(y: -13)
            .rotationEffect(.degrees(angle))
            .shadow(color: mainColor.opacity(0.12), radius: 2, y: 1)
    }
}
struct ArrowShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w/2, y: 0))
        p.addLine(to: CGPoint(x: w*0.85, y: h*0.78))
        p.addLine(to: CGPoint(x: w/2, y: h))
        p.addLine(to: CGPoint(x: w*0.15, y: h*0.78))
        p.closeSubpath()
        return p
    }
}

struct WindInfoSheet: View {
    let speed: Double
    let gusts: Double?
    let direction: String
    let directionDegrees: Double
    let status: String
    let tips: String

    var body: some View {
        VStack(spacing: 20) {
            Capsule()
                .fill(Color.gray.opacity(0.24))
                .frame(width: 44, height: 5)
                .padding(.top, 8)
            Text("Wind Details").font(.title2.bold()).padding(.top, 8)
            HStack(spacing: 22) {
                VStack {
                    Text("Speed").font(.headline).foregroundColor(.secondary)
                    Text("\(Int(speed)) mph")
                        .font(.system(size: 32, weight: .heavy, design: .rounded))
                        .foregroundColor(.primary)
                }
                VStack {
                    Text("Direction").font(.headline).foregroundColor(.secondary)
                    Text("\(direction) (\(Int(directionDegrees))°)")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.primary)
                }
                if let gusts = gusts {
                    VStack {
                        Text("Gusts").font(.headline).foregroundColor(.secondary)
                        Text("\(Int(gusts)) mph")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.primary)
                    }
                }
            }
            Text("Status: \(status)").font(.headline)
            Text(tips)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
        .presentationDetents([.medium, .large])
    }
}

#Preview {
    WindMiniCard(speed: 14, directionDegrees: 67, directionLabel: "ENE", gusts: 22)
        .padding()
        .background(Color("Background"))
}
