import SwiftUI

struct HumidityMiniCard: View {
    let humidity: Double

    var body: some View {
        StatMiniCardWithRing(
            value: humidity,
            maxValue: 100,
            mainColor: Color("Graph Line 2"),
            icon: "drop.fill",
            emoji: nil,
            label: "Humidity",
            valueText: "\(Int(humidity))% Humidity",
            tag: {
                switch humidity {
                case 0...40: return "Dry"
                case 41...70: return "Comfortable"
                default: return "Humid"
                }
            }(),
            tips: {
                switch humidity {
                case 0...40: return "Air is dry. Moisturize and stay hydrated."
                case 41...70: return "Ideal for most activities."
                default: return "High humidity. It may feel sticky."
                }
            }(),
            infoTitle: "Humidity Details"
        )
    }
}

#Preview {
    HumidityMiniCard(humidity: 58)
        .padding()
        .background(Color("Background"))
}
