import Foundation

class HabitModel: Identifiable, ObservableObject {
    @Published var id: UUID
    @Published var name: String
    @Published var frequency: String
    @Published var target: Int16
    @Published var progress: Int16
    @Published var streak: Int16
    @Published var reminderTime: Date?
    @Published var lastCompleted: Date?
    @Published var completionDates: [Date] = []

    init(id: UUID = UUID(), name: String, frequency: String, target: Int16, progress: Int16 = 0, streak: Int16 = 0, reminderTime: Date? = nil, lastCompleted: Date? = nil, completionDates: [Date] = []) {
        self.id = id
        self.name = name
        self.frequency = frequency
        self.target = target
        self.progress = progress
        self.streak = streak
        self.reminderTime = reminderTime
        self.lastCompleted = lastCompleted
        self.completionDates = completionDates
    }
}
