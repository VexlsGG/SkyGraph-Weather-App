import SwiftUI

struct HomePageView: View {
    @Binding var showLocations: Bool
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 28) {
                WeatherHeader(showLocations: $showLocations)
                AlertCard(
                    alertTitle: "Air Quality Alert",
                    severity: "Moderate",
                    summary: "Air Quality is not suitable for certain groups.",
                    area: "Belleville, MI",
                    sender: "National Weather Service",
                    event: "AQ",
                    starts: Date(),
                    ends: Calendar.current.date(byAdding: .hour, value: 2, to: Date())!,
                    description: """
HAZARD...N/A.
SOURCE...N/A.
IMPACT...N/A.
"""
                )
                TemperatureGraphCard()
                ForecastRow()
                
                // 1st row: Wind & Humidity
                CardGridRow {
                    WindMiniCard(speed: 7, directionDegrees: 54, directionLabel: "NE", gusts: 11)
                    HumidityMiniCard(humidity: 82)
                }
                
                // 2nd row: UV & Air Quality
                CardGridRow {
                    UVIndexMiniCard(uv: 4)
                    AirQualityMiniCard(aqi: 144, level: "Unhealthy")
                }
                
                
                let formatter: DateFormatter = {
                    let f = DateFormatter()
                    f.dateFormat = "yyyy-MM-dd HH:mm"
                    return f
                }()
                
                let sunriseDate = formatter.date(from: "2025-06-05 05:58")!
                let sunsetDate = formatter.date(from: "2025-06-04 21:06")!
                
                // 3rd row: Sunrise & Sunset
                SunProgressCard(
                    sunrise: sunriseDate,
                    sunset: sunsetDate,
                    now: Date()
                )
                
                
                // Full-width cards
                RadarCard()
                Spacer(minLength: 30)
            }
            .padding(.horizontal, 22)
            .padding(.top, 28)
            .padding(.bottom, 48)
        }
        .background(Color("Background").ignoresSafeArea())
        .refreshable { }
    }
}
#Preview {
    HomePageView(showLocations: .constant(false))
}
