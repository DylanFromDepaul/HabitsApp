import SwiftUI

struct ContentView: View {
    @EnvironmentObject var achievementViewModel: AchievementViewModel
    @EnvironmentObject var userProgress: UserProgress

    var body: some View {
        NavigationView {
            HabitListView()
                .navigationTitle("Habit Tracker")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: AchievementView()) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
        }
    }
}
