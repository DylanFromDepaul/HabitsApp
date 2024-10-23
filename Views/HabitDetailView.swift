import SwiftUI

struct HabitDetailView: View {
    @ObservedObject var habit: Habit
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var achievementViewModel: AchievementViewModel
    @EnvironmentObject var userProgress: UserProgress
    
    @State private var showCongratulationsAlert = false

    var body: some View {
        VStack {
            Text(habit.name ?? "Unnamed Habit")
                .font(.largeTitle)
            Text("Streak: \(habit.streak) days")
                .font(.title2)
                .padding()

            ProgressBarView(progress: calculateProgress())
                .frame(height: 10)
                .padding()

            Text("Progress: \(habit.progress) / \(habit.target)")
                .font(.headline)

            Button(action: {
                markAsComplete()
            }) {
                Text("Mark Complete")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(habit.progress < habit.target ? Color.accentColor : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(habit.progress >= habit.target)
            .padding()

            Spacer()
        }
        .padding()
        .navigationTitle("Habit Detail")
        .alert(isPresented: $showCongratulationsAlert) {
            Alert(
                title: Text("🎉 Congratulations!"),
                message: Text("You've completed your habit goal!"),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func calculateProgress() -> Double {
        guard habit.target != 0 else { return 0 }
        return Double(habit.progress) / Double(habit.target)
    }

    private func markAsComplete() {
        let today = Calendar.current.startOfDay(for: Date())
        let lastCompleted = habit.lastCompleted ?? Date.distantPast
        let daysSinceLastCompletion = Calendar.current.dateComponents([.day], from: lastCompleted, to: today).day ?? 0

        // Update progress if not yet at target
        if habit.progress < habit.target {
            habit.progress += 1
            userProgress.addPoints(10) // Add points per completion
        }

        // Check if we need to update the streak
        if habit.progress == habit.target {
            if daysSinceLastCompletion == 1 {
                // Consecutive day
                habit.streak += 1
            } else if daysSinceLastCompletion > 1 {
                // Missed days, reset streak
                habit.streak = 1
            }
            habit.lastCompleted = today
            // Check for achievements
            achievementViewModel.checkAchievements(for: habit)
            // Show congratulations alert
            showCongratulationsAlert = true
        }

        saveContext()
    }

    private func resetProgress() {
        // Reset progress for the next cycle (e.g., next day)
        habit.progress = 0
        saveContext()
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error updating habit: \(error.localizedDescription)")
        }
    }
}
