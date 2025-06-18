import SwiftUI

struct GlassBackground: View {
    var cornerRadius: CGFloat = 22
    var opacity: Double = 0.85
    var blur: CGFloat = 18

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(.ultraThinMaterial)
            .opacity(opacity)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.13), lineWidth: 1.2)
            )
            .blur(radius: blur / 8)
    }
}
