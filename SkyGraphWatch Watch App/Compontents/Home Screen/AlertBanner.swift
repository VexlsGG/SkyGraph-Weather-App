import SwiftUI

struct AlertBanner: View {
    var alert: Alert

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(alert.title)
                .font(.headline)
                .foregroundColor(.yellow)
            Text(alert.description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.red.opacity(0.15))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
