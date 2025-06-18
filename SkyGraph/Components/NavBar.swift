import SwiftUI
import UIKit
import Combine

enum WeatherType: String, CaseIterable, Identifiable {
    case sun, rain, thunder, snow, cloudy, fog, night, tornado
    var id: String { rawValue }
}

func weatherAccent(for type: WeatherType) -> Color {
    switch type {
    case .sun:      return Color.yellow
    case .rain:     return Color.blue
    case .thunder:  return Color.purple
    case .snow:     return Color.cyan
    case .cloudy:   return Color.gray
    case .fog:      return Color.gray.opacity(0.8)
    case .night:    return Color.black
    case .tornado:  return Color.red
    }
}

func weatherGradient(for type: WeatherType, superMode: Bool = false) -> LinearGradient {
    let accent = weatherAccent(for: type)
    let color2 = superMode ? accent : accent.opacity(0.22)
    let color3 = superMode ? .white : Color.white.opacity(0.18)
    return LinearGradient(
        colors: [accent, color2, color3],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct NavBarTabItem: Identifiable, Hashable {
    let id: String
    let icon: String
    let accessibility: String
    let badge: Int?
    let isCenter: Bool
    let haptic: UIImpactFeedbackGenerator.FeedbackStyle?
    init(id: String, icon: String, accessibility: String, badge: Int? = nil, isCenter: Bool = false, haptic: UIImpactFeedbackGenerator.FeedbackStyle? = nil) {
        self.id = id
        self.icon = icon
        self.accessibility = accessibility
        self.badge = badge
        self.isCenter = isCenter
        self.haptic = haptic
    }
}

enum NavBarTab: String, CaseIterable, Identifiable {
    case home, forecast, ai, settings
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .home: return "house"
        case .forecast: return "chart.line.uptrend.xyaxis"
        case .ai: return "bubble.left.and.bubble.right"
        case .settings: return "gearshape"
        }
    }
    var accessibility: String {
        switch self {
        case .home: return "Home"
        case .forecast: return "Forecast"
        case .ai: return "AI"
        case .settings: return "Settings"
        }
    }
    var toItem: NavBarTabItem {
        .init(id: id, icon: icon, accessibility: accessibility)
    }
}

struct QuickAction: Identifiable {
    let id = UUID()
    let label: String
    let icon: String
    let action: () -> Void
}
struct QuickActionsSheet: View {
    let actions: [QuickAction]
    var body: some View {
        VStack(spacing: 0) {
            Capsule().fill(Color.secondary.opacity(0.2)).frame(width: 36, height: 6).padding(.top, 10)
            Text("Quick Actions")
                .font(.headline)
                .padding(.vertical, 18)
            ForEach(actions) { action in
                Button {
                    action.action()
                } label: {
                    HStack {
                        Image(systemName: action.icon)
                            .font(.system(size: 21, weight: .bold))
                        Text(action.label)
                            .font(.system(size: 17, weight: .medium))
                        Spacer()
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground).opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            Spacer()
        }
    }
}

struct Navbar: View {
    @Binding var selected: String
    var tabs: [NavBarTabItem]
    var weatherType: WeatherType
    var autoHideDelay: Double = 3.0

    @State private var showAchievements = false
    @State private var useDark = false
    @State private var useMetric = false
    @State private var showSupportAlert = false

    @Environment(\.colorScheme) private var scheme
    @State private var visible: Bool = true
    @State private var hideTask: DispatchWorkItem?
    @Namespace private var highlightNS
    @GestureState private var dragOffset: CGFloat = 0
    @State private var showQuickActions = false
    @AppStorage("hasSeenDockedTip") private var hasSeenDockedTip: Bool = false
    @State private var showPsst: Bool = false
    @State private var arrowGlow: Bool = false

    @State private var iconFrames: [String: CGRect] = [:]
    @State private var liquidDotID: String? = nil
    @State private var transitioningTo: String? = nil

    @State private var showWidget: Bool = false
    @State private var longPresses: Int = 0
    @State private var showEasterEgg: Bool = false
    @State private var showFirstUnlockAnimation = false
    @AppStorage("easterEggHunterUnlocked") private var easterEggHunterUnlocked: Bool = false

    private func fireHaptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let gen = UIImpactFeedbackGenerator(style: style)
        gen.impactOccurred()
    }

    
    private func resetHideTimer() {
        hideTask?.cancel()
        visible = true
        let task = DispatchWorkItem {
            withAnimation(.interpolatingSpring(stiffness: 190, damping: 19)) {
                visible = false
            }
            if !hasSeenDockedTip {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    showPsst = true
                    hasSeenDockedTip = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
                        withAnimation { showPsst = false }
                    }
                }
            }
        }
        hideTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + autoHideDelay, execute: task)
    }

    private func moveTab(direction: Int) {
        guard let idx = tabs.firstIndex(where: { $0.id == selected }) else { return }
        let newIdx = (idx + direction + tabs.count) % tabs.count
        let tab = tabs[newIdx]
        fireHaptic(tab.haptic ?? .medium)
        animateLiquidDot(from: selected, to: tab.id)
        withAnimation(.spring(response: 0.36, dampingFraction: 0.7)) { selected = tab.id }
        resetHideTimer()
    }

    private var quickActions: [QuickAction] {
        [
            .init(label: "Add Location", icon: "plus") {
                fireHaptic(.medium)
                print("Add Location triggered")
            },
            .init(label: "Toggle Theme", icon: "moon.stars") {
                fireHaptic(.light)
                useDark.toggle()
                print("Theme toggled (simulate; wire to real theme in app)")
            },
            .init(label: "Switch Units", icon: "thermometer") {
                fireHaptic(.soft)
                useMetric.toggle()
                print("Units toggled (simulate; wire to real units in app)")
            },
            .init(label: "Achievements & Easter Eggs", icon: "star.fill") {
                fireHaptic(.medium)
                showAchievements = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.32) {
                    showAchievements = true
                }
            },
            .init(label: "Support / Send Feedback", icon: "envelope") {
                fireHaptic(.medium)
                showSupportAlert = true
            },
            .init(label: "Refresh Weather", icon: "arrow.clockwise") {
                fireHaptic(.rigid)
                print("Weather refreshed")
            }
        ]
    }

    private func animateLiquidDot(from oldID: String, to newID: String) {
        transitioningTo = newID
        liquidDotID = oldID
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
            liquidDotID = nil
            transitioningTo = nil
        }
    }

    @State private var keyboardCancellable: AnyCancellable?
    private func monitorKeyboard() {
        keyboardCancellable?.cancel()
        keyboardCancellable = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { _ in
                withAnimation(.interpolatingSpring(stiffness: 210, damping: 18)) {
                    visible = false
                }
            }
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomLeading) {
                NavigationLink(
                    destination: AchievementsPageView(achievements: AchievementsPageView.defaultAchievements),
                    isActive: $showAchievements
                ) {
                    EmptyView()
                }
                .hidden()
                
                if showEasterEgg {
                    EasterEggOverlay(
                        dismiss: { showEasterEgg = false },
                        mainIcon: "sparkles", // Or "egg.fill", etc
                        mainTitle: "🌈 Secret Mode Unlocked!",
                        bodyText: "You found the Easter Egg! 🎉\nEnjoy this hidden secret.",
                    )
                    .zIndex(3)
                }

                
                if showFirstUnlockAnimation {
                    FirstUnlockEffectView()
                        .zIndex(4)
                        .transition(.scale.combined(with: .opacity))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showFirstUnlockAnimation = false
                                }
                            }
                        }
                }

                VStack {
                    Spacer()
                    ZStack {
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .overlay(
                                Capsule()
                                    .fill(weatherGradient(for: weatherType).opacity(0.18))
                            )
                            .overlay(
                                Capsule()
                                    .strokeBorder(
                                        LinearGradient(colors: [
                                            .white.opacity(0.29),
                                            .white.opacity(0.11)
                                        ], startPoint: .top, endPoint: .bottom),
                                        lineWidth: 2.8
                                    )
                            )
                            .shadow(color: weatherAccent(for: weatherType).opacity(0.13), radius: 30, y: 8)
                            .shadow(color: .white.opacity(0.07), radius: 12, y: -1)
                        Capsule()
                            .strokeBorder(
                                AngularGradient(
                                    gradient: Gradient(colors: [.pink, .orange, .yellow, .green, .blue, .purple, .pink]),
                                    center: .center
                                ),
                                lineWidth: 1.4
                            )
                                .blur(radius: 6)
                                .opacity(0.11)
                        if let liquidID = liquidDotID,
                           let oldFrame = iconFrames[liquidID],
                           let toID = transitioningTo,
                           let newFrame = iconFrames[toID]
                        {
                            LiquidDotOverlay(
                                from: oldFrame, to: newFrame, color: weatherAccent(for: weatherType), morph: true
                            )
                            .animation(.interpolatingSpring(stiffness: 380, damping: 22), value: transitioningTo)
                            .allowsHitTesting(false)
                        }
                        HStack(spacing: 0) {
                            ForEach(tabs, id: \.id) { tab in
                                Spacer(minLength: 0)
                                TabIcon(
                                    tab: tab,
                                    selected: selected,
                                    accent: weatherAccent(for: weatherType),
                                    onFrameChange: { frame in
                                        iconFrames[tab.id] = frame
                                    }
                                ) {
                                    fireHaptic(tab.haptic ?? .light)
                                    animateLiquidDot(from: selected, to: tab.id)
                                    withAnimation(.spring(response: 0.33, dampingFraction: 0.75)) {
                                        selected = tab.id
                                    }
                                    resetHideTimer()
                                }
                                Spacer(minLength: 0)
                            }
                        }
                        .padding(.horizontal, 10)
                        .frame(height: 65)
                    }
                    .frame(width: geo.size.width * 0.97, height: 68)
                    .opacity(visible ? 1 : 0)
                    .offset(x: visible ? 0 : -geo.size.width * 1.2, y: 0)
                    .scaleEffect(visible ? 1.0 : 0.93, anchor: .leading)
                    .animation(.interpolatingSpring(stiffness: 200, damping: 17), value: visible)
                    .gesture(
                        DragGesture(minimumDistance: 8)
                            .onEnded { value in
                                if abs(value.translation.width) > 32 && abs(value.translation.width) > abs(value.translation.height) {
                                    let dir = value.translation.width > 0 ? 1 : -1
                                    fireHaptic(.soft)
                                    moveTab(direction: dir)
                                }
                                else if value.translation.height > 28 && abs(value.translation.height) > abs(value.translation.width) {
                                    fireHaptic(.rigid)
                                    withAnimation(.interpolatingSpring(stiffness: 210, damping: 20)) {
                                        visible = false
                                    }
                                    hideTask?.cancel()
                                    if !hasSeenDockedTip {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            showPsst = true
                                            hasSeenDockedTip = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
                                                withAnimation { showPsst = false }
                                            }
                                        }
                                    }
                                }
                            }
                    )
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded {
                                fireHaptic(.medium)
                                withAnimation(.spring()) { showWidget.toggle() }
                                resetHideTimer()
                            }
                    )
                    .onAppear {
                        resetHideTimer()
                        monitorKeyboard()
                    }
                    .onChange(of: selected) {
                        resetHideTimer()
                    }
                    .onChange(of: visible) { val in
                        if val { longPresses = 0 }
                    }
                    .padding(.bottom, 28)
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .bottom)
                .ignoresSafeArea(.container, edges: .bottom)

                if !visible {
                    ZStack(alignment: .bottomLeading) {
                        Button {
                            fireHaptic(.rigid)
                            withAnimation(.interpolatingSpring(stiffness: 210, damping: 20)) {
                                visible = true
                            }
                            resetHideTimer()
                        } label: {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.system(size: 30, weight: .bold))
                                        .foregroundColor(weatherAccent(for: weatherType))
                                        .shadow(color: arrowGlow ? weatherAccent(for: weatherType).opacity(0.65) : .clear, radius: 16, y: 0)
                                        .scaleEffect(arrowGlow ? 1.10 : 1.0)
                                        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: arrowGlow)
                                )
                                .shadow(color: weatherAccent(for: weatherType).opacity(0.21), radius: 14, y: 2)
                                .overlay(
                                    Circle()
                                        .stroke(weatherAccent(for: weatherType).opacity(0.75), lineWidth: 1.8)
                                        .blur(radius: 2)
                                )
                                .padding(.leading, 16)
                                .padding(.bottom, 26)
                        }
                        .offset(x: 0, y: 0)
                        .transition(.move(edge: .leading).combined(with: .opacity))
                        .animation(.interpolatingSpring(stiffness: 180, damping: 16), value: visible)
                        .onAppear { arrowGlow = true }
                        .onDisappear { arrowGlow = false }

                        if showPsst {
                            HStack(spacing: 6) {
                                Image(systemName: "hand.tap.fill")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(weatherAccent(for: weatherType))
                                Text("Psst! Tap the arrow to show the NavBar")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.primary)
                                    .padding(.vertical, 8)
                            }
                            .padding(.horizontal, 18)
                            .background(
                                Capsule()
                                    .fill(Color(.systemBackground).opacity(0.89))
                                    .shadow(color: weatherAccent(for: weatherType).opacity(0.12), radius: 12, y: 4)
                            )
                            .offset(x: 84, y: -90)
                            .transition(.move(edge: .leading).combined(with: .opacity))
                            .onTapGesture {
                                withAnimation { showPsst = false }
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showQuickActions) {
                QuickActionsSheet(actions: quickActions)
                    .presentationDetents([.medium])
            }
            .alert("Send Feedback", isPresented: $showSupportAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Support/Feedback action triggered.")
            }
            .onChange(of: showWidget) { val in
                if val { fireHaptic(.soft) }
            }
            .simultaneousGesture(
                TapGesture(count: 3)
                    .onEnded {
                        withAnimation(.spring()) {
                            showEasterEgg = true
                        }
                        if !easterEggHunterUnlocked {
                            easterEggHunterUnlocked = true
                            showFirstUnlockAnimation = true
                        }
                    }
            )
            .highPriorityGesture(
                LongPressGesture(minimumDuration: 0.7)
                    .onEnded { _ in
                        fireHaptic(.medium)
                        showQuickActions = true
                        resetHideTimer()
                    }
            )

        }
    }
}

struct LiquidDotOverlay: View {
    let from: CGRect
    let to: CGRect
    let color: Color
    var morph: Bool = true

    var body: some View {
        let centerY = (from.midY + to.midY) / 2
        let minX = min(from.midX, to.midX)
        let maxX = max(from.midX, to.midX)
        let width = abs(from.midX - to.midX) + from.width * 0.88
        let diameter = max(from.height, to.height) * 1.12
        let x = minX

        ZStack {
            Capsule()
                .fill(color.opacity(0.15))
                .frame(width: width, height: diameter * 0.98)
                .position(x: x + width/2, y: centerY)
            Capsule()
                .fill(color.opacity(0.39))
                .blur(radius: 6)
                .frame(width: width * 0.86, height: diameter * 0.66)
                .position(x: x + width/2, y: centerY)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [color.opacity(0.62), color.opacity(0.09)],
                        center: .center, startRadius: 6, endRadius: diameter * 0.6
                    )
                )
                .frame(width: diameter * 0.95, height: diameter * 0.95)
                .position(x: from.midX, y: from.midY)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [color.opacity(0.44), .clear],
                        center: .center, startRadius: 8, endRadius: diameter * 0.6
                    )
                )
                .frame(width: diameter * 0.68, height: diameter * 0.68)
                .position(x: to.midX, y: to.midY)
        }
        .allowsHitTesting(false)
    }
}

struct TabIcon: View {
    let tab: NavBarTabItem
    let selected: String
    let accent: Color
    let onFrameChange: (CGRect) -> Void
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            VStack(spacing: 2) {
                GeometryReader { geo in
                    Image(systemName: tab.icon)
                        .font(.system(size: 27, weight: .semibold))
                        .foregroundColor(
                            selected == tab.id
                                ? accent
                                : .primary.opacity(0.78)
                        )
                        .scaleEffect(selected == tab.id ? 1.22 : 1.0)
                        .shadow(color: accent.opacity(selected == tab.id ? 0.33 : 0), radius: selected == tab.id ? 18 : 0, y: 2)
                        .onAppear {
                            DispatchQueue.main.async {
                                onFrameChange(geo.frame(in: .global))
                            }
                        }
                        .onChange(of: geo.frame(in: .global)) { newFrame in
                            onFrameChange(newFrame)
                        }
                }
                .frame(width: 34, height: 34)
                Text(tab.accessibility)
                    .font(.system(size: 13, weight: selected == tab.id ? .semibold : .regular))
                    .foregroundColor(
                        selected == tab.id
                            ? accent
                            : .primary.opacity(0.84)
                    )
                    .opacity(selected == tab.id ? 1 : 0.89)
                    .offset(y: 2)
                    .animation(.easeInOut(duration: 0.3), value: selected == tab.id)
            }
            .padding(.vertical, 9)
            .padding(.horizontal, 2)
            .contentShape(Rectangle())
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

struct FirstUnlockEffectView: View {
    @State private var confetti = false

    var body: some View {
        ZStack {
            Circle()
                .fill(RadialGradient(colors: [.yellow.opacity(0.7), .clear], center: .center, startRadius: 0, endRadius: 180))
                .scaleEffect(confetti ? 1.2 : 0.8)
                .opacity(confetti ? 0.8 : 0.5)
                .animation(.easeOut(duration: 0.8), value: confetti)
            
            VStack {
                Image(systemName: "star.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.yellow)
                    .shadow(color: .yellow.opacity(0.8), radius: 32)
                    .scaleEffect(confetti ? 1.1 : 0.7)
                    .animation(.spring(response: 0.7, dampingFraction: 0.4), value: confetti)
                Text("Easter Egg Unlocked!")
                    .font(.largeTitle).bold()
                    .foregroundColor(.white)
                    .shadow(radius: 4)
                    .padding(.top, 8)
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 36))
            .shadow(radius: 12)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            confetti = true
        }
    }
}


struct NavBarDemo: View {
    @State private var selectedTab: String = NavBarTab.home.id
    @State private var weatherType: WeatherType = .sun

    private var tabItems: [NavBarTabItem] {
        [
            NavBarTab.home.toItem,
            NavBarTab.forecast.toItem,
            NavBarTab.ai.toItem,
            NavBarTab.settings.toItem
        ]
    }

    var body: some View {
        NavigationStack {
            ZStack {
                weatherGradient(for: weatherType)
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    Navbar(selected: $selectedTab, tabs: tabItems, weatherType: weatherType)
                }
                VStack {
                    Picker("Weather", selection: $weatherType) {
                        ForEach(WeatherType.allCases, id: \.id) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.top, 24)
                    .padding(.horizontal)
                    Spacer()
                }
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}



#Preview("Weather NavBar v6: Weather Aware, Super Mode, Widget, Keyboard Dock, Easter Egg") {
    NavBarDemo()
}
