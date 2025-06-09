import SwiftUI

struct Achievement: Identifiable {
    let id = UUID()
    let name: String
    let requiredDays: Int
    let colors: [Color]
    var unlocked: Bool
    let currentDays: Int
    var progressText: String {
        if unlocked {
            return "Unlocked!"
        } else {
            return "\(currentDays) days"
        }
    }
}

struct AchievementsView: View {
    let streakDays: Int
    
    // Sample data
    @State private var achievements: [Achievement] = [
        Achievement(name: "Initiate", requiredDays: 1, colors: [.cyan], unlocked: true, currentDays: 1),
        Achievement(name: "Aware", requiredDays: 3, colors: [.orange], unlocked: false, currentDays: 3),
        Achievement(name: "Contender", requiredDays: 7, colors: [.purple], unlocked: false, currentDays: 7),
        Achievement(name: "Disciplined", requiredDays: 14, colors: [.yellow], unlocked: false, currentDays: 14),
        Achievement(name: "Rewired", requiredDays: 30, colors: [.green], unlocked: false, currentDays: 30),
        Achievement(name: "Transformed", requiredDays: 45, colors: [.red], unlocked: false, currentDays: 45),
        Achievement(name: "Master", requiredDays: 60, colors: [Color(red: 1.0, green: 0.84, blue: 0.0)], unlocked: false, currentDays: 60),
        Achievement(name: "Enlightened", requiredDays: 90, colors: [.pink], unlocked: false, currentDays: 90),
        Achievement(name: "Sage", requiredDays: 180, colors: [.indigo], unlocked: false, currentDays: 180),
        Achievement(name: "Transcendent", requiredDays: 365, colors: [.white, .white.opacity(0.8), .white.opacity(0.6)], unlocked: false, currentDays: 365)
    ]
    
    private var unlockedCount: Int {
        achievements.filter { $0.unlocked }.count
    }
    
    // Add this function to update achievement states
    private func updateAchievementStates(currentDays: Int) {
        achievements = achievements.map { achievement in
            var updatedAchievement = achievement
            updatedAchievement.unlocked = currentDays >= achievement.requiredDays
            return updatedAchievement
        }
    }
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    HStack {
                        Button(action: { /* Back action */ }) {
                            Image(systemName: "chevron.left")
                                .font(.title2.bold())
                                .foregroundColor(.white.opacity(0.8))
                        }
                        Spacer()
                        Text("UNFAP")
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        Spacer()
                        Spacer().frame(width: 32)
                    }
                    
                    Text("Achievements")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 32) {
                        ForEach(achievements) { achievement in
                            VStack(spacing: 8) {
                                AchievementOrb(colors: achievement.colors, unlocked: achievement.unlocked)
                                Text(achievement.name)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text(achievement.progressText)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 32)
            }
        }
        .onAppear {
            // Update achievement states when view appears
            updateAchievementStates(currentDays: streakDays)
        }
    }
}

struct AchievementOrb: View {
    let colors: [Color]
    let unlocked: Bool
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Outer glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: colors.map { $0.opacity(0.3) },
                        center: .center,
                        startRadius: 0,
                        endRadius: 30
                    )
                )
                .frame(width: 60, height: 60)
                .blur(radius: 5)
                .opacity(unlocked ? 1 : 0.3)
            
            // Main orb
            Circle()
                .fill(
                    RadialGradient(
                        colors: colors,
                        center: .center,
                        startRadius: 0,
                        endRadius: 25
                    )
                )
                .frame(width: 50, height: 50)
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: colors.map { $0.opacity(0.8) },
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: colors.first?.opacity(0.5) ?? .clear, radius: 10)
                .opacity(unlocked ? 1 : 0.5)
            
            // Special effect for Transcendent (365 days)
            if colors.contains(.white) && unlocked {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.white.opacity(0.8), .white.opacity(0.4), .clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 30
                        )
                    )
                    .frame(width: 60, height: 60)
                    .blur(radius: 3)
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                    .opacity(isAnimating ? 0.8 : 0.5)
                    .animation(
                        Animation.easeInOut(duration: 2)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
            }
            
            // Lock icon for locked achievements
            if !unlocked {
                Image(systemName: "lock.fill")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct ProgressBar: View {
    let progress: Double // 0.0 to 1.0
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.15))
                Capsule()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: geo.size.width * CGFloat(progress))
            }
        }
    }
}

struct StarryBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red:0.08, green:0.09, blue:0.18), Color(red:0.13, green:0.14, blue:0.25)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            ForEach(0..<80, id: \ .self) { i in
                Circle()
                    .fill(Color.white.opacity(.random(in: 0.08...0.18)))
                    .frame(width: .random(in: 1...2.5), height: .random(in: 1...2.5))
                    .position(x: .random(in: 0...UIScreen.main.bounds.width), y: .random(in: 0...UIScreen.main.bounds.height))
            }
        }
    }
}

// Preview
#Preview {
    AchievementsView(streakDays: 0)
} 