import SwiftUI

struct ProgressBarView: View {
    var progress: Double // Should be between 0 and 1

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background Bar
                RoundedRectangle(cornerRadius: 5)
                    .frame(height: 8)
                    .foregroundColor(Color.gray.opacity(0.3))
                // Progress Bar with Gradient
                RoundedRectangle(cornerRadius: 5)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * CGFloat(progress), height: 8)
                    .animation(.linear, value: progress)
            }
        }
        .frame(height: 8)
    }
}
