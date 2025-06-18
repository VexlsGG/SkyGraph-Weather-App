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
