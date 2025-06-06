import SwiftUI

struct StatCard: Identifiable {
    let id = UUID()
    let icon: String
    let value: String
    let label: String
    let color: Color
}

struct StatCardsRow: View {
    let stats: [StatCard] = [
        .init(icon: "wind", value: "5 mph", label: "Wind", color: .white),
        .init(icon: "drop.fill", value: "55%", label: "Humidity", color: .white),
        .init(icon: "sun.max.fill", value: "UV", label: "UV Index", color: Color(red: 1, green: 0.80, blue: 0.29))
    ]

    var body: some View {
        HStack(spacing: 14) {
            ForEach(stats) { stat in
                VStack(spacing: 4) {
                    ZStack {
                        if stat.label == "UV Index" {
                            Circle()
                                .fill(stat.color)
                                .frame(width: 44, height: 44)
                        }
                        Image(systemName: stat.icon)
                            .font(.system(size: 27, weight: .bold))
                            .foregroundColor(stat.label == "UV Index" ? .white : stat.color)
                    }
                    Text(stat.value)
                        .font(.system(size: 28, weight: .heavy))
                        .foregroundColor(Color("Text Primary"))
                    Text(stat.label)
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(Color("Text Primary"))
                }
                .frame(maxWidth: .infinity, minHeight: 90)
                .padding()
                .background(Color("Card"))
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            }
        }
    }
}

#Preview {
    StatCardsRow()
}
