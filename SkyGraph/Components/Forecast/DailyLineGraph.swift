import SwiftUI
import Charts

struct DailyForecastPoint: Identifiable {
    let id = UUID()
    let date: Date
    let high: Double
    let low: Double
}

struct DailyLineGraph: View {
    var points: [DailyForecastPoint]

    var body: some View {
        Chart {
            ForEach(points) { point in
                LineMark(
                    x: .value("Day", point.date),
                    y: .value("High", point.high)
                )
                .foregroundStyle(Color("Graph Line 1"))
                LineMark(
                    x: .value("Day", point.date),
                    y: .value("Low", point.low)
                )
                .foregroundStyle(Color("Graph Line 2"))
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
    }
}
