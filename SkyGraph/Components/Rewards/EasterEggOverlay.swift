import SwiftUI

struct EasterEggOverlay: View {
    var dismiss: () -> Void
    var mainIcon: String = "sparkles" // Or "egg.fill"
    var mainTitle: String = "🌈 Secret Mode Unlocked!"
    var bodyText: String = "You found the Easter Egg! 🎉\nEnjoy this hidden secret."
    var gradientColors: [Color] = [.yellow, .purple, .blue, .pink]
    var cardBG: [Color] = [.yellow.opacity(0.6), .purple.opacity(0.28), .blue.opacity(0.24), .pink.opacity(0.28)]
    var accent: Color = .yellow
    var autoDismissAfter: Double? = 2.2 // seconds, nil to disable

    @State private var animate = false
    @State private var isVisible = true

    var body: some View {
        ZStack {
            if isVisible {
                Color.black.opacity(0.18)
                    .ignoresSafeArea()
                    .transition(.opacity)

                VStack {
                    Spacer()
                    ZStack {
                        // Glassy background with sparkles
                        RoundedRectangle(cornerRadius: 38, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .background(
                                LinearGradient(colors: cardBG, startPoint: .topLeading, endPoint: .bottomTrailing)
                                    .blur(radius: 12)
                            )
                            .shadow(color: accent.opacity(0.18), radius: 40, y: 8)
                            .frame(width: 340, height: 260)
                            .overlay(
                                RoundedRectangle(cornerRadius: 38, style: .continuous)
                                    .strokeBorder(
                                        LinearGradient(colors: gradientColors + [gradientColors.first!], startPoint: .top, endPoint: .bottom),
                                        lineWidth: 2.8
                                    )
                                    .blur(radius: 1.8)
                                    .opacity(0.7)
                            )

                        ForEach(0..<14, id: \.self) { i in
                            Circle()
                                .fill(gradientColors.randomElement()!.opacity(0.23))
                                .frame(width: CGFloat.random(in: 6...12), height: CGFloat.random(in: 6...12))
                                .offset(
                                    x: CGFloat.random(in: -120...120),
                                    y: CGFloat.random(in: -80...80)
                                )
                                .blur(radius: 0.7)
                        }

                        VStack(spacing: 18) {
                            ZStack {
                                Circle()
                                    .fill(RadialGradient(colors: [accent.opacity(0.7), .clear], center: .center, startRadius: 0, endRadius: 56))
                                    .frame(width: 84, height: 84)
                                    .scaleEffect(animate ? 1.12 : 0.7)
                                    .opacity(animate ? 1 : 0.7)
                                    .animation(.spring(response: 0.7, dampingFraction: 0.3), value: animate)

                                Image(systemName: mainIcon)
                                    .font(.system(size: 46, weight: .bold))
                                    .foregroundColor(accent)
                                    .shadow(color: accent.opacity(0.7), radius: 16, y: 0)
                                    .scaleEffect(animate ? 1.13 : 0.88)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.32), value: animate)
                            }
                            .padding(.top, 8)

                            Text(mainTitle)
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing)
                                )
                                .shadow(color: accent.opacity(0.19), radius: 4, y: 0)
                                .scaleEffect(animate ? 1.07 : 1.0)
                                .animation(.spring(response: 0.7, dampingFraction: 0.5), value: animate)

                            Text(bodyText)
                                .font(.headline)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                    }
                    .frame(width: 340, height: 260)
                    Spacer()
                }
                .transition(.scale.combined(with: .opacity))
                .onTapGesture {
                    withAnimation { isVisible = false }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        dismiss()
                    }
                }
                .onAppear {
                    animate = true
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    if let t = autoDismissAfter {
                        DispatchQueue.main.asyncAfter(deadline: .now() + t) {
                            if isVisible {
                                withAnimation { isVisible = false }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    dismiss()
                                }
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}
