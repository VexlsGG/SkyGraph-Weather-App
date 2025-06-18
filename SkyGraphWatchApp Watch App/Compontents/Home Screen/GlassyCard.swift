import SwiftUI

struct GlassyCard<Content: View>: View {
    var content: () -> Content

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(Color.accentColor.opacity(0.10), lineWidth: 1.3)
                )
                .shadow(color: Color.black.opacity(0.10), radius: 2, x: 0, y: 2)
            content()
                .padding(.horizontal, 6)
                .padding(.vertical, 7)
        }
        .padding(.horizontal, 1)
        .padding(.bottom, 2)
    }
}
