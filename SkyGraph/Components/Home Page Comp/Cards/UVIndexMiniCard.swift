import SwiftUI

struct UVIndexMiniCard: View {
    let uv: Double

    var body: some View {
        StatMiniCardWithRing(
            value: min(uv, 11),
            maxValue: 11,
            mainColor: Color.yellow,
            icon: nil,
            emoji: {
                switch uv {
                case 0...2: return "🌙"
                case 3...5: return "⛅️"
                case 6...7: return "🌞"
                case 8...11: return "🔥"
                default: return "❓"
                }
            }(),
            label: "UV Index",
            valueText: "UV \(Int(uv))",
            tag: {
                switch uv {
                case 0...2: return "Low"
                case 3...5: return "Moderate"
                case 6...7: return "High"
                case 8...11: return "Very High"
                default: return "Unknown"
                }
            }(),
            tips: {
                switch uv {
                case 0...2: return "Safe for most outdoor activities."
                case 3...5: return "Use sunscreen and wear sunglasses."
                case 6...7: return "Reduce sun exposure between 10am and 4pm."
                case 8...11: return "Extra protection needed: SPF 30+, hat, sunglasses, seek shade."
                default: return "No data."
                }
            }(),
            infoTitle: "UV Index Details"
        )
    }
}

#Preview {
    UVIndexMiniCard(uv: 9)
        .padding()
        .background(Color("Background"))
}
