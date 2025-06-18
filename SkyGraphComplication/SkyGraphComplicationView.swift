import WidgetKit
import SwiftUI

struct SkyGraphComplicationView: View {
    var entry: SkyGraphEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .center, spacing: 6) {
                    Image(systemName: entry.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.blue)
                    
                    Text("Now")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(entry.temp)°")
                        .font(.title3.bold())
                        .foregroundColor(.primary)
                }

                TempLineGraph(values: generateFakeTemps())
                    .frame(height: 16)
                    .padding(.top, 1)

                RainGraph(rainValues: entry.rainValues)
                    .frame(height: 6)
            }
            .padding(.vertical, 2)
            
        case .accessoryCircular:
            switch entry.temp % 5 {
            case 0: TempRingWidget(temp: entry.temp, icon: entry.icon)
            case 1: AQIRingWidget(aqi: entry.aqi)
            case 2: RainRingWidget(percent: Int(entry.rainValues.max() ?? 0 * 100))
            case 3: ThermoGaugeWidget(temp: entry.temp)
            case 4: CircularWidget(temp: entry.temp, icon: entry.icon)
            case 5: RadialGaugeWidget(temp: entry.temp)

            default: IconTempMiniWidget(temp: entry.temp, icon: entry.icon)
            }


        case .accessoryInline:
            Text("🌤 \(entry.temp)° | AQI \(entry.aqi)")
            
        default:
            Text("SkyGraph")
        }
    }

    func generateFakeTemps() -> [Double] {
        [65, 67, 70, 72, 74, 73, 71, 69, 68, 66, 64, 62]
    }
    
    func weatherDescription(for icon: String) -> String {
        switch icon {
        case "cloud.sun.fill": return "Partly Cloudy"
        case "cloud.fill": return "Cloudy"
        case "cloud.rain.fill": return "Rain"
        case "sun.max.fill": return "Sunny"
        default: return "Forecast"
        }
    }
}
