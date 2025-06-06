import SwiftUI

struct DashboardView: View {
    @State private var streakDays = 2
    @State private var highScore = 89 // Longest streak achieved
    @State private var hours = 2
    @State private var minutes = 5
    @State private var seconds = 10
    @State private var progress: Double = 0.18
    @EnvironmentObject var onboardingState: OnboardingState
    @State private var showCheckIn = false
    @State private var showReminderAlert = false
    @State private var showChecklist = false
    @State private var lastCheckInDate: Date? = nil // Track last check-in
    @State private var timer: Timer?
    @State private var streakStartDate = Date()
    
    // Daily Reminders
    struct DailyReminder {
        let title: String
        let message: String
        let icon: String // SF Symbol name
    }
    
    let dailyReminders: [DailyReminder] = [
        DailyReminder(
            title: "Social Media Awareness",
            message: "Temptation is around every corner. Limit your distractions by unfollowing all social media accounts that cause temptation.",
            icon: "person.2.slash.fill"
        ),
        DailyReminder(
            title: "Physical Health",
            message: "Channel your energy into exercise. A strong body leads to a strong mind. Consider doing some push-ups or going for a run when urges arise.",
            icon: "figure.run.circle.fill"
        ),
        DailyReminder(
            title: "Mental Clarity",
            message: "Your brain is rewiring itself every day you stay clean. The fog will lift, and your focus will sharpen. Stay committed to your journey.",
            icon: "brain.head.profile"
        ),
        DailyReminder(
            title: "Productive Habits",
            message: "Replace idle time with meaningful activities. Learn a new skill, read a book, or work on a project. Keep your hands and mind busy.",
            icon: "book.fill"
        ),
        DailyReminder(
            title: "Emotional Growth",
            message: "Face your emotions directly instead of seeking escape. Each time you resist, you grow stronger emotionally and build better coping mechanisms.",
            icon: "heart.circle.fill"
        ),
        DailyReminder(
            title: "Digital Wellness",
            message: "Install website blockers, enable parental controls, and create a safe digital environment. Prevention is better than relapse.",
            icon: "shield.fill"
        ),
        DailyReminder(
            title: "Social Support",
            message: "Don't walk this path alone. Share your journey with trusted friends or join support groups. Community strength helps in tough times.",
            icon: "person.3.fill"
        )
    ]
    
    // Get today's reminder based on the day of the year
    private var todaysReminder: DailyReminder {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return dailyReminders[dayOfYear % dailyReminders.count]
    }
    
    // Animation states
    @State private var hasAnimated = false
    @State private var streakCircleScale: CGFloat = 0.3
    @State private var streakOpacity: Double = 0
    @State private var actionButtonsOffset: CGFloat = 50
    @State private var actionButtonsOpacity: Double = 0
    @State private var progressCardOffset: CGFloat = 30
    @State private var progressCardOpacity: Double = 0
    @State private var auraScale: CGFloat = 1.0
    @State private var auraOpacity: Double = 0.3
    @State private var shimmerRotation: Double = 0
    @State private var glowIntensity: Double = 0.2
    @State private var sparkleOpacity: Double = 0.0
    @State private var particleOffset: CGFloat = 0
    @State private var lifeforceScale: CGFloat = 1.0
    @State private var energyPulse: CGFloat = 1.0
    @State private var coreGlow: Double = 0.8
    @State private var outerEnergy: CGFloat = 1.0
    
    // Sample data for check-in - In real app, these would come from your data model
    let totalPoints = 1250
    
    // Check if check-in is available
    private var isCheckInAvailable: Bool {
        guard let lastCheckIn = lastCheckInDate else { return true }
        let calendar = Calendar.current
        return !calendar.isDate(lastCheckIn, inSameDayAs: Date())
    }
    
    // Best streak is always the highest achieved
    private var bestStreak: Int {
        max(streakDays, highScore)
    }
    
    // Challenge-based system
    private var currentChallenge: Int {
        if streakDays < 7 { return 7 }
        else if streakDays < 14 { return 14 }
        else if streakDays < 21 { return 21 }
        else if streakDays < 30 { return 30 }
        else if streakDays < 60 { return 60 }
        else if streakDays < 90 { return 90 }
        else if streakDays < 180 { return 180 }
        else { return ((streakDays / 30) + 1) * 30 } // 30-day increments after 180
    }
    
    private var challengeProgress: Double {
        let previousMilestone = getPreviousMilestone()
        let range = currentChallenge - previousMilestone
        let current = streakDays - previousMilestone
        return range > 0 ? min(Double(current) / Double(range), 1.0) : 1.0
    }
    
    private func getPreviousMilestone() -> Int {
        if currentChallenge == 7 { return 0 }
        else if currentChallenge == 14 { return 7 }
        else if currentChallenge == 21 { return 14 }
        else if currentChallenge == 30 { return 21 }
        else if currentChallenge == 60 { return 30 }
        else if currentChallenge == 90 { return 60 }
        else if currentChallenge == 180 { return 90 }
        else { return currentChallenge - 30 }
    }
    
    private var motivationalText: String {
        if streakDays < 7 { return "One day at a time." }
        else if streakDays < 14 { return "Building momentum. Keep going." }
        else if streakDays < 21 { return "Forming new habits. You're doing great." }
        else if streakDays < 30 { return "Almost a month strong!" }
        else { return "You're unstoppable. Keep the streak alive." }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Top Navigation
                HStack {
                    Text("No Fap")
                        .font(Theme.logoFont)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "gear")
                            .font(.title2)
                    }
                }
                .foregroundColor(Theme.textColor)
                .padding(.horizontal)
                .frame(height: 44)
                
                // Main Content
                ScrollView {
                    VStack(spacing: Theme.padding16) {
                        // Streak Circle
                        VStack(spacing: 16) {
                            // Premium Gold Badge with Enhanced Aura
                            ZStack {
                                // Outer energy field - breathes with life
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [
                                                Color.yellow.opacity(0.3 * coreGlow),
                                                Color.orange.opacity(0.25 * coreGlow),
                                                Color.red.opacity(0.1 * coreGlow),
                                                Color.clear
                                            ],
                                            center: .center,
                                            startRadius: 0,
                                            endRadius: 85
                                        )
                                    )
                                    .frame(width: 170, height: 170)
                                    .scaleEffect(outerEnergy * 1.15)
                                    .opacity(0.7)
                                
                                // Middle life energy layer
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [
                                                Color.white.opacity(0.4 * coreGlow),
                                                Color.yellow.opacity(0.6 * coreGlow),
                                                Color.orange.opacity(0.4 * coreGlow),
                                                Color.red.opacity(0.2 * coreGlow),
                                                Color.clear
                                            ],
                                            center: .center,
                                            startRadius: 0,
                                            endRadius: 55
                                        )
                                    )
                                    .frame(width: 140, height: 140)
                                    .scaleEffect(energyPulse * 1.08)
                                
                                // Inner core energy - the strongest pulse
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [
                                                Color.white.opacity(0.9 * coreGlow),
                                                Color.yellow.opacity(0.8 * coreGlow),
                                                Color.orange.opacity(0.3 * coreGlow),
                                                Color.clear
                                            ],
                                            center: .center,
                                            startRadius: 0,
                                            endRadius: 35
                                        )
                                    )
                                    .frame(width: 115, height: 115)
                                    .scaleEffect(lifeforceScale * 1.05)
                                
                                // Main lifeforce core - the heart of the energy
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [
                                                Color.white.opacity(0.95),
                                                Color(red: 1.0, green: 0.95, blue: 0.8).opacity(coreGlow),
                                                Color(red: 1.0, green: 0.85, blue: 0.4).opacity(coreGlow),
                                                Color(red: 0.9, green: 0.7, blue: 0.2).opacity(coreGlow * 0.9),
                                                Color(red: 0.8, green: 0.5, blue: 0.1).opacity(coreGlow * 0.8),
                                                Color(red: 0.6, green: 0.3, blue: 0.05).opacity(coreGlow * 0.7)
                                            ],
                                            center: UnitPoint(x: 0.3, y: 0.3),
                                            startRadius: 5,
                                            endRadius: 50
                                        )
                                    )
                                    .frame(width: 100, height: 100)
                                    .scaleEffect(auraScale)
                                    .overlay(
                                        // Energy shimmer - flows like living energy
                                        Circle()
                                            .fill(
                                                AngularGradient(
                                                    colors: [
                                                        Color.clear,
                                                        Color.white.opacity(0.3),
                                                        Color.yellow.opacity(0.8),
                                                        Color.white.opacity(0.9),
                                                        Color.orange.opacity(0.4),
                                                        Color.white.opacity(0.6),
                                                        Color.clear,
                                                        Color.clear,
                                                        Color.clear
                                                    ],
                                                    center: .center,
                                                    startAngle: .degrees(0),
                                                    endAngle: .degrees(360)
                                                )
                                            )
                                            .rotationEffect(.degrees(shimmerRotation))
                                            .animation(
                                                .linear(duration: 4.0)
                                                .repeatForever(autoreverses: false),
                                                value: shimmerRotation
                                            )
                                            .opacity(coreGlow * 0.7)
                                            .blendMode(.overlay)
                                    )
                                    .overlay(
                                        // Secondary energy flow - opposite direction
                                        Circle()
                                            .fill(
                                                AngularGradient(
                                                    colors: [
                                                        Color.clear,
                                                        Color.clear,
                                                        Color.white.opacity(0.4),
                                                        Color.yellow.opacity(0.6),
                                                        Color.clear,
                                                        Color.orange.opacity(0.3),
                                                        Color.white.opacity(0.5),
                                                        Color.clear,
                                                        Color.clear
                                                    ],
                                                    center: .center,
                                                    startAngle: .degrees(0),
                                                    endAngle: .degrees(360)
                                                )
                                            )
                                            .rotationEffect(.degrees(-shimmerRotation * 0.7))
                                            .opacity(coreGlow * 0.4)
                                            .blendMode(.screen)
                                    )
                                    .overlay(
                                        // Living energy ring
                                        Circle()
                                            .stroke(
                                                LinearGradient(
                                                    colors: [
                                                        Color.white.opacity(0.8 * coreGlow),
                                                        Color.yellow.opacity(0.6 * coreGlow),
                                                        Color.orange.opacity(0.4 * coreGlow),
                                                        Color.white.opacity(0.8 * coreGlow)
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 2
                                            )
                                            .frame(width: 95, height: 95)
                                            .scaleEffect(energyPulse * 0.98)
                                    )
                                    .shadow(color: Color.yellow.opacity(0.7 * coreGlow), radius: 25, x: 0, y: 0)
                                    .shadow(color: Color.orange.opacity(0.5 * coreGlow), radius: 15, x: 0, y: 0)
                                    .shadow(color: Color.white.opacity(0.3 * coreGlow), radius: 35, x: 0, y: 0)
                                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                                
                                // Energy growth indicator (gets brighter with longer streaks)
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [
                                                Color.white.opacity(min(Double(streakDays) * 0.02, 0.4)),
                                                Color.clear
                                            ],
                                            center: .center,
                                            startRadius: 0,
                                            endRadius: 20
                                        )
                                    )
                                    .frame(width: 60, height: 60)
                                    .scaleEffect(lifeforceScale * 1.1)
                            }
                            .animation(
                                .easeInOut(duration: 2.5)
                                .repeatForever(autoreverses: true),
                                value: auraScale
                            )
                            .scaleEffect(streakCircleScale)
                            
                            VStack(spacing: 8) {
                                Text("You've been fap-free for:")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Theme.textColor.opacity(0.7))
                                
                                Text("\(streakDays) days")
                                    .font(.system(size: 42, weight: .bold, design: .rounded))
                                    .foregroundColor(Theme.textColor)
                                
                                Text("\(hours)hr \(minutes)m \(seconds)s")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Theme.textColor.opacity(0.6))
                                    .padding(.top, 4)
                            }
                            
                            // Clean high score
                            HStack(spacing: 6) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(.orange.opacity(0.8))
                                Text("Best Streak: \(bestStreak) days")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Theme.textColor.opacity(0.6))
                            }
                            .padding(.top, 4)
                        }
                        .opacity(streakOpacity)
                        .padding(.bottom, Theme.padding16)
                        
                        // Action Buttons
                        HStack {
                            Spacer()
                            ActionButton(
                                icon: "circle.circle.fill",
                                title: "Checklist",
                                action: { showChecklist = true },
                                showNotification: isCheckInAvailable
                            )
                            Spacer()
                            ActionButton(icon: "arrow.triangle.2.circlepath", title: "Reset", action: {})
                            Spacer()
                            ActionButton(icon: "bubble.left.and.bubble.right.fill", title: "Join Chat", action: {})
                            Spacer()
                        }
                        .frame(height: 70)
                        .offset(y: actionButtonsOffset)
                        .opacity(actionButtonsOpacity)
                        .padding(.bottom, Theme.padding16)
                        
                        // Challenge Card
                        VStack(alignment: .center, spacing: Theme.padding12) {
                            // Header
                            HStack {
                                Spacer()
                                VStack(spacing: 4) {
                                    Text("Your Current Challenge")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Theme.textColor.opacity(0.6))
                                    
                                    Text("Reach \(currentChallenge) Days")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(Theme.textColor)
                                    
                                    Text(motivationalText)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.purple.opacity(0.8))
                                }
                                Spacer()
                            }
                            
                            // Progress Bar
                            VStack(spacing: 8) {
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        // Background track
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white.opacity(0.1))
                                            .frame(height: 12)
                                        
                                        // Progress fill - golden lifeforce colors
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(
                                                LinearGradient(
                                                    colors: [
                                                        Color(red: 1.0, green: 0.95, blue: 0.8),
                                                        Color(red: 1.0, green: 0.85, blue: 0.4),
                                                        Color(red: 0.9, green: 0.7, blue: 0.2)
                                                    ],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .frame(width: geometry.size.width * challengeProgress, height: 12)
                                            .shadow(color: Color.yellow.opacity(0.6), radius: 6)
                                            .shadow(color: Color.orange.opacity(0.4), radius: 3)
                                        
                                        // Golden shimmer effect for completed challenges
                                        if challengeProgress >= 1.0 {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(
                                                    LinearGradient(
                                                        colors: [
                                                            Color.clear,
                                                            Color.white.opacity(0.8),
                                                            Color.yellow.opacity(0.6),
                                                            Color.clear
                                                        ],
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                                .frame(width: geometry.size.width * challengeProgress, height: 12)
                                                .rotationEffect(.degrees(shimmerRotation))
                                        }
                                    }
                                }
                                .frame(height: 12)
                                
                                // Progress indicators
                                HStack {
                                    Text("\(getPreviousMilestone())")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Theme.textColor.opacity(0.6))
                                    
                                    Spacer()
                                    
                                    Text("\(currentChallenge)")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(challengeProgress >= 1.0 ? Color(red: 1.0, green: 0.85, blue: 0.4) : Theme.textColor.opacity(0.6))
                                }
                                .padding(.horizontal, 4)
                            }
                            .padding(.horizontal, Theme.padding16)
                        }
                        .padding(.vertical, Theme.padding16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.05))
                        )
                        .padding(.horizontal, Theme.padding16)
                    }
                    .padding(.top, Theme.padding48)
                }
                
                Spacer()
                
                // Panic Button
                Button(action: {
                    onboardingState.navigateTo(.panic)
                }) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text("PANIC BUTTON")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(Theme.cornerRadius)
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // Bottom Navigation
                HStack {
                    Spacer()
                    BottomNavButton(icon: "square.grid.2x2.fill", isSelected: true)
                    Spacer()
                    BottomNavButton(icon: "chart.xyaxis.line", isSelected: false)
                    Spacer()
                    BottomNavButton(icon: "bubble.left.and.bubble.right.fill", isSelected: false)
                    Spacer()
                    BottomNavButton(icon: "person.crop.circle", isSelected: false)
                    Spacer()
                }
                .padding(.top, 8)
                .padding(.bottom, 8)
                .frame(height: 60)
                .background(
                    Color.black.opacity(0.35)
                )
            }
        }
        .background(Theme.backgroundColor.ignoresSafeArea())
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $showChecklist) {
            ChecklistView()
        }
        .onAppear {
            // Initialize streak start date (2 days, 2 hours, 5 minutes, 10 seconds ago)
            let days: TimeInterval = 2 * 24 * 60 * 60
            let hours: TimeInterval = 2 * 60 * 60  
            let minutes: TimeInterval = 5 * 60
            let seconds: TimeInterval = 10
            streakStartDate = Date().addingTimeInterval(-(days + hours + minutes + seconds))
            
            if !hasAnimated {
                animateEntrance()
            }
            updateTimeComponents() // Calculate initial time
            startTimer() // Start the real-time counter
        }
        .onDisappear {
            stopTimer() // Stop timer when view disappears
        }
        .alert(todaysReminder.title, isPresented: $showReminderAlert) {
            VStack {
                Button("Continue to Check-in") {
                    showReminderAlert = false
                    showCheckIn = true
                }
                .buttonStyle(ReminderButtonStyle())
                
                Button("Maybe Later", role: .cancel) {
                    showReminderAlert = false
                }
                .buttonStyle(PlainButtonStyle())
            }
        } message: {
            VStack(spacing: 12) {
                Image(systemName: todaysReminder.icon)
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                    .padding(.bottom, 4)
                Text(todaysReminder.message)
            }
        }
        .sheet(isPresented: $showCheckIn) {
            CheckInView(streak: streakDays, points: totalPoints)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .onDisappear {
                    if isCheckInAvailable {
                        lastCheckInDate = Date()
                    }
                }
        }
    }
    
    private func animateEntrance() {
        // Initial delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                streakCircleScale = 1.0
                streakOpacity = 1
            }
            
            // Animate action buttons
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                actionButtonsOffset = 0
                actionButtonsOpacity = 1
            }
            
            // Animate progress card
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4)) {
                progressCardOffset = 0
                progressCardOpacity = 1
            }
            
            // Animate progress bar
            withAnimation(.easeInOut(duration: 1.0).delay(0.6)) {
                progressCardOffset = 0
                progressCardOpacity = 1
            }
            
            // Start energy shimmer flow
            withAnimation(
                .linear(duration: 4.0)
                .repeatForever(autoreverses: false)
            ) {
                shimmerRotation = 360
            }
            
            // Primary lifeforce pulse - the main heartbeat
            withAnimation(
                .easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true)
            ) {
                auraScale = 1.08
                lifeforceScale = 1.06
            }
            
            // Secondary energy pulse - faster, like breathing
            withAnimation(
                .easeInOut(duration: 1.2)
                .repeatForever(autoreverses: true)
            ) {
                energyPulse = 1.12
            }
            
            // Outer energy field - slow, deep breathing
            withAnimation(
                .easeInOut(duration: 3.5)
                .repeatForever(autoreverses: true)
            ) {
                outerEnergy = 1.15
            }
            
            // Core glow intensity - varies like life force strength
            withAnimation(
                .easeInOut(duration: 2.8)
                .repeatForever(autoreverses: true)
            ) {
                coreGlow = 1.2
            }
        }
        
        hasAnimated = true
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            updateTimeComponents()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateTimeComponents() {
        let now = Date()
        let timeInterval = now.timeIntervalSince(streakStartDate)
        
        let totalSeconds = Int(timeInterval)
        let days = totalSeconds / (24 * 60 * 60)
        let remainingSeconds = totalSeconds % (24 * 60 * 60)
        let hours = remainingSeconds / (60 * 60)
        let minutes = (remainingSeconds % (60 * 60)) / 60
        let seconds = remainingSeconds % 60
        
        self.streakDays = days
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }
}

struct ActionButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    var showNotification: Bool = false
    @State private var notificationScale: CGFloat = 1.0
    
    var body: some View {
        Button(action: action) {
            VStack {
                Circle()
                    .fill(Color.purple.opacity(0.3))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: icon)
                            .foregroundColor(.white)
                    )
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(Theme.textColor)
            }
        }
    }
}

struct BottomNavButton: View {
    let icon: String
    let isSelected: Bool
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 24))
            .foregroundColor(isSelected ? .purple : Theme.textColor.opacity(0.7))
            .frame(width: 44, height: 44)
            .contentShape(Rectangle())  // Ensures the entire frame is tappable
            .background(
                Circle()
                    .fill(Color.white.opacity(isSelected ? 0.1 : 0))
                    .frame(width: 44, height: 44)
            )
    }
}

struct ReminderButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [.purple, .blue],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct RecoveryStageCard: View {
    let icon: String
    let title: String
    let description: String
    let progress: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Top row with icon and percentage
            HStack {
                Text(icon)
                    .font(.title3)
                    .frame(width: 30, alignment: .leading)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.caption2.bold())
                    .foregroundColor(progress > 0 ? .green : .gray)
            }
            .frame(height: 25)
            
            // Title
            Text(title)
                .font(.caption.bold())
                .lineLimit(1)
                .frame(height: 16)
            
            // Description
            Text(description)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.7))
                .lineLimit(2)
                .frame(height: 32)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
                .frame(height: 8)
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 3)
                        .cornerRadius(1.5)
                    
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: geometry.size.width * progress, height: 3)
                        .cornerRadius(1.5)
                }
            }
            .frame(height: 3)
        }
        .padding(8)
        .frame(width: 135, height: 92)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        DashboardView()
            .environmentObject(OnboardingState())
            .preferredColorScheme(.dark)
    }
    .ignoresSafeArea(.keyboard)
} 
