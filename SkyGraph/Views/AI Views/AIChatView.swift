import SwiftUI
import AVFoundation

struct AIChatView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "Hi SkyBot!", sender: .user),
        ChatMessage(text: "Hello! Ask me anything about the weather.", sender: .bot)
    ]
    @State private var input: String = ""
    @State private var isAITyping = false
    @State private var aiPulse = false // for avatar mood pulse

    var onClose: (() -> Void)? = nil

    var body: some View {
        ZStack(alignment: .topTrailing) {
            LinearGradient(
                colors: [
                    Color("Background"),
                    Color("Graph Line 1").opacity(0.08),
                    Color("Graph Line 2").opacity(0.09)
                ],
                startPoint: .top, endPoint: .bottomTrailing
            ).ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        if let onClose = onClose { onClose() } else { dismiss() }
                        playCloseSound()
                    }) {
                        Image(systemName: "chevron.down")
                            .font(.title2.weight(.bold))
                            .padding(11)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }
                    .padding(.leading, 12)
                    Spacer()
                }
                .padding(.top, 13)

                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(messages) { msg in
                                messageBubble(msg)
                                    .id(msg.id)
                            }
                            if isAITyping {
                                HStack(alignment: .center, spacing: 8) {
                                    aiAvatar(isPulsing: true)
                                    TypingIndicator()
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .transition(.opacity.combined(with: .scale))
                            }
                        }
                        .padding(.vertical)
                    }
                    .onChange(of: messages) {
                        withAnimation(.easeOut) { proxy.scrollTo(messages.last?.id, anchor: .bottom) }
                    }
                }

                // Input bar
                HStack(spacing: 10) {
                    TextField("Type your weather question…", text: $input)
                        .font(.body.weight(.medium))
                        .textFieldStyle(.roundedBorder)
                        .frame(minHeight: 46)
                        .background(
                            GlassBackground(cornerRadius: 16, opacity: 0.85)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    Button(action: send) {
                        Image(systemName: "paperplane.fill")
                            .font(.title3)
                            .foregroundColor(input.isEmpty ? .gray : Color("Graph Line 1"))
                            .padding(10)
                            .background(input.isEmpty ? Color.gray.opacity(0.1) : Color("Card").opacity(0.7))
                            .clipShape(Circle())
                            .shadow(color: Color("Graph Line 1").opacity(input.isEmpty ? 0 : 0.21), radius: 8, y: 4)
                    }
                    .disabled(input.isEmpty)
                }
                .padding(.horizontal)
                .padding(.bottom, 18)
            }
        }
    }

    // Avatar with pulsing glow while AI is typing
    func aiAvatar(isPulsing: Bool) -> some View {
        ZStack {
            if isPulsing {
                Circle()
                    .fill(
                        LinearGradient(colors: [Color("Graph Line 1"), Color("Graph Line 2")],
                            startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 39, height: 39)
                    .shadow(color: Color("Graph Line 1").opacity(0.24), radius: 14, y: 4)
                    .scaleEffect(aiPulse ? 1.14 : 0.98)
                    .opacity(aiPulse ? 0.74 : 0.56)
                    .animation(.easeInOut(duration: 0.74).repeatForever(autoreverses: true), value: aiPulse)
                    .onAppear { aiPulse = true }
                    .onDisappear { aiPulse = false }
            }
            Image("AILogo")
                .resizable()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                .shadow(radius: 2)
        }
    }

    @ViewBuilder
    func messageBubble(_ msg: ChatMessage) -> some View {
        HStack(alignment: .bottom) {
            if msg.sender == .user { Spacer() }
            if msg.sender == .bot { aiAvatar(isPulsing: false) }
            if msg.sender == .bot {
                TypewriterText(text: msg.text)
                    .proBubbleStyle(isUser: false)
            } else {
                Text(msg.text)
                    .proBubbleStyle(isUser: true)
            }
            if msg.sender == .bot { Spacer() }
        }
        .padding(.horizontal)
        .animation(.spring(response: 0.54, dampingFraction: 0.88), value: messages)
    }

    func send() {
        guard !input.isEmpty else { return }
        let userMsg = ChatMessage(text: input, sender: .user)
        messages.append(userMsg)
        isAITyping = true
        input = ""

        // Haptic and send sound
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        playSendSound()

        // Simulate AI thinking
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.05) {
            messages.append(ChatMessage(text: "I'll get back to you about that.", sender: .bot))
            withAnimation { isAITyping = false }
        }
    }
}

// Pro bubble style with glow and glass
extension View {
    func proBubbleStyle(isUser: Bool) -> some View {
        self
            .padding(.vertical, 12)
            .padding(.horizontal, 18)
            .background(
                GlassBackground(cornerRadius: 22, opacity: 0.94)
                    .shadow(color: isUser ? Color("Graph Line 1").opacity(0.23) : Color("Graph Line 2").opacity(0.18),
                            radius: isUser ? 14 : 10, y: 6)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(isUser ? Color("Graph Line 1").opacity(0.29) : Color("Graph Line 2").opacity(0.24),
                            lineWidth: 1.4)
            )
            .foregroundColor(isUser ? Color("Graph Line 1") : Color("Text Primary"))
            .font(.body.weight(.medium))
            .transition(.asymmetric(insertion: .move(edge: isUser ? .trailing : .leading).combined(with: .opacity), removal: .opacity))
    }
}

// Animated typewriter effect for bot
struct TypewriterText: View {
    let text: String
    @State private var visibleCount = 0
    let typingSpeed: Double = 0.035

    var body: some View {
        Text(String(text.prefix(visibleCount)))
            .onAppear {
                visibleCount = 0
                Timer.scheduledTimer(withTimeInterval: typingSpeed, repeats: true) { timer in
                    if visibleCount < text.count {
                        visibleCount += 1
                        playTypeSound()
                    } else {
                        timer.invalidate()
                    }
                }
            }
    }
}

// Animated typing indicator
struct TypingIndicator: View {
    @State private var dotCount = 0
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<3) { idx in
                Circle()
                    .fill(Color("Graph Line 1"))
                    .frame(width: 7, height: 7)
                    .opacity(0.5 + Double(idx) * 0.25)
                    .scaleEffect(dotCount > idx ? 1.18 : 0.9)
            }
        }
        .onAppear { animate() }
    }
    func animate() {
        var step = 0
        Timer.scheduledTimer(withTimeInterval: 0.33, repeats: true) { timer in
            if step > 2 { step = 0 }
            dotCount = step + 1
            step += 1
        }
    }
}

// Play simple tap sound (requires short wav/aif in bundle, or use system sound)
func playSendSound() {
    AudioServicesPlaySystemSound(1001)
    /*
    if let url = Bundle.main.url(forResource: "SendSound", withExtension: "wav") {
        var player: AVAudioPlayer?
        player = try? AVAudioPlayer(contentsOf: url)
        player?.play()
    }
     */
}
// Optional: For closing, etc.
func playCloseSound() {
    AudioServicesPlaySystemSound(1057)
    /*
    if let url = Bundle.main.url(forResource: "CloseSound", withExtension: "wav") {
        var player: AVAudioPlayer?
        player = try? AVAudioPlayer(contentsOf: url)
        player?.play()
    }
     */
}
func playTypeSound() {
    AudioServicesPlaySystemSound(1104)
    /*
    if let url = Bundle.main.url(forResource: "TypeSound", withExtension: "wav") {
        var player: AVAudioPlayer?
        player = try? AVAudioPlayer(contentsOf: url)
        player?.play()
    }
     */
}
