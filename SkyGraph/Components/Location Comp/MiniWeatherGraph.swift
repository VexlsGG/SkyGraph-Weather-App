import SwiftUI

struct MiniWeatherGraph: View {
    let data: [Int]
    var lineColor: Color = Color("Graph Line 1")

    var body: some View {
        GeometryReader { geo in
            let maxVal = data.max() ?? 1
            let minVal = data.min() ?? 0
            let height = geo.size.height
            let width = geo.size.width
            let points = data.enumerated().map { idx, val in
                CGPoint(
                    x: CGFloat(idx) / CGFloat(max(data.count - 1, 1)) * width,
                    y: height - CGFloat(val - minVal) / CGFloat(maxVal - minVal == 0 ? 1 : maxVal - minVal) * height
                )
            }
            Path { path in
                guard points.count > 1 else { return }
                path.move(to: points[0])
                for pt in points.dropFirst() {
                    path.addLine(to: pt)
                }
            }
            .stroke(lineColor, lineWidth: 2.5)
        }
        .frame(height: 28)
    }
}

#Preview {
    MiniWeatherGraph(data: [65, 67, 70, 72, 69, 68, 71, 73])
        .frame(width: 120, height: 28)
        .background(Color("Background"))
        .padding()
}
