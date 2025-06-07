import SwiftUI

struct ChatMessage: Identifiable {
    enum Sender { case user, bot }
    let id = UUID()
    let text: String
    let sender: Sender
}

struct AIChatView: View {
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "Hi SkyBot!", sender: .user),
        ChatMessage(text: "Hello! Ask me anything about the weather.", sender: .bot)
    ]
    @State private var input: String = ""

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(messages) { msg in
                            messageBubble(msg)
                                .id(msg.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: messages) { _ in
                    withAnimation { proxy.scrollTo(messages.last?.id, anchor: .bottom) }
                }
            }

            HStack {
                TextField("Message", text: $input)
                    .textFieldStyle(.roundedBorder)
                Button(action: send) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(Color("Graph Line 1"))
                }
            }
            .padding()
        }
        .background(Color("Background").ignoresSafeArea())
    }

    @ViewBuilder
    func messageBubble(_ msg: ChatMessage) -> some View {
        HStack(alignment: .bottom) {
            if msg.sender == .user { Spacer() }
            if msg.sender == .bot {
                Image("Logo")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            }
            Text(msg.text)
                .padding(10)
                .background(
                    ZStack {
                        GlassBackground(cornerRadius: 18)
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color("Card").opacity(0.6))
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color("Graph Line 1").opacity(0.15), lineWidth: 1)
                )
                .foregroundColor(Color("Text Primary"))
            if msg.sender == .bot { Spacer() }
        }
    }

    func send() {
        guard !input.isEmpty else { return }
        messages.append(ChatMessage(text: input, sender: .user))
        // Placeholder bot response. Replace with API call
        messages.append(ChatMessage(text: "I'll get back to you about that.", sender: .bot))
        input = ""
    }
}

#Preview {
    AIChatView()
}
