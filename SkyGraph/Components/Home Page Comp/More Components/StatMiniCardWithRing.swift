import SwiftUI

struct StatMiniCardWithRing: View {
    let value: Double
    let maxValue: Double
    let mainColor: Color
    let icon: String?
    let emoji: String?
    let label: String
    let valueText: String
    let tag: String
    let tips: String
    let infoTitle: String

    @State private var showInfo = false
    @State private var isPressed = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    LinearGradient(
                        colors: [
                            mainColor.opacity(0.18),
                            Color("Card").opacity(0.93)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: mainColor.opacity(0.10), radius: 8, y: 2)

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Text(tag)
                        .font(.caption2.bold())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(mainColor.opacity(0.13))
                        .foregroundColor(mainColor)
                        .clipShape(Capsule())
                }
                .padding(.top, 4)
                .padding(.bottom, 2)

                ZStack {
                    Circle()
                        .stroke(mainColor.opacity(0.22), lineWidth: 7)
                        .frame(width: 54, height: 54)
                    Circle()
                        .trim(from: 0, to: CGFloat(min(value / maxValue, 1)))
                        .stroke(mainColor, style: StrokeStyle(lineWidth: 7, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 54, height: 54)
                        .animation(.easeOut(duration: 0.8), value: value)
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(mainColor)
                    }
                    if let emoji = emoji {
                        Text(emoji)
                            .font(.system(size: 22))
                    }
                }
                .padding(.vertical, 3)

                Text(valueText)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color("Text Secondary"))
                    .padding(.bottom, 6)
            }
            .padding(.top, 3)
            .padding(.bottom, 10)
            .padding(.horizontal, 3)
        }
        .frame(maxWidth: .infinity, minHeight: 140)
        .scaleEffect(isPressed ? 0.96 : 1)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(mainColor.opacity(0.13), lineWidth: 1.5)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .onTapGesture {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.45)) { isPressed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                withAnimation(.spring()) { isPressed = false }
                showInfo = true
            }
        }
        .sheet(isPresented: $showInfo) {
            StatInfoSheet(
                infoTitle: infoTitle,
                valueText: valueText,
                tag: tag,
                tips: tips
            )
        }
    }
}

struct StatInfoSheet: View {
    let infoTitle: String
    let valueText: String
    let tag: String
    let tips: String

    var body: some View {
        VStack(spacing: 20) {
            Capsule()
                .fill(Color.gray.opacity(0.24))
                .frame(width: 44, height: 5)
                .padding(.top, 8)
            Text(infoTitle).font(.title2.bold()).padding(.top, 8)
            Text(valueText)
                .font(.system(size: 38, weight: .heavy, design: .rounded))
                .foregroundColor(.primary)
            Text("Status: \(tag)").font(.headline)
            Text(tips)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
        .presentationDetents([.medium, .large])
    }
}
