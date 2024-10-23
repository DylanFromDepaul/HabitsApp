import SwiftUI

@main
struct HabitTrackerApp: App {
    let persistenceController = PersistenceController.shared

    @AppStorage("hasShownWelcome") private var hasShownWelcome: Bool = false

    init() {
        NotificationManager.shared.requestAuthorization()
    }

    var body: some Scene {
        WindowGroup {
            if hasShownWelcome {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(UserProgress())
                    .environmentObject(AchievementViewModel())
            } else {
                WelcomeView()
                    .onAppear {
                        hasShownWelcome = true
                    }
            }
        }
    }
}
