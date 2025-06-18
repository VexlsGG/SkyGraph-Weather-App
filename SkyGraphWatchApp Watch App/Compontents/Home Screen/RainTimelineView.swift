import SwiftUI

struct RainTimelineView: View {
    let minutes: [MinuteRain]
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width / CGFloat(minutes.count)
            HStack(spacing: 0) {
                ForEach(minutes) { min in
                    Capsule()
                        .fill(min.precipChance > 40 ? Color.blue : Color.gray.opacity(0.14))
                        .frame(width: max(1, width), height: CGFloat(min.precipChance) * 0.7 + 8)
                        .opacity(min.precipChance > 0 ? 1 : 0.18)
                        .animation(.easeInOut(duration: 0.6), value: min.precipChance)
                }
            }
        }
        .frame(height: 28)
        .clipShape(RoundedRectangle(cornerRadius: 11))
        .overlay(
            HStack {
                Text("Now").font(.caption2).foregroundColor(.secondary)
                Spacer()
                Text("+60 min").font(.caption2).foregroundColor(.secondary)
            }
            .padding(.horizontal, 7)
            .padding(.top, 1),
            alignment: .top
        )
    }
}
