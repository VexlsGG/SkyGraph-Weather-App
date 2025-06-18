import SwiftUI

struct AIChatView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "Hi SkyBot!", sender: .user),
        ChatMessage(text: "Hello! Ask me anything about the weather.", sender: .bot)
    ]
    @State private var input: String = ""

    var onClose: (() -> Void)? = nil

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color("Background").ignoresSafeArea()

            VStack(spacing: 0) {
                // Top close button
                HStack {
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        if let onClose = onClose { onClose() } else { dismiss() }
                    }) {
                        Image(systemName: "chevron.down")
                            .font(.title2.weight(.bold))
                            .padding(10)
                            .background(Color("Card").opacity(0.9))
                            .clipShape(Circle())
                    }
                    .padding(.leading, 10)
                    Spacer()
                }
                .padding(.top, 12)

                // Messages scroll
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 14) {
                            ForEach(messages) { msg in
                                messageBubble(msg)
                                    .id(msg.id)
                            }
                        }
                        .padding(.vertical)
                    }
                    .onChange(of: messages) {
                        withAnimation { proxy.scrollTo(messages.last?.id, anchor: .bottom) }
                    }
                }

                // Chat input
                HStack(spacing: 10) {
                    TextField("Type your weather question…", text: $input)
                        .textFieldStyle(.roundedBorder)
                        .frame(minHeight: 44)
                        .background(Color("Card").opacity(0.7))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    Button(action: send) {
                        Image(systemName: "paperplane.fill")
                            .font(.title3)
                            .foregroundColor(input.isEmpty ? .gray : Color("Graph Line 1"))
                            .padding(10)
                            .background(input.isEmpty ? Color.gray.opacity(0.1) : Color("Card").opacity(0.5))
                            .clipShape(Circle())
                    }
                    .disabled(input.isEmpty)
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
        }
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
                    .shadow(radius: 3)
            }
            Text(msg.text)
                .padding(.vertical, 11)
                .padding(.horizontal, 15)
                .background(
                    ZStack {
                        // Use your own glass background if you have one
                        // GlassBackground(cornerRadius: 18)
                        RoundedRectangle(cornerRadius: 18)
                            .fill(msg.sender == .user
                                ? Color("Graph Line 1").opacity(0.17)
                                : Color("Card").opacity(0.75))
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color("Graph Line 1").opacity(0.16), lineWidth: 1)
                )
                .foregroundColor(msg.sender == .user ? Color("Graph Line 1") : Color("Text Primary"))
            if msg.sender == .bot { Spacer() }
        }
        .padding(.horizontal)
        .transition(.move(edge: msg.sender == .user ? .trailing : .leading).combined(with: .opacity))
    }

    func send() {
        guard !input.isEmpty else { return }
        messages.append(ChatMessage(text: input, sender: .user))
        messages.append(ChatMessage(text: "I'll get back to you about that.", sender: .bot))
        input = ""
    }
}

#Preview { AIChatView() }
