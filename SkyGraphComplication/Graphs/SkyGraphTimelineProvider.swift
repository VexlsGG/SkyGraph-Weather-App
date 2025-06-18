//
//  SkyGraphEntry.swift
//  SkyGraph
//
//  Created by Lisa Oliver on 6/17/25.
//


import WidgetKit
import SwiftUI

struct SkyGraphEntry: TimelineEntry {
    let date: Date
    let temp: Int
    let aqi: Int
    let icon: String
    let rainValues: [Double]
}

struct SkyGraphTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> SkyGraphEntry {
        SkyGraphEntry(date: Date(), temp: 84, aqi: 55, icon: "cloud.sun.fill", rainValues: Array(repeating: 0.4, count: 12))
    }

    func getSnapshot(in context: Context, completion: @escaping (SkyGraphEntry) -> ()) {
        let entry = placeholder(in: context)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SkyGraphEntry>) -> ()) {
        let entry = SkyGraphEntry(
            date: Date(),
            temp: 84,
            aqi: 55,
            icon: "cloud.sun.fill",
            rainValues: (0..<12).map { _ in Double.random(in: 0...1) }
        )
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(1800)))
        completion(timeline)
    }
}
