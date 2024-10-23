import Foundation

class Achievement: Identifiable, ObservableObject {
    var id = UUID()
    let title: String
    let description: String
    @Published var isUnlocked: Bool = false

    init(title: String, description: String, isUnlocked: Bool = false) {
        self.title = title
        self.description = description
        self.isUnlocked = isUnlocked
    }
}