import SwiftUI

struct AlertCard: View {
    var alertTitle: String
    var severity: String
    var summary: String
    var area: String
    var sender: String
    var event: String
    var starts: Date
    var ends: Date
    var description: String
    
    var alertColor: Color {
        switch severity.lowercased() {
        case "extreme", "severe", "warning": return .red
        case "watch", "moderate": return .yellow
        case "advisory", "minor": return .orange
        default: return Color("Graph Line 1")
        }
    }
    
    @State private var showInfo = false
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.45)) { isPressed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                withAnimation(.spring()) { isPressed = false }
                showInfo = true
            }
        }) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                alertColor.opacity(0.18),
                                Color("Card").opacity(0.94)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .background(.ultraThinMaterial)
                    .shadow(color: alertColor.opacity(0.09), radius: 7, y: 3)
                HStack(alignment: .top, spacing: 0) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(alertColor)
                        .frame(width: 10)
                        .padding(.vertical, 8)
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.title)
                                .foregroundColor(alertColor)
                                .shadow(color: .black.opacity(0.08), radius: 3)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(alertTitle)
                                    .font(.headline.weight(.bold))
                                    .foregroundColor(alertColor)
                                Text(severity.uppercased())
                                    .font(.caption.bold())
                                    .foregroundColor(alertColor.opacity(0.84))
                                    .padding(.vertical, 1)
                                    .padding(.horizontal, 7)
                                    .background(alertColor.opacity(0.17))
                                    .clipShape(Capsule())
                            }
                            Spacer()
                        }
                        Text(summary)
                            .font(.subheadline)
                            .foregroundColor(Color("Text Primary"))
                            .lineLimit(2)
                        Text(area)
                            .font(.caption)
                            .foregroundColor(Color("Text Secondary"))
                            .padding(.top, 2)
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 12)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 110)
            .scaleEffect(isPressed ? 0.96 : 1)
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(alertColor.opacity(0.15), lineWidth: 1.6)
            )
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showInfo) {
            AlertDetailSheet(
                alertTitle: alertTitle,
                severity: severity,
                event: event,
                starts: starts,
                ends: ends,
                area: area,
                sender: sender,
                summary: summary,
                description: description,
                alertColor: alertColor
            )
        }
    }
}

struct AlertDetailSheet: View {
    var alertTitle: String
    var severity: String
    var event: String
    var starts: Date
    var ends: Date
    var area: String
    var sender: String
    var summary: String
    var description: String
    var alertColor: Color

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Capsule()
                    .fill(Color.gray.opacity(0.25))
                    .frame(width: 46, height: 5)
                    .padding(.top, 10)
                    .padding(.bottom, 8)
                    .frame(maxWidth: .infinity, alignment: .center)
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.largeTitle)
                        .foregroundColor(alertColor)
                    VStack(alignment: .leading) {
                        Text(alertTitle)
                            .font(.title3.bold())
                            .foregroundColor(alertColor)
                        Text(severity.uppercased())
                            .font(.headline.bold())
                            .foregroundColor(alertColor.opacity(0.85))
                            .padding(.vertical, 2)
                            .padding(.horizontal, 9)
                            .background(alertColor.opacity(0.17))
                            .clipShape(Capsule())
                    }
                }
                Divider().padding(.vertical, 6)
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Start")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(dateTimeString(starts))
                            .font(.body.weight(.semibold))
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("End")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(dateTimeString(ends))
                            .font(.body.weight(.semibold))
                    }
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text("Event").font(.caption2).foregroundColor(.secondary)
                        Text(event).font(.body.weight(.semibold))
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Issued by").font(.caption2).foregroundColor(.secondary)
                        Text(sender).font(.body.weight(.semibold))
                    }
                }
                Divider().padding(.vertical, 4)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Area").font(.caption2).foregroundColor(.secondary)
                    Text(area).font(.body)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Summary").font(.caption2).foregroundColor(.secondary)
                    Text(summary)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Details").font(.caption2).foregroundColor(.secondary)
                    Text(description)
                        .font(.body)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
            }
            .padding(.horizontal, 22)
            .padding(.bottom, 20)
        }
        .background(
            LinearGradient(
                colors: [alertColor.opacity(0.09), Color("Background")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }

    func dateTimeString(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .short
        return f.string(from: date)
    }
}

#Preview {
    AlertCard(
        alertTitle: "Severe Thunderstorm Warning",
        severity: "Severe",
        summary: "60 mph wind gusts, quarter-size hail possible.",
        area: "Lucas County, OH",
        sender: "National Weather Service Cleveland",
        event: "Severe Thunderstorm",
        starts: Date(),
        ends: Calendar.current.date(byAdding: .hour, value: 2, to: Date())!,
        description: """
HAZARD...60 mph wind gusts and quarter size hail.
SOURCE...Radar indicated.
IMPACT...Expect damage to roofs, siding, and trees.
"""
    )
    .padding()
    .background(Color("Background"))
}
