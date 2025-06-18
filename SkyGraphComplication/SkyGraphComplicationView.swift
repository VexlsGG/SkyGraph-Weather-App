import WidgetKit
import SwiftUI

struct SkyGraphComplicationView: View {
    var entry: SkyGraphEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .accessoryCircular:
            ZStack {
                Gauge(value: Double(entry.temp), in: 0...100) {}
                    .gaugeStyle(.accessoryCircular)
                    .tint(.orange)
                Text("\(entry.temp)°")
                    .font(.caption)
            }

        case .accessoryInline:
            Text("🌡 \(entry.temp)°  • AQI \(entry.aqi)")

        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: entry.icon)
                    Text("Now: \(entry.temp)°")
                        .font(.headline)
                }
                RainGraph(rainValues: entry.rainValues)
            }

        default:
            Text("SkyGraph")
        }
    }
}
