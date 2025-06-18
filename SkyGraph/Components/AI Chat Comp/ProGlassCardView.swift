import SwiftUI

struct ProGlassCardView: View {
    @State private var isPressed = false
    @State private var animateGlow = false
    @State private var tipIndex = 0

    let tips: [(icon: String, text: String)] = [
        ("cloud.sun.rain.fill", "Need an instant forecast?"),
        ("wind", "How windy is it today?"),
        ("sparkles", "Ask for a fun weather fact!"),
        ("umbrella", "Should you grab an umbrella?")
    ]

    var body: some View {
        ZStack {
            GlassBackground(cornerRadius: 22, opacity: 0.95)
                .shadow(color: Color("Graph Line 1").opacity(0.13), radius: 18, y: 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(
                            LinearGradient(colors: [
                                Color("Graph Line 1").opacity(0.18 + (animateGlow ? 0.13 : 0)),
                                Color("Graph Line 2").opacity(0.15 + (animateGlow ? 0.15 : 0))
                            ], startPoint: .topLeading, endPoint: .bottomTrailing),
                            lineWidth: 3 + (animateGlow ? 1 : 0)
                        )
                        .blur(radius: 6 + (animateGlow ? 4 : 0))
                        .opacity(animateGlow ? 1 : 0.5)
                        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: animateGlow)
                )
                .onAppear { animateGlow = true }

            VStack(spacing: 10) {
                HStack(alignment: .center, spacing: 13) {
                    AnimatedIconView(icon: tips[tipIndex].icon)
                        .frame(width: 36, height: 36)
                    Text(tips[tipIndex].text)
                        .font(.title3.weight(.medium))
                        .foregroundColor(Color("Graph Line 2"))
                        .multilineTextAlignment(.leading)
                        .transition(.opacity.combined(with: .slide))
                }
                .padding(.vertical, 16)

                AnimatedDots()

                Text("Did you know? The windiest place on Earth is Antarctica.")
                    .font(.caption)
                    .foregroundColor(Color("Text Primary").opacity(0.72))
                    .padding(.top, 2)

                HStack {
                    Spacer()
                    AIAvatarPulsing()
                        .padding(.top, 6)
                    Spacer()
                }
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 18)
        }
        .frame(maxWidth: 320, minHeight: 142)
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .onTapGesture {
            withAnimation(.spring(response: 0.42, dampingFraction: 0.65)) {
                isPressed = true
                tipIndex = (tipIndex + 1) % tips.count
            }
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.17) {
                isPressed = false
            }
        }
    }
}

struct AnimatedDots: View {
    @State private var phase = false
    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<3) { i in
                Circle()
                    .fill(phase ? Color("Graph Line 2") : Color("Graph Line 1"))
                    .frame(width: 6, height: 6)
                    .opacity(0.7)
                    .scaleEffect(phase ? 1.1 : 0.92)
                    .animation(.easeInOut(duration: 0.7).repeatForever().delay(Double(i) * 0.2), value: phase)
            }
        }
        .onAppear { phase = true }
    }
}
struct AnimatedIconView: View {
    let icon: String
    @State private var animate = false

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color("Graph Line 1"), Color("Graph Line 2")],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                .frame(width: 52, height: 52)
                .blur(radius: 8)
                .opacity(animate ? 0.70 : 0.48)
                .scaleEffect(animate ? 1.10 : 0.98)
            Image(systemName: icon)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: Color("Graph Line 2").opacity(0.22), radius: 10, y: 6)
                .scaleEffect(animate ? 1.08 : 1.0)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}
struct AIAvatarPulsing: View {
    @State private var pulse = false

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color("Graph Line 1").opacity(0.35), Color("Graph Line 2").opacity(0.25)],
                        startPoint: .top, endPoint: .bottomTrailing
                    )
                )
                .frame(width: 38, height: 38)
                .scaleEffect(pulse ? 1.16 : 0.93)
                .opacity(pulse ? 0.55 : 0.38)
                .animation(.easeInOut(duration: 0.86).repeatForever(autoreverses: true), value: pulse)
            Image("AILogo")
                .resizable()
                .scaledToFit()
                .frame(width: 26, height: 26)
                .clipShape(Circle())
                .shadow(radius: 3)
        }
        .onAppear { pulse = true }
    }
}

#Preview {
    ProGlassCardView()
}
