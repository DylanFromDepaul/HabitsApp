import SwiftUI

struct AchievementView: View {
    @EnvironmentObject var achievementViewModel: AchievementViewModel

    let columns = [
        GridItem(.adaptive(minimum: 100), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(achievementViewModel.achievements) { achievement in
                    VStack {
                        Image(systemName: achievement.isUnlocked ? "star.circle.fill" : "star.circle")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(achievement.isUnlocked ? .yellow : .gray)
                        Text(achievement.title)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 4)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("\(achievement.title), \(achievement.isUnlocked ? "Unlocked" : "Locked")")
                    .accessibilityHint(achievement.description)
                }
            }
            .padding()
        }
        .navigationTitle("Achievements")
    }
}
