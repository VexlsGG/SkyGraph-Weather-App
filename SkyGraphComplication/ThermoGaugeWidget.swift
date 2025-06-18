import SwiftUI

struct ThermoGaugeWidget: View {
    var temp: Int

    var body: some View {
        Gauge(value: Double(temp), in: 0...100) {
            Image(systemName: "thermometer")
        } currentValueLabel: {
            Text("\(temp)°")
                .font(.caption2)
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(Gradient(colors: [.yellow, .orange, .red]))
    }
}
