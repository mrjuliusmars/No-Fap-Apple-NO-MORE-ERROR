import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @StateObject private var streakManager = StreakManager()
    @State private var streakDays = 0 // Changed from 2 to 0 for new users
    @State private var highScore = 89
    @State private var showCheckIn = false
    @State private var showChecklist = false
    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0
    @State private var timer: Timer?
    @State private var streakStartDate = Date() // Will be set to current time for new users
    @State private var showPanicButton = false
    @State private var showGoonCam = false
    @State private var showChat = false
    @State private var showRelapseConfirmation = false
    @State private var showCongratulations = false
    
    // Track if this is first time opening dashboard after onboarding
    @AppStorage("firstDashboardEntry") private var isFirstDashboardEntry = true
    @AppStorage("streakStartDateKey") private var storedStreakStartDate: Double = 0
    
    // Progressive Challenge Storage (replacing 75 Soft Challenge)
    @AppStorage("isChallengeActive") private var isChallengeActive = false
    @AppStorage("challengeStartDate") private var challengeStartDate: Double = 0
    @AppStorage("challengeDayNumber") private var challengeDayNumber = 0
    @AppStorage("currentChallengeLevel") private var currentChallengeLevel = 0
    @AppStorage("lastHabitCheckDate") private var lastHabitCheckDate: String = ""
    
    // Progressive Challenge Levels: 7 → 14 → 30 → 60 → 90 → 120 → 180 → 365
    private let challengeLevels = [7, 14, 30, 60, 90, 120, 180, 365]
    
    // Current challenge target days
    private var currentChallengeTarget: Int {
        guard currentChallengeLevel < challengeLevels.count else {
            return challengeLevels.last ?? 365
        }
        return challengeLevels[currentChallengeLevel]
    }
    
    // Challenge name based on current level
    private var challengeName: String {
        let target = currentChallengeTarget
        if target >= 365 {
            return "1-Year Challenge"
        } else if target >= 120 {
            return "\(target)-Day Challenge"
        } else {
            return "\(target)-Day Challenge"
        }
    }
    
    // Daily Habits for Progressive Challenge
    private let dailyHabits = [
        "❌ Avoid porn & masturbation",
        "🧠 10 Minutes of Dopamine Detox",
        "💦 1 Cold Shower (30–60 Seconds)",
        "🏃 Physical exercise (30+ mins)",
        "📵 Remove 1 Trigger Daily"
    ]
    
    // Individual habit completion storage
    @AppStorage("todayCompletedHabits") private var todayCompletedHabitsData: Data = Data()
    
    private func getTodayCompletedHabits() -> Set<Int> {
        if let decoded = try? JSONDecoder().decode(Set<Int>.self, from: todayCompletedHabitsData) {
            return decoded
        }
        return Set<Int>()
    }
    
    private func setTodayCompletedHabits(_ habits: Set<Int>) {
        if let encoded = try? JSONEncoder().encode(habits) {
            todayCompletedHabitsData = encoded
        }
    }
    
    private var todayCompletedHabits: Set<Int> {
        get {
            getTodayCompletedHabits()
        }
        set {
            setTodayCompletedHabits(newValue)
        }
    }
    
    private var challengeProgress: Double {
        return min(Double(challengeDayNumber) / Double(currentChallengeTarget), 1.0)
    }
    
    // Life force energy animation states
    @State private var lifeforceScale: CGFloat = 1.0
    @State private var energyPulse: CGFloat = 1.0
    @State private var coreGlow: Double = 0.8
    @State private var outerEnergy: CGFloat = 1.0
    @State private var auraRotation: Double = 0
    @State private var energyFlow: Double = 0
    @State private var vitalityPulse: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea(.all)
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Top Navigation
                    HStack {
                        Text("OVERKUM")
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .tracking(1)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Image(systemName: "gear")
                                .font(.title3)
                                .foregroundColor(Theme.textPrimary.opacity(0.7))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    
                    // Main Content
                    VStack(spacing: 16) {
                        // Life Force Energy Ball
                        VStack(spacing: 24) {
                            // Multi-layered Life Force Energy Ball
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
                                    .frame(width: 130, height: 130)
                                    .scaleEffect(outerEnergy * 1.05)
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
                                    .scaleEffect(vitalityPulse)
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
                                            .rotationEffect(.degrees(auraRotation))
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
                                            .rotationEffect(.degrees(-auraRotation * 0.7))
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
                        }
                        .frame(maxHeight: .infinity, alignment: .center)
                            
                        // Time breakdown with live updating
                                Text("You've been addiction-free for:")
                            .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Theme.textSecondary)
                                Text("\(streakDays) days")
                                    .font(.system(size: 48, weight: .bold, design: .rounded))
                                    .foregroundColor(Theme.textPrimary)
                                Text("\(hours)hr \(minutes)m \(seconds)s")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(Theme.textSecondary)
                                    .padding(.top, 4)
                            }
                            .padding(.bottom, 20)
                    
                    Spacer().frame(height: 36)
                        
                        // Action Buttons
                        HStack(spacing: 40) {
                            ActionButton(
                                icon: "circle.circle.fill",
                                title: "Checklist",
                                action: { showChecklist = true }
                            )
                            
                            ActionButton(
                                icon: "arrow.triangle.2.circlepath",
                                title: "Relapse",
                                action: { showRelapseConfirmation = true }
                            )
                            
                            ActionButton(
                                icon: "bubble.left.and.bubble.right.fill",
                                title: "Join Chat",
                                action: { openTelegramGroup() }
                            )
                        }
                        .padding(.horizontal, 24)
                    
                    Spacer().frame(height: 24) // Add space below the action buttons
                        
                        // Challenge Card
                        VStack(alignment: .center, spacing: 8) {
                            Text(challengeName)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(Theme.textSecondary.opacity(0.8))
                                .tracking(1.2)
                                .textCase(.uppercase)
                            
                            if isChallengeActive {
                                Text("Day \(challengeDayNumber) of \(currentChallengeTarget)")
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    .foregroundColor(Theme.textPrimary)
                                
                                Text("Stay consistent, build strength")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.blue.opacity(0.8))
                                
                                // Progress Bar
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.white.opacity(0.08))
                                            .frame(height: 8)
                                        
                                        RoundedRectangle(cornerRadius: 8)
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
                                            .frame(width: geometry.size.width * challengeProgress, height: 8)
                                            .shadow(color: Color.yellow.opacity(0.4), radius: 4, x: 0, y: 2)
                                    }
                                }
                                .frame(height: 8)
                                
                                // Daily habit check button
                                if todayCompletedHabits.count < dailyHabits.count {
                                    Button(action: {
                                        showCheckIn = true
                                    }) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.system(size: 16, weight: .semibold))
                                            Text("Today's Habits (\(todayCompletedHabits.count)/\(dailyHabits.count))")
                                                .font(.system(size: 14, weight: .semibold))
                                        }
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            LinearGradient(
                                                colors: todayCompletedHabits.count > 0 ? 
                                                    [Color.orange.opacity(0.8), Color.orange.opacity(0.6)] :
                                                    [Color.green.opacity(0.8), Color.green.opacity(0.6)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .cornerRadius(20)
                                    }
                                    .padding(.top, 8)
                                } else {
                                    Button(action: {
                                        completeDay()
                                    }) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "star.fill")
                                                .font(.system(size: 16, weight: .semibold))
                                            Text("Complete Day \(challengeDayNumber)")
                                                .font(.system(size: 14, weight: .semibold))
                                        }
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            LinearGradient(
                                                colors: [Color.yellow.opacity(0.8), Color.yellow.opacity(0.6)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .cornerRadius(20)
                                    }
                                    .padding(.top, 8)
                                }
                            } else {
                                Text("Start Your Journey")
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundColor(Theme.textPrimary)
                                
                                Text("Build discipline through daily habits")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.blue.opacity(0.8))
                                    .multilineTextAlignment(.center)
                                
                                Button(action: {
                                    startChallenge()
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "flame.fill")
                                            .font(.system(size: 16, weight: .semibold))
                                        Text("Start 7-Day Challenge")
                                            .font(.system(size: 14, weight: .semibold))
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(
                                        LinearGradient(
                                            colors: [Color.orange.opacity(0.8), Color.red.opacity(0.6)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .cornerRadius(25)
                                }
                                .padding(.top, 8)
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.03))
                        )
                        .padding(.horizontal, 24)
                    
                    // Panic Button (immediately below challenge card)
                    Button(action: {
                        showGoonCam = true
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(color: Color.white.opacity(0.7), radius: 4, x: 0, y: 2)
                            Text("Panic Button")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(color: Color.white.opacity(0.7), radius: 2, x: 0, y: 1)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            LinearGradient(
                                colors: [Color.red.opacity(0.8), Color.red.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Capsule())
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 40)
                    .fullScreenCover(isPresented: $showGoonCam) {
                        GoonCamView(onDone: { showGoonCam = false })
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .sheet(isPresented: $showChecklist) {
            ChecklistView()
        }
        .sheet(isPresented: $showRelapseConfirmation) {
            RelapseConfirmationView(onConfirm: {
                resetAllCounters()
                showRelapseConfirmation = false
            })
        }
        .sheet(isPresented: $showCheckIn) {
            SoftHabitsView(
                habits: dailyHabits,
                currentDay: challengeDayNumber,
                challengeTarget: currentChallengeTarget,
                challengeName: challengeName,
                onHabitsComplete: {
                    completeChallenge()
                }
            )
        }
        .overlay {
            if showCongratulations {
                ChallengeCompletionView()
                    .transition(.scale.combined(with: .opacity))
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showCongratulations)
            }
        }
        .onAppear {
            initializeCounters()
            startTimer() // Start the real-time counter
            startLifeforceAnimations() // Start energy animations
        }
        .onDisappear {
            stopTimer() // Stop timer when view disappears
        }
        #if DEBUG
        .overlay(alignment: .topLeading) {
            VStack {
                Text("💎 SUBSCRIBED")
                    .font(.caption)
                    .padding(4)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(4)
                    .opacity(subscriptionManager.isSubscribed ? 1 : 0)
            }
            .padding()
        }
        #endif
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
        let totalMinutes = totalSeconds / 60
        let totalHours = totalMinutes / 60
        let totalDays = totalHours / 24
        
        // Update the displayed values
        streakDays = totalDays
        hours = totalHours % 24
        minutes = totalMinutes % 60
        seconds = totalSeconds % 60
    }
    
    private func resetAllCounters() {
        print("🔴 Relapse button pressed - resetting all counters to zero")
        
        // Reset visual counters immediately
        streakDays = 0
        hours = 0
        minutes = 0
        seconds = 0
        
        // Reset streak start date to now
        streakStartDate = Date()
        storedStreakStartDate = streakStartDate.timeIntervalSince1970
        
        // Reset StreakManager
        streakManager.resetStreak()
        
        // Reset current challenge (not level progression)
        if isChallengeActive {
            challengeDayNumber = 1
            challengeStartDate = Date().timeIntervalSince1970
            lastHabitCheckDate = ""
            setTodayCompletedHabits(Set<Int>())
            print("🔄 Challenge reset to day 1 of \(challengeName)")
        }
        
        // Restart timer and animations
        stopTimer()
        startTimer()
        
        // Add haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.impactOccurred()
        
        print("✅ All counters reset successfully - challenge reset to day 1")
    }
    
    private func openTelegramGroup() {
        // Replace with your actual Telegram group invite link
        let telegramGroupURL = "https://t.me/+YOUR_GROUP_INVITE_CODE"
        
        if let url = URL(string: telegramGroupURL) {
            UIApplication.shared.open(url) { success in
                if !success {
                    // Fallback if Telegram app isn't installed - opens in web browser
                    if let webURL = URL(string: telegramGroupURL) {
                        UIApplication.shared.open(webURL)
                    }
                }
            }
        }
    }
    
    private var todayDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    private var yesterdayDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        return formatter.string(from: yesterday)
    }
    
    private func hasCompletedTodaysHabits() -> Bool {
        return lastHabitCheckDate == todayDateString
    }
    
    private func startChallenge() {
        isChallengeActive = true
        challengeStartDate = Date().timeIntervalSince1970
        challengeDayNumber = 1
        lastHabitCheckDate = ""
        
        // Add haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        print("🔥 Started \(challengeName)!")
    }
    
    private func completeChallenge() {
        guard isChallengeActive else { return }
        
        // Mark today as completed
        lastHabitCheckDate = todayDateString
        
        // Reset today's habits for next day
        setTodayCompletedHabits(Set<Int>())
        
        // Advance to next day
        challengeDayNumber += 1
        
        // Check if current challenge completed
        if challengeDayNumber > currentChallengeTarget {
            completeChallengeLevel()
            return
        }
        
        // Add haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        
        print("✅ Completed day \(challengeDayNumber - 1) of \(challengeName)")
    }
    
    private func completeChallengeLevel() {
        // Add celebration haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.impactOccurred()
        
        let completedChallengeName = challengeName
        print("🎉 \(completedChallengeName) completed! Congratulations!")
        
        // Show congratulations
        showCongratulations = true
        
        // Auto-dismiss congratulations after 4 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            showCongratulations = false
            
            // Auto-progress to next challenge level
            progressToNextChallenge()
        }
    }
    
    private func progressToNextChallenge() {
        if currentChallengeLevel < challengeLevels.count - 1 {
            // Progress to next challenge level
            currentChallengeLevel += 1
            challengeDayNumber = 1
            challengeStartDate = Date().timeIntervalSince1970
            lastHabitCheckDate = ""
            setTodayCompletedHabits(Set<Int>())
            
            print("🚀 Auto-progressed to \(challengeName)!")
        } else {
            // Completed all challenges - reset to allow restart
            isChallengeActive = false
            currentChallengeLevel = 0
            challengeDayNumber = 0
            challengeStartDate = 0
            lastHabitCheckDate = ""
            setTodayCompletedHabits(Set<Int>())
            
            print("🏆 All challenges completed! You are a master!")
        }
    }
    
    private func startLifeforceAnimations() {
        // Core vitality pulse - like a heartbeat
        withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
            vitalityPulse = 1.12
        }
        
        // Life force breathing
        withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
            lifeforceScale = 1.08
        }
        
        // Energy pulse waves
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            energyPulse = 1.15
        }
        
        // Outer energy field breathing
        withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
            outerEnergy = 1.25
        }
        
        // Core glow intensity pulsing
        withAnimation(.easeInOut(duration: 2.8).repeatForever(autoreverses: true)) {
            coreGlow = 1.2
        }
        
        // Energy flow rotation
        withAnimation(.linear(duration: 8.0).repeatForever(autoreverses: false)) {
            auraRotation = 360
        }
        
        // Energy flow (opposite direction)
        withAnimation(.linear(duration: 12.0).repeatForever(autoreverses: false)) {
            energyFlow = 360
        }
    }
    
    private func initializeCounters() {
        if isFirstDashboardEntry {
            // First time opening dashboard after onboarding - start fresh
            print("🎯 First dashboard entry - initializing counters to zero")
            streakStartDate = Date()
            storedStreakStartDate = streakStartDate.timeIntervalSince1970
            streakDays = 0
            hours = 0
            minutes = 0
            seconds = 0
            isFirstDashboardEntry = false
            
            // Reset StreakManager to start fresh
            streakManager.resetStreak()
        } else {
            // Load existing streak data
            if storedStreakStartDate > 0 {
                streakStartDate = Date(timeIntervalSince1970: storedStreakStartDate)
            }
        }
        
        updateTimeComponents()
    }
    
    private func completeDay() {
        completeChallenge()
    }
}

struct ActionButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    var showNotification: Bool = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(Theme.textPrimary)
                    
                    if showNotification {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                            .offset(x: 12, y: -12)
                    }
                }
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
            }
        }
    }
}

struct BottomNavButton: View {
    let icon: String
    let isSelected: Bool
    
    var body: some View {
        Button(action: {}) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(isSelected ? Theme.textPrimary : Theme.textSecondary)
        }
    }
}

// MARK: - Progressive Challenge Habits View
struct SoftHabitsView: View {
    let habits: [String]
    let currentDay: Int
    let challengeTarget: Int
    let challengeName: String
    let onHabitsComplete: () -> Void
    @State private var completedHabits: Set<Int> = []
    @Environment(\.dismiss) var dismiss
    
    // Load today's completed habits from storage
    @AppStorage("todayCompletedHabits") private var todayCompletedHabitsData: Data = Data()
    
    private func getStoredCompletedHabits() -> Set<Int> {
        if let decoded = try? JSONDecoder().decode(Set<Int>.self, from: todayCompletedHabitsData) {
            return decoded
        }
        return Set<Int>()
    }
    
    private func setStoredCompletedHabits(_ habits: Set<Int>) {
        if let encoded = try? JSONEncoder().encode(habits) {
            todayCompletedHabitsData = encoded
        }
    }
    
    private var allHabitsCompleted: Bool {
        return completedHabits.count == habits.count
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text(challengeName)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                        
                        Text("Day \(currentDay) of \(challengeTarget)")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Complete habits individually as you do them")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    // Habits List
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(Array(habits.enumerated()), id: \.offset) { index, habit in
                                HabitRow(
                                    habit: habit,
                                    isCompleted: completedHabits.contains(index),
                                    onToggle: {
                                        var newCompletedHabits = completedHabits
                                        if completedHabits.contains(index) {
                                            newCompletedHabits.remove(index)
                                        } else {
                                            newCompletedHabits.insert(index)
                                            
                                            // Add haptic feedback
                                            let impact = UIImpactFeedbackGenerator(style: .light)
                                            impact.impactOccurred()
                                        }
                                        
                                        // Update local state
                                        completedHabits = newCompletedHabits
                                        
                                        // Save to persistent storage immediately
                                        setStoredCompletedHabits(newCompletedHabits)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                    
                    // Progress indicator
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(allHabitsCompleted ? .green : .white.opacity(0.6))
                        
                        Text("\(completedHabits.count) of \(habits.count) habits completed")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    // Complete Day Button (only if all habits done)
                    if allHabitsCompleted {
                        Button(action: {
                            onHabitsComplete()
                            dismiss()
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 20, weight: .semibold))
                                Text("Complete Day \(currentDay)!")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: [Color.yellow.opacity(0.8), Color.yellow.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(28)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    } else {
                        Spacer()
                             .frame(height: 40)
                    }
                }
            }
            .navigationTitle("Progressive Challenge")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            // Load existing progress when view appears
            completedHabits = getStoredCompletedHabits()
        }
    }
}

// MARK: - Habit Row
struct HabitRow: View {
    let habit: String
    let isCompleted: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 16) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(isCompleted ? .green : .white.opacity(0.6))
                
                Text(habit)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .strikethrough(isCompleted, color: .white.opacity(0.6))
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isCompleted ? Color.green.opacity(0.2) : Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isCompleted ? Color.green.opacity(0.4) : Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Challenge Completion View
struct ChallengeCompletionView: View {
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.0
    @State private var confettiScale: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            // Background blur
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                // Confetti animation
                Text("🎉🎊✨🏆✨🎊🎉")
                    .font(.system(size: 48))
                    .scaleEffect(confettiScale)
                
                VStack(spacing: 20) {
                    Text("CHALLENGE COMPLETE!")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .tracking(2)
                    
                    Text("LEVEL UP!")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.yellow)
                        .tracking(3)
                    
                    Text("Ready for the next challenge? 🔥")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                    
                    Text("You are a champion! 👑")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.yellow)
                }
                .opacity(opacity)
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.1, green: 0.1, blue: 0.4),
                                Color(red: 0.2, green: 0.1, blue: 0.5),
                                Color(red: 0.1, green: 0.2, blue: 0.6)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.yellow.opacity(0.6), Color.orange.opacity(0.4)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                    )
            )
            .scaleEffect(scale)
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.3)) {
                confettiScale = 1.2
            }
        }
    }
}

// MARK: - Relapse Confirmation View
struct RelapseConfirmationView: View {
    let onConfirm: () -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                // Warning icon
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.red.opacity(0.8))
                    .shadow(color: .red.opacity(0.3), radius: 12, x: 0, y: 6)
                
                VStack(spacing: 16) {
                    Text("Reset Progress?")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("This will reset all your counters back to zero. Your progress will be lost.")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                VStack(spacing: 16) {
                    Button(action: {
                        onConfirm()
                        dismiss()
                    }) {
                        Text("Yes, Reset Progress")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                LinearGradient(
                                    colors: [Color.red.opacity(0.8), Color.red.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(25)
                    }
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(
                                RoundedRectangle(cornerRadius: 22)
                                    .fill(Color.white.opacity(0.1))
                            )
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var isChallengeActive = false
        @State private var challengeDayNumber = 1
        @State private var showCongratulations = false
        
        var body: some View {
            ZStack {
                DashboardView()
                
                // Debug overlay for testing 75 Soft Challenge
                VStack {
                    Spacer()
                    
                    HStack(spacing: 12) {
                        // Start 75 Soft Challenge
                        Button("🔥 Start Challenge") {
                            isChallengeActive = true
                            challengeDayNumber = 1
                        }
                        .debugButtonStyle(.orange)
                        
                        // Test Day 74 completion
                        Button("🎯 Day 74→75") {
                            challengeDayNumber = 75
                            testChallengeCompletion()
                        }
                        .debugButtonStyle(.green)
                        
                        // Reset Challenge
                        Button("🔄 Reset") {
                            isChallengeActive = false
                            challengeDayNumber = 0
                            showCongratulations = false
                        }
                        .debugButtonStyle(.red)
                    }
                    .padding(.bottom, 50)
                }
                
                // Show congratulations overlay
                if showCongratulations {
                    ChallengeCompletionView()
                        .transition(.scale.combined(with: .opacity))
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showCongratulations)
                }
            }
        }
        
        private func testChallengeCompletion() {
            // Show congratulations
            showCongratulations = true
            
            // Add haptic feedback
            let impact = UIImpactFeedbackGenerator(style: .heavy)
            impact.impactOccurred()
            
            // Auto-dismiss after 6 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                showCongratulations = false
                // Reset challenge after completion
                isChallengeActive = false
                challengeDayNumber = 0
            }
            
            print("🎉 Preview: 75 Soft Challenge Completed!")
        }
        
        func debugButtonStyle(_ color: Color) -> some View {
            self
                .font(.caption)
                .padding(8)
                .background(color)
                .foregroundColor(.white)
                .cornerRadius(6)
        }
    }
    
    return PreviewWrapper()
} 
