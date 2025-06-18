import SwiftUI

struct ScrollableWeatherGraph: View {
    let hours: [HourForecast]
    @Binding var selectedHour: Int
    @Binding var selectedType: Int
    let graphColor: Color

    var valueKey: KeyPath<HourForecast, Double> {
        switch selectedType {
        case 1: return \.feelsLike
        case 2: return \.precip
        default: return \.temp
        }
    }

    var unit: String {
        selectedType == 2 ? "%" : "°"
    }

    var body: some View {
        let itemWidth: CGFloat = 52
        let totalWidth = CGFloat(hours.count) * itemWidth
        let values = hours.map { $0[keyPath: valueKey] }
        let minVal = values.min() ?? 0
        let maxVal = values.max() ?? 1
        let range = maxVal - minVal == 0 ? 1 : maxVal - minVal

        ScrollView(.horizontal, showsIndicators: false) {
            ZStack {
                Path { path in
                    for idx in hours.indices {
                        let x = CGFloat(idx) * itemWidth + itemWidth / 2
                        let y = 70 - (60 * CGFloat((values[idx] - minVal) / range))
                        if idx == 0 { path.move(to: CGPoint(x: x, y: y)) }
                        else { path.addLine(to: CGPoint(x: x, y: y)) }
                    }
                }
                .stroke(graphColor, style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                .shadow(radius: 2)

                ForEach(Array(hours.enumerated()), id: \.1.id) { idx, hour in
                    let x = CGFloat(idx) * itemWidth + itemWidth / 2
                    let y = 70 - (60 * CGFloat((hour[keyPath: valueKey] - minVal) / range))

                    VStack(spacing: 2) {
                        Text("\(Int(hour[keyPath: valueKey]))\(unit)")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(selectedHour == idx ? graphColor : .primary)
                        Image(systemName: hour.icon)
                            .font(.system(size: 18))
                            .foregroundColor(selectedHour == idx ? graphColor : .primary)
                            .shadow(radius: selectedHour == idx ? 3 : 0)
                        Text(hour.hour)
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }
                    .frame(width: itemWidth)
                    .contentShape(Rectangle())
                    .position(x: x, y: y - 19)
                    .onTapGesture {
                        withAnimation { selectedHour = idx }
                    }
                }
            }
            .frame(width: totalWidth, height: 92)
        }
        .frame(height: 92)
    }
}
