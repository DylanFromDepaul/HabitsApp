import Foundation

class UserProgress: ObservableObject {
    @Published var totalPoints: Int = 0

    func addPoints(_ points: Int) {
        totalPoints += points
    }
}