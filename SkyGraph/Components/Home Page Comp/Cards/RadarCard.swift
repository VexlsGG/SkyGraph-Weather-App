import SwiftUI

struct RadarCard: View {
    @State private var isPremium: Bool = false // This is where to enable premium or na
    @State private var isPressed = false
    @State private var sweepAngle: Double = 210
    var liveRadarImage: Image? = nil
    
    var body: some View {
        NavigationLink(destination: isPremium ? RadarView() : nil) {
            ZStack {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color("Graph Line 1").opacity(0.11),
                                Color("Card").opacity(0.92)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .background(.ultraThinMaterial)
                    .shadow(color: Color("Graph Line 1").opacity(0.10), radius: 8, y: 2)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Weather Radar")
                            .font(.headline)
                            .foregroundColor(Color("Graph Line 1"))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.subheadline.bold())
                            .foregroundColor(Color("Graph Line 1").opacity(0.47))
                            .padding(.trailing, 2)
                    }
                    ZStack {
                        if let liveImage = liveRadarImage {
                            liveImage
                                .resizable()
                                .scaledToFill()
                                .frame(height: 110)
                                .clipped()
                        } else {
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color("Background").opacity(0.9),
                                            Color("Card").opacity(0.8)
                                        ],
                                        startPoint: .top, endPoint: .bottom
                                    )
                                )
                            ForEach(0..<6) { i in
                                Rectangle()
                                    .fill(Color("Text Secondary").opacity(0.09))
                                    .frame(width: 1, height: 110)
                                    .offset(x: CGFloat(i) * 110/5 - 55)
                                Rectangle()
                                    .fill(Color("Text Secondary").opacity(0.09))
                                    .frame(width: 110, height: 1)
                                    .offset(y: CGFloat(i) * 110/5 - 55)
                            }
                            RadarArc(start: 0.24, end: 0.43, color: .green)
                            RadarArc(start: 0.40, end: 0.60, color: .yellow)
                            RadarArc(start: 0.57, end: 0.70, color: .orange)
                            RadarArc(start: 0.67, end: 0.80, color: .red)
                            RadarArc(start: 0.30, end: 0.38, color: .cyan)
                            RadarDot(angle: 0.33, dist: 28, color: .green)
                            RadarDot(angle: 0.50, dist: 34, color: .yellow)
                            RadarDot(angle: 0.66, dist: 37, color: .orange)
                            Circle()
                                .stroke(Color("Text Secondary").opacity(0.14), lineWidth: 2.2)
                                .frame(width: 24, height: 24)
                            Image(systemName: "cloud.fill")
                                .foregroundColor(Color("Text Secondary").opacity(0.09))
                                .font(.system(size: 32))
                                .offset(x: 26, y: -24)
                            Image(systemName: "cloud.rain.fill")
                                .foregroundColor(Color.blue.opacity(0.08))
                                .font(.system(size: 29))
                                .offset(x: -34, y: 17)
                        }
                        RadarSweepOverlay(progress: sweepAngle)
                            .stroke(
                                AngularGradient(
                                    gradient: Gradient(colors: [
                                        Color.green.opacity(0.23), .clear
                                    ]),
                                    center: .center,
                                    startAngle: .degrees(sweepAngle),
                                    endAngle: .degrees(sweepAngle + 50)
                                ),
                                lineWidth: 13
                            )
                            .frame(width: 106, height: 106)
                            .rotationEffect(.degrees(12))
                            .blendMode(.plusLighter)
                            .animation(.linear(duration: 2), value: sweepAngle)
                            .onAppear { animateSweep() }
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Text(liveRadarImage != nil ? "Live Radar" : "Live Preview")
                                    .font(.caption2)
                                    .foregroundColor(Color("Text Secondary"))
                                    .padding(4)
                                    .background(.ultraThinMaterial.opacity(0.4))
                                    .clipShape(Capsule())
                                    .padding([.trailing, .bottom], 8)
                            }
                        }
                        if !isPremium {
                            Color.black.opacity(0.22)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            VStack {
                                Spacer()
                                Button(action: {
                                }) {
                                    HStack {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                            .font(.body.bold())
                                        Text("Upgrade for Interactive Radar")
                                            .font(.footnote.weight(.bold))
                                            .foregroundColor(.white)
                                    }
                                    .padding(.vertical, 9)
                                    .padding(.horizontal, 18)
                                    .background(
                                        LinearGradient(colors: [Color.yellow.opacity(0.75), .orange.opacity(0.85)], startPoint: .top, endPoint: .bottom)
                                    )
                                    .clipShape(Capsule())
                                    .shadow(radius: 7, y: 2)
                                }
                                .padding(.bottom, 22)
                            }
                        }
                    }
                    .frame(height: 110)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color("Graph Line 2").opacity(0.13), lineWidth: 1.2)
                    )
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 14)
            }
            .frame(maxWidth: .infinity, minHeight: 170)
            .scaleEffect(isPressed ? 0.96 : 1)
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Color("Graph Line 1").opacity(0.13), lineWidth: 1.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.45)) { isPressed = true }
                }
                .onEnded { _ in
                    withAnimation(.spring()) { isPressed = false }
                }
        )
        .disabled(!isPremium)
    }
    
    func animateSweep() {
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            sweepAngle = 360
        }
    }
}


struct RadarArc: View {
    var start: CGFloat
    var end: CGFloat
    var color: Color
    var body: some View {
        Circle()
            .trim(from: start, to: end)
            .stroke(
                LinearGradient(
                    colors: [color.opacity(0.84), color.opacity(0.16)],
                    startPoint: .leading, endPoint: .trailing
                ),
                style: StrokeStyle(lineWidth: 15, lineCap: .round)
            )
            .frame(width: 86, height: 86)
            .rotationEffect(.degrees(-90))
            .blur(radius: 0.4)
    }
}

struct RadarDot: View {
    var angle: CGFloat
    var dist: CGFloat
    var color: Color
    var body: some View {
        Circle()
            .fill(color.opacity(0.67))
            .frame(width: 11, height: 11)
            .offset(
                x: cos(.pi * 2 * angle) * dist,
                y: sin(.pi * 2 * angle) * dist
            )
    }
}

struct RadarSweepOverlay: Shape {
    var progress: Double
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                 radius: rect.width/2-4,
                 startAngle: .degrees(progress),
                 endAngle: .degrees(progress + 50),
                 clockwise: false)
        return p
    }
}

#Preview {
    NavigationView {
        RadarCard(
            // Example: To show a live radar image, provide one here:
            // liveRadarImage: Image("YourRadarAssetName"),
            // isPremium: true // test premium mode
        )
        .padding()
        .background(Color("Background"))
    }
}
