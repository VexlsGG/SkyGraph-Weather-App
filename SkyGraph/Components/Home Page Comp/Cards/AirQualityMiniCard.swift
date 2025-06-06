import SwiftUI

struct AirQualityMiniCard: View {
    let aqi: Double 
    let level: String

    var body: some View {
        StatMiniCardWithRing(
            value: aqi,
            maxValue: 500,
            mainColor: {
                switch aqi {
                case 0...50: return Color.green
                case 51...100: return Color.yellow
                case 101...150: return Color.orange
                default: return Color.gray
                }
            }(),
            icon: nil,
            emoji: {
                switch aqi {
                case 0...50: return "🪴"
                case 51...100: return "🌤️"
                case 101...150: return "😷"
                case 151...200: return "😷"
                case 201...300: return "😷"
                case 301...500: return "💀"
                default: return "❓"
                }
            }(),
            label: "Air Quality",
            valueText: "AQI \(Int(aqi))",
            tag: {
                switch aqi {
                case 0...50: return "Healthy"
                case 51...100: return "Moderate"
                case 101...150: return "Unhealthy for Sensitive Groups"
                case 151...200: return "Unhealthy"
                case 201...300: return "Very Unhealthy"
                case 301...500: return "Hazardous"
                default: return "Unknown"
                }
            }(),
            tips: {
                switch aqi {
                case 0...50: return "Air quality is satisfactory, and air pollution poses little or no risk."
                case 51...100: return "Air quality is acceptable. However, there may be a risk for some people, particularly those who are unusually sensitive to air pollution."
                case 101...150: return "Members of sensitive groups may experience health effects. The general public is less likely to be affected."
                case 151...200: return "Some members of the general public may experience health effects; members of sensitive groups may experience more serious health effects."
                case 201...300: return "Health alert: The risk of health effects is increased for everyone."
                case 301...500: return "Health warning of emergency conditions: everyone is more likely to be affected."
                default: return "No data."
                }
            }(),
            infoTitle: "Air Quality Details"
        )
    }
}

#Preview {
    VStack(spacing: 32) {
        AirQualityMiniCard(aqi: 19, level: "Excellent")
        AirQualityMiniCard(aqi: 58, level: "Moderate")
        AirQualityMiniCard(aqi: 102, level: "Unhealthy")
    }
    .padding()
    .background(Color("Background"))
}
