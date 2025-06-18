//
//  AQIRingWidget.swift
//  SkyGraph
//
//  Created by Lisa Oliver on 6/17/25.
//


import SwiftUI

struct AQIRingWidget: View {
    var aqi: Int

    var body: some View {
        Gauge(value: Double(aqi), in: 0...200) {
            Image(systemName: "lungs.fill")
        } currentValueLabel: {
            Text("\(aqi)")
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(aqi < 75 ? .green : aqi < 150 ? .yellow : .red)
    }
}
