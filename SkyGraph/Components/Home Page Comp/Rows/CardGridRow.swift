import SwiftUI

struct CardGridRow<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        HStack(spacing: 16) {
            content()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    CardGridRow {
        WindMiniCard(speed: 12, directionDegrees: 315, directionLabel: "NW", gusts: 21)
        HumidityMiniCard(humidity: 50)
    }
    .padding()
    .background(Color("Background"))
}
