import SwiftUI

struct ForecastView: View {
    // Placeholder forecast data. Replace with API driven model
    let forecast: [ForecastDayModel] = (0..<14).map { i in
        ForecastDayModel(
            date: Calendar.current.date(byAdding: .day, value: i, to: Date())!,
            icon: ["cloud.fill","cloud.sun.fill","sun.max.fill","cloud.bolt.rain.fill"].randomElement()!,
            high: Double.random(in: 60...90),
            low: Double.random(in: 40...70),
            summary: "Partly cloudy",
            hourly: (0..<8).map { _ in Int.random(in: 50...90) }
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Forecast")
                    .font(.largeTitle.bold())
                    .foregroundColor(Color("Text Primary"))
                    .padding(.top, 12)

                DailyLineGraph(points: forecast.map { DailyForecastPoint(date: $0.date, high: $0.high, low: $0.low) })
                    .frame(height: 200)
                    .padding(.horizontal)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(forecast) { day in
                        ForecastDayCard(day: day)
                    }
                }
                .padding(.bottom, 40)
            }
            .padding(.horizontal)
        }
        .background(Color("Background").ignoresSafeArea())
    }
}

#Preview {
    ForecastView()
}
