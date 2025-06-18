import SwiftUI

struct Alert: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let severity: AlertSeverity
    let startTime: String
    let endTime: String
}

enum AlertSeverity {
    case warning, watch, advisory, emergency

    var color: Color {
        switch self {
        case .warning: return .orange
        case .watch: return .yellow
        case .advisory: return .blue
        case .emergency: return .red
        }
    }

    var label: String {
        switch self {
        case .warning: return "Warning"
        case .watch: return "Watch"
        case .advisory: return "Advisory"
        case .emergency: return "Emergency"
        }
    }

    var icon: String {
        switch self {
        case .warning: return "exclamationmark.triangle.fill"
        case .watch: return "eye.fill"
        case .advisory: return "info.circle.fill"
        case .emergency: return "bolt.fill"
        }
    }
}

struct AlertPillBanner: View {
    let alert: Alert
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Image(systemName: alert.severity.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(alert.severity.color)
                Text(alert.title)
                    .font(.system(size: 13, weight: .semibold))
                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(alert.severity.color.opacity(0.15))
                    .overlay(
                        Capsule()
                            .stroke(alert.severity.color.opacity(0.45), lineWidth: 1.2)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
