import SwiftUI

/// Simple line graph used for hourly temps
struct HourlyGraph: View {
    let temps: [Int]

    var body: some View {
        GeometryReader { geo in
            let points = temps.enumerated().map { idx, temp in
                CGPoint(
                    x: geo.size.width * CGFloat(idx) / CGFloat(max(temps.count - 1, 1)),
                    y: geo.size.height - (geo.size.height * CGFloat(temp - (temps.min() ?? 0)) / CGFloat(max((temps.max() ?? 1) - (temps.min() ?? 0), 1)))
                )
            }
            Path { path in
                if points.count > 1 {
                    path.move(to: points.first!)
                    for pt in points.dropFirst() {
                        path.addLine(to: pt)
                    }
                }
            }
            .stroke(
                LinearGradient(colors: [Color("Graph Line 1"), Color("Graph Line 2")], startPoint: .topLeading, endPoint: .bottomTrailing),
                style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round)
            )
            ForEach(Array(points.enumerated()), id: \.offset) { i, pt in
                Circle()
                    .fill(
                        LinearGradient(colors: [Color("Graph Line 1"), Color("Graph Line 2")], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 9, height: 9)
                    .position(pt)
            }
        }
    }
}
