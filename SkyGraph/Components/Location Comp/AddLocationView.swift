import SwiftUI

struct AddLocationOverlay: View {
    @Binding var show: Bool
    var onAdd: (LocationDisplay) -> Void

    @State private var city: String = ""
    @State private var temp: String = ""
    @State private var condition: String = ""
    @State private var icon: String = ""
    @State private var alertTitle: String = ""
    @State private var isUserLocation: Bool = false

    var body: some View {
        if show {
            ZStack {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)
                VStack(spacing: 0) {
                    VStack(spacing: 18) {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(.ultraThinMaterial)
                            .frame(height: 12)
                            .frame(maxWidth: 60)
                            .padding(.top, 20)
                            .opacity(0.3)
                        Text("Add Location")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(Color("Text Primary"))
                        TextField("City Name", text: $city)
                            .glassTextField()
                        TextField("Temperature", text: $temp)
                            .keyboardType(.numberPad)
                            .glassTextField()
                        TextField("Condition", text: $condition)
                            .glassTextField()
                        TextField("SF Symbol for Icon", text: $icon)
                            .glassTextField()
                        Toggle("Set as My Location", isOn: $isUserLocation)
                            .toggleStyle(SwitchToggleStyle(tint: Color("Graph Line 1")))
                            .padding(.horizontal)
                        TextField("Alert Title (optional)", text: $alertTitle)
                            .glassTextField()
                        if let tempInt = Int(temp), !city.isEmpty {
                            LocationWeatherCard(
                                location: LocationModel(
                                    city: city,
                                    temp: tempInt,
                                    condition: condition.isEmpty ? "Clear" : condition,
                                    weatherIconName: icon.isEmpty ? "sun.max.fill" : icon,
                                    hourlyTemps: Array(repeating: tempInt, count: 8)
                                ),
                                isActive: false,
                                isUserLocation: isUserLocation,
                                alertTitle: alertTitle.isEmpty ? nil : alertTitle,
                                trend: .neutral,
                                animateAlert: !alertTitle.isEmpty,
                                expand: false,
                                cardStyle: .glass
                            )
                                .padding(.top, 8)
                                .scaleEffect(0.92)
                        }
                        HStack(spacing: 18) {
                            Button("Cancel") {
                                withAnimation(.spring()) { show = false }
                            }
                            .buttonStyle(GlassActionButtonStyle())
                            Button("Add") {
                                if let tempInt = Int(temp), !city.isEmpty {
                                    let newLocation = LocationDisplay(
                                        model: LocationModel(
                                            city: city,
                                            temp: tempInt,
                                            condition: condition.isEmpty ? "Clear" : condition,
                                            weatherIconName: icon.isEmpty ? "sun.max.fill" : icon,
                                            hourlyTemps: Array(repeating: tempInt, count: 8)
                                        ),
                                        isUserLocation: isUserLocation,
                                        alertTitle: alertTitle.isEmpty ? nil : alertTitle,
                                        cardStyle: .glass
                                    )
                                    onAdd(newLocation)
                                    withAnimation(.spring()) { show = false }
                                }
                            }
                            .buttonStyle(GlassActionButtonStyle())
                            .disabled(city.isEmpty || temp.isEmpty)
                        }
                        .padding(.vertical, 12)
                    }
                    .padding(.horizontal, 28)
                    .background(
                        RoundedRectangle(cornerRadius: 32)
                            .fill(.ultraThinMaterial)
                            .shadow(color: Color("Graph Line 1").opacity(0.08), radius: 20, x: 0, y: 10)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 40)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(2)
            }
            .animation(.spring(response: 0.36, dampingFraction: 0.86), value: show)
        }
    }
}

extension View {
    func glassTextField() -> some View {
        self
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14).stroke(Color("Graph Line 2").opacity(0.13), lineWidth: 1.2)
            )
            .foregroundColor(Color("Text Primary"))
            .padding(.horizontal, 2)
    }
}

struct GlassActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(Color("Text Primary"))
            .padding(.horizontal, 18)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 14).fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14).stroke(Color("Graph Line 1"), lineWidth: 1.2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

#Preview {
    AddLocationOverlay(show: .constant(true)) { _ in }
        .background(Color("Background").ignoresSafeArea())
}
