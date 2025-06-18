import SwiftUI

struct AIChatFirstTimeHomeView: View {
    @Binding var showChat: Bool
    var onStart: () -> Void

    let tips: [(icon: String, text: String)] = [
        ("cloud.sun.rain.fill", "Will it rain tomorrow in NYC?"),
        ("wind", "How windy will it be this weekend?"),
        ("sparkles", "Tell me a fun weather fact!"),
        ("thermometer", "How hot will it get today?"),
        ("clock", "When will the rain stop?"),
        ("umbrella", "Should I bring an umbrella?")
    ]
    @State private var tipIndex = 0

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color("Graph Line 1").opacity(0.22),
                    Color("Graph Line 2").opacity(0.22),
                    Color("Background")
                ],
                startPoint: .topLeading, endPoint: .bottomTrailing
            ).ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer(minLength: 60)
                // Avatar with glow
                ZStack {
                    Circle()
                        .fill(Color("Graph Line 1").opacity(0.26))
                        .frame(width: 112, height: 112)
                        .blur(radius: 8)
                    Image("AILogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 26))
                        .shadow(color: Color("Graph Line 1").opacity(0.4), radius: 12, x: 0, y: 4)
                }

                Text("Welcome to SkyBot")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(colors: [Color("Graph Line 1"), Color("Graph Line 2")],
                            startPoint: .topLeading, endPoint: .bottomTrailing)
                    )

                Text("SkyGraph's AI assistant is here for you 24/7.\nGet forecasts, local details, or just chat about the sky.")
                    .font(.title3.weight(.medium))
                    .foregroundColor(Color("Text Primary").opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)

                ZStack {
                    ProGlassCardView()
                    .padding(.vertical, 18)
                    .padding(.horizontal, 18)
                }
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 2.8, repeats: true) { _ in
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                            tipIndex = (tipIndex + 1) % tips.count
                        }
                    }
                }

                Button(action: {
                    onStart()
                    UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                    withAnimation(.spring(response: 0.42, dampingFraction: 0.72)) { showChat = true }
                    playSendSound()
                }) {
                    HStack {
                        Image(systemName: "bolt.fill")
                        Text("Start Chatting")
                    }
                    .font(.title3.weight(.semibold))
                    .padding()
                    .background(
                        LinearGradient(colors: [Color("Graph Line 1"), Color("Graph Line 2")],
                                       startPoint: .leading, endPoint: .trailing)
                            .opacity(0.94)
                    )
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color("Graph Line 2").opacity(0.21), radius: 14, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.09), lineWidth: 1.5)
                    )
                }
                .scaleEffect(showChat ? 0.95 : 1)
                Spacer()
            }
            .padding(.horizontal, 26)
        }
    }
}
