import SwiftUI

enum NavBarTab: Int, CaseIterable {
    case home, forecast, maps, ai, trash, settings

    var iconName: String {
        switch self {
        case .home: return "house"
        case .forecast: return "chart.line.uptrend.xyaxis"
        case .maps: return "map"
        case .ai: return "bubble.left.and.bubble.right"
        case .trash: return "trash"
        case .settings: return "gearshape"
        }
    }
    var accessibilityLabel: String {
        switch self {
        case .home: return "Home"
        case .forecast: return "Forecast"
        case .maps: return "Maps"
        case .ai: return "AI"
        case .trash: return "Trash"
        case .settings: return "Settings"
        }
    }
}

struct Navbar: View {
    @State private var animatePulse: Bool = false
    var activeTab: NavBarTab = .home
    var onTabChange: (NavBarTab) -> Void = { _ in }

    let cornerRadius: CGFloat = 44

    var body: some View {
        GeometryReader { geo in
            ZStack {
                BlurView(style: .systemUltraThinMaterialDark)
                    .background(
                        LinearGradient(
                            colors: [
                                Color("Graph Line 1").opacity(0.16),
                                Color("Graph Line 2").opacity(0.22),
                                Color("Background").opacity(0.90)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    .overlay(
                        ZStack {
                            Image(systemName: "cloud.fill")
                                .font(.system(size: 120, weight: .bold))
                                .foregroundColor(Color("Graph Line 1").opacity(0.07))
                                .offset(x: -60, y: 22)
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 60, weight: .bold))
                                .foregroundColor(Color("Graph Line 2").opacity(0.11))
                                .offset(x: 80, y: 12)
                        }
                    )
                    .shadow(color: Color("Graph Line 1").opacity(0.15), radius: 36, y: 0)
                    .shadow(color: Color.black.opacity(0.18), radius: 18, y: 6)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        Color("Graph Line 1"),
                                        Color("Graph Line 2"),
                                        Color("Graph Line 1")
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 2.2
                            )
                            .blur(radius: 0.3)
                    )

                HStack {
                    Circle().fill(Color("Graph Line 1").opacity(0.21))
                        .frame(width: 14, height: 14)
                        .offset(x: -120, y: -18)
                        .blur(radius: 0.6)
                    Spacer()
                    Circle().fill(Color("Graph Line 2").opacity(0.21))
                        .frame(width: 12, height: 12)
                        .offset(x: 70, y: 24)
                        .blur(radius: 0.7)
                }
                .padding(.horizontal, 34)

                HStack {
                    ForEach(NavBarTab.allCases, id: \.self) { tab in
                        Spacer()
                        Button(action: {
                            onTabChange(tab)
                            animatePulse = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                animatePulse = false
                            }
                        }) {
                            ZStack {
                                if activeTab == tab {
                                    // Pulsing 3D ring
                                    Circle()
                                        .strokeBorder(
                                            LinearGradient(
                                                colors: [
                                                    Color("Graph Line 1"),
                                                    Color("Graph Line 2")
                                                ],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            ),
                                            lineWidth: 6
                                        )
                                        .frame(width: 60, height: 60)
                                        .scaleEffect(animatePulse ? 1.13 : 1.0)
                                        .opacity(animatePulse ? 0.68 : 1)
                                        .shadow(color: Color("Graph Line 1").opacity(0.33), radius: 16, y: 0)
                                        .animation(.easeOut(duration: 0.24), value: animatePulse)
                                        .offset(y: -14)
                                        .blur(radius: animatePulse ? 0.7 : 0)
                                    Circle()
                                        .fill(
                                            RadialGradient(
                                                colors: [
                                                    Color("Graph Line 1").opacity(0.34),
                                                    Color("Graph Line 2").opacity(0.18),
                                                    Color.clear
                                                ],
                                                center: .center,
                                                startRadius: 8,
                                                endRadius: 34
                                            )
                                        )
                                        .frame(width: 60, height: 60)
                                        .offset(y: -14)
                                        .blur(radius: 0.8)
                                }
                                Image(systemName: tab.iconName)
                                    .font(.system(size: activeTab == tab ? 27 : 23, weight: .bold))
                                    .foregroundColor(activeTab == tab ? .white : Color("Text Secondary").opacity(0.86))
                                    .scaleEffect(activeTab == tab ? 1.22 : 1.0)
                                    .shadow(
                                        color: activeTab == tab ? Color("Graph Line 1").opacity(0.34) : .clear,
                                        radius: activeTab == tab ? 10 : 0, y: 1
                                    )
                                    .offset(y: activeTab == tab ? -14 : 0)
                                    .animation(.spring(response: 0.35, dampingFraction: 0.74), value: activeTab == tab)
                            }
                            .frame(width: 64, height: 64)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())
                        Spacer()
                    }
                }
                .padding(.top, 12)
                .padding(.bottom, 26)
            }
            .frame(width: geo.size.width, height: 104)
            .background(Color.clear)
            .position(x: geo.size.width / 2, y: geo.size.height - 52)
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemUltraThinMaterialDark
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

#Preview("SKYGRAPH DOOMSDAY BAR") {
    ZStack(alignment: .bottom) {
        LinearGradient(
            colors: [Color("Background"), Color("Card"), Color("Graph Line 2").opacity(0.11)],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        Navbar(activeTab: .home)
    }
}
