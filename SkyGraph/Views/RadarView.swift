import SwiftUI
import MapKit

struct RadarView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.334_900, longitude: -122.009_020),
        span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
    )

    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $region)
                .overlay(
                    // Radar overlay placeholder. Replace with live tiles
                    Image("radar_sample")
                        .resizable()
                        .scaledToFill()
                        .opacity(0.6)
                )
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 6) {
                Text("San Francisco")
                    .font(.headline)
                    .foregroundColor(Color("Text Primary"))
                Text("72° Partly Cloudy")
                    .font(.title2.bold())
                    .foregroundStyle(
                        LinearGradient(colors: [Color("Graph Line 1"), Color("Graph Line 2")], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    GlassBackground(cornerRadius: 24)
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color("Card").opacity(0.6))
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color("Graph Line 1").opacity(0.2), lineWidth: 1.4)
            )
            .padding()
        }
    }
}

#Preview {
    RadarView()
}
