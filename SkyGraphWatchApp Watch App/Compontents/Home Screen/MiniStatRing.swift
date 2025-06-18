import SwiftUI

struct MiniStatRing: View {
    var precip: Int
    var wind: Int
    var aqi: Int

    var body: some View {
        HStack(spacing: 16) {
            stat(icon: "drop.fill", value: "\(precip)%")
            stat(icon: "wind", value: "\(wind)mph")
            stat(icon: "aqi.low", value: "AQI \(aqi)")
        }
        .font(.caption2)
        .foregroundColor(.secondary)
    }

    func stat(icon: String, value: String) -> some View {
        VStack {
            Image(systemName: icon)
            Text(value)
        }
    }
}
