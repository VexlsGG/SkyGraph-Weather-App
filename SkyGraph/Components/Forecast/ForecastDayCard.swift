import SwiftUI

struct ForecastDayModel: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let icon: String
    let high: Double
    let low: Double
    let summary: String
    let hourly: [Int]
}

struct ForecastDayCard: View {
    var day: ForecastDayModel
    @State private var showDetail = false

    var body: some View {
        Button(action: { showDetail = true }) {
            VStack(spacing: 8) {
                Image(systemName: day.icon)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(colors: [Color("Graph Line 1"), Color("Graph Line 2")], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .shadow(color: Color("Graph Line 1").opacity(0.2), radius: 4, y: 2)
                Text(day.date, style: .date)
                    .font(.headline)
                    .foregroundColor(Color("Text Primary"))
                HStack(spacing: 6) {
                    Text("\(Int(day.high))°")
                        .font(.subheadline.bold())
                        .foregroundColor(Color("Graph Line 1"))
                    Text("\(Int(day.low))°")
                        .font(.subheadline.bold())
                        .foregroundColor(Color("Graph Line 2"))
                }
                Text(day.summary)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("Text Secondary"))
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    GlassBackground(cornerRadius: 22)
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color("Card").opacity(0.6))
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color("Graph Line 1").opacity(0.15), lineWidth: 1.2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 22))
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showDetail) {
            ForecastDetailView(day: day)
        }
    }
}

struct ForecastDetailView: View {
    var day: ForecastDayModel
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Capsule()
                    .fill(Color.gray.opacity(0.25))
                    .frame(width: 46, height: 5)
                    .padding(.top, 8)
                Image(systemName: day.icon)
                    .font(.system(size: 60))
                    .foregroundStyle(
                        LinearGradient(colors: [Color("Graph Line 1"), Color("Graph Line 2")], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                Text(day.summary)
                    .font(.headline)
                    .foregroundColor(Color("Text Primary"))
                HourlyGraph(temps: day.hourly)
                    .frame(height: 80)
                    .padding(.horizontal)
                // Additional stats - replace with real data
                HStack {
                    StatMiniCard(icon: "drop.fill", value: "10%", label: "Rain", color: Color("Graph Line 1"))
                    StatMiniCard(icon: "wind", value: "8 mph", label: "Wind", color: Color("Graph Line 1"))
                }
            }
            .padding()
        }
        .background(Color("Background").ignoresSafeArea())
    }
}


