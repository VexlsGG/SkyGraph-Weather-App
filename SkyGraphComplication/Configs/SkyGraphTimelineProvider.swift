import WidgetKit
import SwiftUI

struct SkyGraphIntentEntry: TimelineEntry {
    let date: Date
    let config: CircularStyleConfigurationIntent
    let temp: Int
    let aqi: Int
    let icon: String
    let rainValues: [Double]
}

struct SkyGraphIntentTimelineProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SkyGraphIntentEntry {
        SkyGraphIntentEntry(
            date: Date(),
            config: CircularStyleConfigurationIntent(style: .tempRing),
            temp: 84,
            aqi: 55,
            icon: "cloud.sun.fill",
            rainValues: Array(repeating: 0.4, count: 6)
        )
    }

    func getSnapshot(for configuration: CircularStyleConfigurationIntent, in context: Context, completion: @escaping (SkyGraphIntentEntry) -> ()) {
        completion(placeholder(in: context))
    }

    func getTimeline(for configuration: CircularStyleConfigurationIntent, in context: Context, completion: @escaping (Timeline<SkyGraphIntentEntry>) -> ()) {
        let entry = SkyGraphIntentEntry(
            date: Date(),
            config: configuration,
            temp: 84,
            aqi: 55,
            icon: "cloud.sun.fill",
            rainValues: Array(repeating: 0.3, count: 6)
        )
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(1800)))
        completion(timeline)
    }
}
