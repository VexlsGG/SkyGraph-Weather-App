import SwiftUI

struct StatMiniCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    let iconBG: Color?

    init(icon: String, value: String, label: String, color: Color, iconBG: Color? = nil) {
        self.icon = icon
        self.value = value
        self.label = label
        self.color = color
        self.iconBG = iconBG
    }

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                if let iconBG = iconBG {
                    Circle()
                        .fill(iconBG)
                        .frame(width: 32, height: 32)
                }
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(color)
            }
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color("Text Primary"))
                .minimumScaleFactor(0.6)
                .lineLimit(1)
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color("Text Secondary"))
                .lineLimit(1)
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(Color("Card"))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

#Preview {
    StatMiniCard(icon: "wind", value: "5 mph", label: "Wind", color: Color("Graph Line 1"))
        .padding()
        .background(Color("Background"))
}
