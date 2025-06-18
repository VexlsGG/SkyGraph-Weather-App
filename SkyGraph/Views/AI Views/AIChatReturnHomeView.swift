import SwiftUI

struct AIChatReturnHomeView: View {
    @Binding var showChat: Bool

    let tips: [(icon: String, text: String)] = [
        ("cloud.sun.rain.fill", "Need an instant forecast?"),
        ("clock", "Ask for hourly updates!"),
        ("wind", "Curious about wind speeds?"),
        ("sun.max", "How hot will it get today?")
    ]
    @State private var tipIndex = 0

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color("Graph Line 2").opacity(0.15),
                    Color("Graph Line 1").opacity(0.10),
                    Color("Background")
                ],
                startPoint: .top, endPoint: .bottom
            ).ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer(minLength: 56)
                ZStack {
                    Circle()
                        .fill(Color("Graph Line 2").opacity(0.20))
                        .frame(width: 90, height: 90)
                        .blur(radius: 7)
                    Image("AILogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 62, height: 62)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(color: Color("Graph Line 2").opacity(0.30), radius: 10, y: 3)
                }

                Text("Welcome back!")
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(colors: [Color("Graph Line 2"), Color("Graph Line 1")],
                                       startPoint: .leading, endPoint: .trailing)
                    )

                ZStack {
                    ProGlassCardView()
                    .padding(.vertical, 13)
                    .padding(.horizontal, 16)
                }
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                        withAnimation(.spring(response: 0.42, dampingFraction: 0.83)) {
                            tipIndex = (tipIndex + 1) % tips.count
                        }
                    }
                }

                Button(action: {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.72)) { showChat = true }
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    playSendSound()
                }) {
                    HStack {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                        Text("Open Chat")
                    }
                    .font(.title3.weight(.semibold))
                    .padding(.horizontal, 40).padding(.vertical, 16)
                    .background(
                        LinearGradient(colors: [Color("Graph Line 2"), Color("Graph Line 1")],
                                       startPoint: .leading, endPoint: .trailing)
                            .opacity(0.93)
                    )
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .shadow(color: Color("Graph Line 1").opacity(0.15), radius: 8, y: 3)
                }
                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }
}
