import SwiftUI

struct TempLineGraph: View {
    var values: [Double]

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let maxVal = values.max() ?? 1
            let minVal = values.min() ?? 0
            let range = max(maxVal - minVal, 1)

            let points = values.enumerated().map { (i, val) in
                CGPoint(
                    x: CGFloat(i) / CGFloat(values.count - 1) * width,
                    y: height - ((val - minVal) / range * height)
                )
            }

            Path { path in
                guard let first = points.first else { return }
                path.move(to: first)
                for pt in points.dropFirst() {
                    path.addLine(to: pt)
                }
            }
            .stroke(Color.orange, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }
}
