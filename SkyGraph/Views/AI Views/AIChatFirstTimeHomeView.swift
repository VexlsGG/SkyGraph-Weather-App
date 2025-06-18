import SwiftUI

struct AIChatFirstTimeHomeView: View {
    @Binding var showChat: Bool
    var onStart: () -> Void

    var body: some View {
        VStack {
            Spacer()
            Image("Logo")
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .shadow(radius: 18)
                .padding(.bottom, 10)

            Text("Welcome to SkyBot!")
                .font(.largeTitle.bold())
                .padding(.top, 8)

            Text("Ask SkyBot anything about the weather, forecasts, or get fun facts. Start chatting to get personal weather insights!")
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding()

            VStack(alignment: .leading, spacing: 10) {
                Label("Will it rain tomorrow in NYC?", systemImage: "cloud.sun.rain.fill")
                Label("How windy will it be this weekend?", systemImage: "wind")
                Label("Tell me a fun weather fact.", systemImage: "sparkles")
            }
            .font(.callout)
            .padding()
            .background(Color("Card").opacity(0.75))
            .clipShape(RoundedRectangle(cornerRadius: 20))

            Button("Start Chatting") {
                onStart()
                withAnimation { showChat = true }
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
            .font(.headline)
            .padding(.top, 24)
            .padding(.horizontal, 40)
            .padding(.vertical, 16)
            .background(Color("Graph Line 1"))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))

            Spacer()
        }
        .padding(.horizontal, 30)
    }
}
