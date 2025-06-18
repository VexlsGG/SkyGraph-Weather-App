import SwiftUI

struct IconTempMiniWidget: View {
    var temp: Int
    var icon: String

    var body: some View {
        VStack(spacing: -4) {
            Image(systemName: icon)
                .font(.system(size: 14))
            Text("\(temp)°")
                .font(.caption2.bold())
        }
    }
}
