//
//  RainRingWidget.swift
//  SkyGraph
//
//  Created by Lisa Oliver on 6/17/25.
//


import SwiftUI

struct RainRingWidget: View {
    var percent: Int

    var body: some View {
        ZStack {
            Gauge(value: Double(percent), in: 0...100) {
                Image(systemName: "cloud.rain.fill")
            } currentValueLabel: {
                Text("\(percent)%")
            }
            .gaugeStyle(.accessoryCircularCapacity)
            .tint(.blue)
        }
    }
}
