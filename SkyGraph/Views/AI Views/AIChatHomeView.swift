import SwiftUI

struct AIChatHomeView: View {
    @AppStorage("hasSeenAIHome") private var hasSeenAIHome: Bool = false
    @State private var showChat = false

    var body: some View {
        Group {
            if hasSeenAIHome {
                AIChatReturnHomeView(showChat: $showChat)
            } else {
                AIChatFirstTimeHomeView(showChat: $showChat) {
                    hasSeenAIHome = true
                }
            }
        }
        .fullScreenCover(isPresented: $showChat) {
            AIChatView(onClose: { showChat = false })
                .transition(.move(edge: .bottom))
        }
    }
}

#Preview { AIChatHomeView() }
    