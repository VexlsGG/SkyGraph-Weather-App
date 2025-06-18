import SwiftUI

struct AIChatReturnHomeView: View {
    @Binding var showChat: Bool

    var body: some View {
        VStack {
            Spacer()
            Image("Logo")
                .resizable()
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 8)
                .padding(.bottom, 4)

            Text("Welcome back, weather watcher!")
                .font(.title2.bold())
                .padding(.top, 4)
            Text("SkyBot is ready for your next question.")
                .foregroundColor(.secondary)
                .padding(.bottom, 18)

            Button("Open Chat") {
                withAnimation { showChat = true }
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
            .font(.headline)
            .padding(.horizontal, 40).padding(.vertical, 14)
            .background(Color("Graph Line 2"))
            .foregroundColor(.white)
            .clipShape(Capsule())
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}
