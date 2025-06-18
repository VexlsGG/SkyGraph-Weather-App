import SwiftUI

struct ProGlassCardView: View {
    @State private var isPressed = false
    @State private var animateGlow = false
    @State private var tipIndex = 0

    // Example rotating tips
    let tips: [(icon: String, text: String)] = [
        ("cloud.sun.rain.fill", "Need an instant forecast?"),
        ("wind", "How windy is it today?"),
        ("sparkles", "Ask for a fun weather fact!"),
        ("umbrella", "Should you grab an umbrella?")
    ]

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Glass Card + Glow
            ZStack {
                GlassBackground(cornerRadius: 28, opacity: 0.95)
                    .overlay(
                        // Animated Glow Layer (can replace with Lottie if desired)
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color("Graph Line 1").opacity(0.5 + (animateGlow ? 0.4 : 0)),
                                        Color("Graph Line 2").opacity(0.5 + (animateGlow ? 0.4 : 0))
                                    ],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                ),
                                lineWidth: 6 + (animateGlow ? 2 : 0)
                            )
                            .blur(radius: 12 + (animateGlow ? 10 : 0))
                            .opacity(animateGlow ? 1 : 0.3)
                            .scaleEffect(isPressed ? 0.97 : 1.0)
                            .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: animateGlow)
                    )

                // Card content
                VStack(spacing: 18) {
                    // 1. Animated icon at the top (SF Symbol with shimmer or pulse, or your logo as Image)
                    AnimatedIconView(icon: tips[tipIndex].icon)
                        .padding(.top, 8)
                    
                    // 2. Tip text (rotates every 3 seconds)
                    Text(tips[tipIndex].text)
                        .font(.title3.weight(.medium))
                        .foregroundColor(Color("Graph Line 2"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 12)
                        .transition(.opacity.combined(with: .slide))
                }
                .padding(.vertical, 28)
                .padding(.horizontal, 18)
            }
            .frame(maxWidth: 340, minHeight: 140)
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .shadow(color: Color("Graph Line 1").opacity(isPressed ? 0.30 : 0.12), radius: isPressed ? 28 : 16, y: 10)
            .onTapGesture {
                // On tap: bounce and cycle tip
                withAnimation(.spring(response: 0.42, dampingFraction: 0.65)) {
                    isPressed = true
                    tipIndex = (tipIndex + 1) % tips.count
                }
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                    isPressed = false
                }
            }
            .onAppear {
                animateGlow = true
                // Also cycle tip every 3.2 seconds
                Timer.scheduledTimer(withTimeInterval: 3.2, repeats: true) { _ in
                    withAnimation(.spring(response: 0.43, dampingFraction: 0.82)) {
                        tipIndex = (tipIndex + 1) % tips.count
                    }
                }
            }

            // 3. Mini AI Avatar (bottom right), with pulse
            VStack {
                AIAvatarPulsing()
            }
            .padding(10)
        }
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

// Replace with your LottieView if you want:
// LottieView(name: "glow-effect", loopMode: .loop)
//     .frame(width: 52, height: 52)

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
