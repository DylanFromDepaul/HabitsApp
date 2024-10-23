import Foundation

class AchievementViewModel: ObservableObject {
    @Published var achievements: [Achievement] = []

    init() {
        loadAchievements()
    }

    func loadAchievements() {
        achievements = [
            Achievement(title: "First Step", description: "Complete your first habit."),
            Achievement(title: "Habit Streak", description: "Reach a 5-day streak on any habit."),
            // Add more predefined achievements
        ]
    }

    func checkAchievements(for habit: Habit) {
        // Unlock achievements based on criteria
        if habit.progress >= habit.target {
            unlockAchievement(title: "First Step")
        }
        if habit.streak >= 5 {
            unlockAchievement(title: "Habit Streak")
        }
    }

    private func unlockAchievement(title: String) {
        if let index = achievements.firstIndex(where: { $0.title == title && !$0.isUnlocked }) {
            achievements[index].isUnlocked = true
            // Optionally, post a notification or update other relevant state
        }
    }
}
