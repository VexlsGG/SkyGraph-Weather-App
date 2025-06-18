import SwiftUI

struct Achievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    var unlocked: Bool
}

struct AchievementsPageView: View {
    var achievements: [Achievement]
    
    static var defaultAchievements: [Achievement] {
        [
            .init(id: "firstLaunch", title: "First Launch", description: "Open the app for the first time.", icon: "sparkles", unlocked: true),
            .init(id: "weatherExplorer", title: "Weather Explorer", description: "Visit all main tabs.", icon: "globe", unlocked: false),
            .init(id: "nightOwl", title: "Night Owl", description: "Open the app after midnight.", icon: "moon.stars.fill", unlocked: false),
            .init(id: "worldTraveler", title: "World Traveler", description: "Add more than 5 locations.", icon: "airplane", unlocked: false),
            .init(id: "widgetWizard", title: "Widget Wizard", description: "Add the weather widget to your home screen.", icon: "rectangle.stack.fill.badge.plus", unlocked: false),
            .init(id: "themeChanger", title: "Theme Changer", description: "Change the app theme (light/dark/custom).", icon: "paintbrush", unlocked: false),
            .init(id: "easterEggHunter", title: "Easter Egg Hunter", description: "Find the secret!", icon: "star.fill", unlocked: false),
            .init(id: "rainyDay", title: "Rainy Day", description: "Check the forecast when it’s raining.", icon: "cloud.rain.fill", unlocked: false),
            .init(id: "sunnyMood", title: "Sunny Mood", description: "Set the theme to match the current weather.", icon: "sun.max.fill", unlocked: false),
            .init(id: "feedbackGiver", title: "Feedback Giver", description: "Open the support/feedback form.", icon: "envelope.open.fill", unlocked: false),
            .init(id: "radarMaster", title: "Radar Master", description: "Open the radar/map tab.", icon: "map.fill", unlocked: false)
        ]
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(achievements) { achievement in
                        HStack(spacing: 18) {
                            ZStack {
                                Circle()
                                    .fill(achievement.unlocked ? LinearGradient(colors: [.yellow, .orange, .pink], startPoint: .top, endPoint: .bottom) : Color(.systemGray5))
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
                .padding(.top, 18)
            }
            .navigationTitle("Achievements")
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }
}
