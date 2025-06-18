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
