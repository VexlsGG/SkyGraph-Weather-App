//
//  CircularStyleConfigurationIntent.swift
//  SkyGraph
//
//  Created by Lisa Oliver on 6/17/25.
//


import AppIntents

struct CircularStyleConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Circular Style Configuration"
    static var description = IntentDescription("Select a style for your SkyGraph circular complication.")

    @Parameter(title: "Widget Style")
    var style: CircularWidgetStyle
}
