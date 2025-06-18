import SwiftUI

enum AchievementFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case unlocked = "Unlocked"
    case locked = "Locked"
    var id: String { rawValue }
}

struct Achievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    var unlocked: Bool
}

struct AchievementsPageView: View {
    var achievements: [Achievement]
    @Environment(\.dismiss) private var dismiss

    @State private var filter: AchievementFilter = .all
    @State private var showFilterSheet = false

    private var filteredAchievements: [Achievement] {
        switch filter {
        case .all: return achievements
        case .unlocked: return achievements.filter { $0.unlocked }
        case .locked: return achievements.filter { !$0.unlocked }
        }
    }
    
    static var defaultAchievements: [Achievement] {
        [
            .init(id: "firstLaunch", title: "First Launch", description: "Open the app for the first time.", icon: "sparkles", unlocked: true),
            .init(id: "weatherExplorer", title: "Weather Explorer", description: "Visit all main tabs.", icon: "globe", unlocked: false),
            .init(id: "nightOwl", title: "Night Owl", description: "Open the app after midnight.", icon: "moon.stars.fill", unlocked: false),
            .init(id: "worldTraveler", title: "World Traveler", description: "Add more than 5 locations.", icon: "airplane", unlocked: false),
            .init(id: "widgetWizard", title: "Widget Wizard", description: "Add the weather widget to your home screen.", icon: "rectangle.stack.fill.badge.plus", unlocked: false),
            .init(id: "themeChanger", title: "Theme Changer", description: "Change the app theme (light/dark/custom).", icon: "paintbrush", unlocked: false),
            Achievement(id: "easterEggHunter", title: "Easter Egg Hunter", description: "...", icon: "star.fill", unlocked: UserDefaults.standard.bool(forKey: "easterEggHunterUnlocked")),
            .init(id: "rainyDay", title: "Rainy Day", description: "Check the forecast when it’s raining.", icon: "cloud.rain.fill", unlocked: false),
            .init(id: "sunnyMood", title: "Sunny Mood", description: "Set the theme to match the current weather.", icon: "sun.max.fill", unlocked: false),
            .init(id: "feedbackGiver", title: "Feedback Giver", description: "Open the support/feedback form.", icon: "envelope.open.fill", unlocked: false),
            .init(id: "radarMaster", title: "Radar Master", description: "Open the radar/map tab.", icon: "map.fill", unlocked: false)
        ]
    }

    private var unlockedCount: Int { achievements.filter { $0.unlocked }.count }
    private var totalCount: Int { achievements.count }
    private var progress: Double { totalCount == 0 ? 0 : Double(unlockedCount) / Double(totalCount) }

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 14) {
                Button(action: { dismiss() }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .frame(width: 40, height: 40)
                            .shadow(color: Color.black.opacity(0.12), radius: 4, y: 1)
                        Image(systemName: "arrow.left")
                            .foregroundColor(Color.blue)
                            .font(.system(size: 22, weight: .bold))
                    }
                }
                Text("Achievements")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.top, 24)
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            HStack(alignment: .center) {
                HStack(spacing: 8) {
                    Text("\(unlockedCount) of \(totalCount)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.secondary)
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color(.systemGray4))
                                .frame(height: 4)
                            Capsule()
                                .fill(Color.blue)
                                .frame(width: geo.size.width * CGFloat(progress), height: 4)
                        }
                    }
                    .frame(width: 80, height: 4)
                }
                .padding(.leading, 4)

                Spacer()

                Button {
                    showFilterSheet = true
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                            .font(.system(size: 19, weight: .semibold))
                        Text(filter.rawValue)
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .foregroundColor(.accentColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color(.systemGray5).opacity(0.7))
                    )
                }
            }
            .frame(height: 28)
            .padding(.horizontal)
            .padding(.bottom, 8)

            ScrollView {
                VStack(spacing: 20) {
                    ForEach(filteredAchievements) { achievement in
                        AchievementRow(achievement: achievement)
                    }
                    if filteredAchievements.isEmpty {
                        Text("No achievements to show.")
                            .foregroundColor(.secondary)
                            .padding(.top, 40)
                    }
                }
                .padding(.top, 8)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .confirmationDialog("Filter Achievements", isPresented: $showFilterSheet, titleVisibility: .visible) {
            ForEach(AchievementFilter.allCases) { option in
                Button(option.rawValue) { filter = option }
            }
        }
    }
}

struct AchievementRow: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: achievement.unlocked ? [.yellow, .orange, .pink] : [Color(.systemGray5), Color(.systemGray5)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 52, height: 52)
                    .shadow(color: achievement.unlocked ? .yellow.opacity(0.3) : .clear, radius: 6, y: 0)
                Image(systemName: achievement.icon)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(achievement.unlocked ? .white : .gray)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.headline)
                    .foregroundColor(achievement.unlocked ? .primary : .gray)
                Text(achievement.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if achievement.unlocked {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(achievement.unlocked ? Color.yellow.opacity(0.17) : Color(.systemGray6))
                .shadow(color: achievement.unlocked ? .yellow.opacity(0.09) : .clear, radius: 4, y: 2)
        )
        .padding(.horizontal)
    }
}

#Preview {
    AchievementsPageView(achievements: AchievementsPageView.defaultAchievements)
}
