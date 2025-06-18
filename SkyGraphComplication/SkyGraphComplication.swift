import WidgetKit
import SwiftUI

@main
struct SkyGraphComplication: Widget {
    let kind: String = "SkyGraphComplication"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SkyGraphTimelineProvider()) { entry in
            SkyGraphComplicationView(entry: entry)
        }
        .configurationDisplayName("SkyGraph Complication")
        .description("Live weather, graphs, and AQI.")
        .supportedFamilies([
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryInline,
        ])
    }
}
