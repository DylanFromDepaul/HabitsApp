import SwiftUI

struct HabitRowView: View {
    @ObservedObject var habit: Habit

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: habitCompleted ? "checkmark.seal.fill" : "seal")
                    .foregroundColor(habitCompleted ? .green : .blue)
                Text(habit.name ?? "Unnamed Habit")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
            }
            ProgressBarView(progress: calculateProgress())
                .frame(height: 8)
                .padding(.vertical, 4)
            HStack {
                Text("Progress: \(habit.progress) / \(habit.target)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("Streak: \(habit.streak) days")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }

    private var habitCompleted: Bool {
        return habit.progress >= habit.target
    }

    private func calculateProgress() -> Double {
        guard habit.target != 0 else { return 0.0 }
        return Double(habit.progress) / Double(habit.target)
    }
}
