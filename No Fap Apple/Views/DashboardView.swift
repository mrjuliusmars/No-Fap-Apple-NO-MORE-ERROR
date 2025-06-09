import SwiftUI
import AVKit

extension Color {
    static let silver = Color(red: 0.75, green: 0.75, blue: 0.75)
}

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
    @State private var showBadgeProgress = false

    
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
    
    // Brain rewiring animation states
    @State private var brainScale: CGFloat = 1.0
    @State private var brainGlow: Double = 0.6
    @State private var shimmerRotation: Double = 0
    @State private var auraScale: CGFloat = 1.0
    @State private var lifeforceScale: CGFloat = 1.0
    @State private var energyPulse: CGFloat = 1.0
    @State private var coreGlow: Double = 0.8
    @State private var outerEnergy: CGFloat = 1.0
    @State private var synapseAnimation: Double = 0
    @State private var neuralPulse: CGFloat = 1.0
    @State private var progressRingRotation: Double = 0
    @State private var rewiringProgress: Double = 0.0
    @State private var showResetAnimation = false
    
    // --- BEGIN June 6th backup state variables ---
    @State private var vitalityPulse: CGFloat = 1.0
    @State private var auraRotation: Double = 0
    // --- END June 6th backup state variables ---
    
    // MARK: - Eye-Catching Aura Ball Color Logic
    private func auraColors(for days: Int) -> (core: [Color], aura: [Color], ring: [Color]) {
        switch days {
        case 0:
            return (
                core: [Color.gray],
                aura: [Color.gray.opacity(0.3), Color.clear],
                ring: [Color.gray]
            )
        case 1:
            return (
                core: [Color.cyan],
                aura: [Color.cyan.opacity(0.3), Color.clear],
                ring: [Color.cyan]
            )
        case 2...3:
            return (
                core: [Color.orange],
                aura: [Color.orange.opacity(0.3), Color.clear],
                ring: [Color.orange]
            )
        case 4...6:
            return (
                core: [Color.purple],
                aura: [Color.purple.opacity(0.3), Color.clear],
                ring: [Color.purple]
            )
        case 7...13:
            return (
                core: [Color.yellow],
                aura: [Color.yellow.opacity(0.3), Color.clear],
                ring: [Color.yellow]
            )
        case 14...29:
            return (
                core: [Color.green],
                aura: [Color.green.opacity(0.3), Color.clear],
                ring: [Color.green]
            )
        case 30...44:
            return (
                core: [Color.red],
                aura: [Color.red.opacity(0.3), Color.clear],
                ring: [Color.red]
            )
        case 45...59:
            return (
                core: [Color.blue],
                aura: [Color.blue.opacity(0.3), Color.clear],
                ring: [Color.blue]
            )
        case 60...89:
            return (
                core: [Color(red: 1.0, green: 0.84, blue: 0.0)],
                aura: [Color(red: 1.0, green: 0.84, blue: 0.0).opacity(0.3), Color.clear],
                ring: [Color(red: 1.0, green: 0.84, blue: 0.0)]
            )
        case 90...179:
            return (
                core: [Color.indigo],
                aura: [Color.indigo.opacity(0.3), Color.clear],
                ring: [Color.indigo]
            )
        case 180...364:
            return (
                core: [Color.mint],
                aura: [Color.mint.opacity(0.3), Color.clear],
                ring: [Color.mint]
            )
        default:
            // Transcendent (365+ days) - Glowing white effect
            return (
                core: [Color.white, Color.white.opacity(0.9), Color.white.opacity(0.8)],
                aura: [Color.white.opacity(0.4), Color.white.opacity(0.2), Color.clear],
                ring: [Color.white, Color.white.opacity(0.8)]
            )
        }
    }
    
    private var streakColors: (primary: Color, secondary: Color, accent: Color, glow: Color) {
        switch streakDays {
        case 0:
            return (Color.gray, Color.gray.opacity(0.6), Color.white, Color.gray)
        case 1:
            return (Color.cyan, Color.cyan.opacity(0.7), Color.white, Color.cyan)
        case 2...3:
            return (Color.orange, Color.orange.opacity(0.7), Color.white, Color.orange)
        case 4...6:
            return (Color.purple, Color.purple.opacity(0.7), Color.white, Color.purple)
        case 7...13:
            return (Color.yellow, Color.yellow.opacity(0.7), Color.white, Color.yellow)
        case 14...29:
            return (Color.green, Color.green.opacity(0.7), Color.white, Color.green)
        case 30...44:
            return (Color.red, Color.red.opacity(0.7), Color.white, Color.red)
        case 45...59:
            return (Color.blue, Color.blue.opacity(0.7), Color.white, Color.blue)
        case 60...89:
            return (
                Color(red: 1.0, green: 0.84, blue: 0.0),
                Color(red: 1.0, green: 0.84, blue: 0.0).opacity(0.7),
                Color.white,
                Color(red: 1.0, green: 0.84, blue: 0.0)
            )
        case 90...179:
            return (Color.indigo, Color.indigo.opacity(0.7), Color.white, Color.indigo)
        case 180...364:
            return (Color.mint, Color.mint.opacity(0.7), Color.white, Color.mint)
        default:
            // Transcendent (365+ days) - Glowing white effect
            return (
                Color.white,
                Color.white.opacity(0.8),
                Color.white,
                Color.white
            )
        }
    }
    
    private var isMilestoneDay: Bool {
        return [1, 2, 3, 4, 5, 6, 7, 14, 30, 45, 60, 75, 90].contains(streakDays) || 
               (streakDays > 90 && streakDays % 15 == 0)
    }
    
    private var milestoneIntensity: CGFloat {
        return isMilestoneDay ? 1.3 : 1.0
    }
    
    var body: some View {
        return ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea(.all)
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Top Navigation
                    HStack {
                        Text("UNFAP")
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .tracking(1)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Badge button
                        Button(action: { showBadgeProgress = true }) {
                            Image(systemName: "rosette.fill") // or "trophy.fill", "medal.fill"
                                .font(.title3)
                                .foregroundColor(.yellow)
                                .padding(.trailing, 8)
                                .accessibilityLabel("Badge Progress")
                        }
                        
                        // Settings button
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
                        // Clean Minimalist Orb
                        ZStack {
                            CleanMinimalistOrb(
                                auraScale: auraScale,
                                lifeforceScale: lifeforceScale,
                                energyPulse: energyPulse,
                                vitalityPulse: vitalityPulse,
                                coreGlow: coreGlow,
                                outerEnergy: outerEnergy,
                                auraRotation: auraRotation,
                                streakDays: streakDays,
                                showProgressRing: true
                            )
                        }
                        .onTapGesture {
                            showBadgeProgress = true
                        }
                        
                        // Rewiring progress with live updating
                        VStack(spacing: 8) {
                            Text("You've been fap-free for:")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Theme.textSecondary)
                            Text("\(streakDays) days")
                                .font(.system(size: 48, weight: .bold, design: .rounded))
                                .foregroundColor(Theme.textPrimary)
                            Text("\(hours)hr \(minutes)m \(seconds)s")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Theme.textSecondary)
                                .padding(.top, 4)
                            
                            if streakDays > 0 {
                                Text("Stay strong and keep going!")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.blue.opacity(0.8))
                                    .padding(.top, 4)
                            }
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
            startNeuronAnimations() // Start neuron energy animations
        }
        .onDisappear {
            stopTimer() // Stop timer when view disappears
        }
        #if DEBUG
        .overlay(alignment: .topLeading) {
            VStack(spacing: 8) {
                Text("💎 SUBSCRIBED")
                    .font(.caption)
                    .padding(4)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(4)
                    .opacity(subscriptionManager.isSubscribed ? 1 : 0)
                
                // Aura Ball Color Debug
                VStack(spacing: 4) {
                    Text("🎨 Aura Colors")
                        .font(.caption)
                        .padding(4)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach([0, 1, 3, 7, 14, 30, 60, 90, 180, 365], id: \.self) { days in
                                Button {
                                    streakDays = days
                                    streakStartDate = Date().addingTimeInterval(-Double(days * 24 * 60 * 60))
                                    storedStreakStartDate = streakStartDate.timeIntervalSince1970
                                } label: {
                                    Text("\(days)d")
                                        .font(.caption2)
                                        .padding(4)
                                        .background(nuroColor(for: days))
                                        .foregroundColor(.white)
                                        .cornerRadius(4)
                                }
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                    .frame(height: 32)
                }
                .background(Color.black.opacity(0.7))
                .cornerRadius(8)
            }
            .padding()
        }
        #endif
        .sheet(isPresented: $showBadgeProgress) {
            AchievementsView(streakDays: streakDays)
        }
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
        
        // Trigger reset animation before resetting counters
        triggerResetAnimation()
        
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
    
    private func startNeuronAnimations() {
        // --- BEGIN June 6th backup animation logic ---
        withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
            auraScale = 1.05
        }
        withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
            lifeforceScale = 1.08
        }
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            energyPulse = 1.12
        }
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            vitalityPulse = 1.05
        }
        withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
            coreGlow = 1.0
        }
        withAnimation(.easeInOut(duration: 2.8).repeatForever(autoreverses: true)) {
            outerEnergy = 1.15
        }
        withAnimation(.linear(duration: 4.0).repeatForever(autoreverses: false)) {
            auraRotation = 360
        }
        // --- END June 6th backup animation logic ---
    }
    
    private func updateRewiringProgress() {
        // Calculate progress based on streak days (max 100 days for full circle)
        let maxDays = 100.0
        let progress = min(Double(streakDays) / maxDays, 1.0)
        
        withAnimation(.easeInOut(duration: 1.0)) {
            rewiringProgress = progress
        }
    }
    
    private func triggerResetAnimation() {
        // Show reset animation
        withAnimation(.easeOut(duration: 0.3)) {
            showResetAnimation = true
        }
        
        // Hide reset animation
        withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
            showResetAnimation = false
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
    
    private func nuroEmoji(for day: Int) -> String {
        switch day {
        case 0: return "😵‍💫"
        case 1: return "😐"
        case 2...6: return "🙂"
        case 7...13: return "😃"
        case 14...29: return "📝"
        case 30...44: return "💻"
        case 45...59: return "😎"
        case 60...74: return "👩"
        case 75...89: return "☕️👫"
        case 90...119: return "❤️👫"
        case 120...149: return "🧑‍💼"
        case 150...199: return "💍"
        default: return "👨‍👩‍👧"
        }
    }
    
    private func nuroColor(for day: Int) -> Color {
        switch day {
        case 0: return .gray
        case 1: return .cyan
        case 2...3: return .orange
        case 4...6: return .purple
        case 7...13: return .yellow
        case 14...29: return .green
        case 30...44: return .red
        case 45...59: return .blue
        case 60...89: return .pink
        case 90...179: return .indigo
        case 180...364: return .mint
        default: return .mint
        }
    }
    
    private func nuroMicroAnimation(for day: Int) -> UnfapPlaceholderView.MicroAnimation {
        switch day {
        case 1: return .sitUp
        case 2: return .throwTissues
        case 7: return .smile
        case 45: return .smile
        default: return .none
        }
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

// MARK: - Clean Minimalist Orb
struct CleanMinimalistOrb: View {
    let auraScale: CGFloat
    let lifeforceScale: CGFloat
    let energyPulse: CGFloat
    let vitalityPulse: CGFloat
    let coreGlow: Double
    let outerEnergy: CGFloat
    let auraRotation: Double
    let streakDays: Int
    let showProgressRing: Bool
    
    @State private var pulse = false
    @State private var rotateRings = false
    @State private var neuronActivity = false
    @State private var milestoneGlow: CGFloat = 1.0
    @State private var particleBurst = false
    @State private var showMilestoneMessage = false
    @State private var milestoneMessage = ""
    @State private var milestoneTitle = ""
    
    // MARK: - Milestone System
    private func getMilestoneInfo(for days: Int) -> (title: String, message: String) {
        switch days {
        case 1:
            return (
                "Initiate",
                "Your journey begins. Every great change starts with a single step."
            )
        case 3:
            return (
                "Aware",
                "You're becoming more conscious of your patterns. Keep observing."
            )
        case 7:
            return (
                "Contender",
                "First week complete! Your willpower is growing stronger."
            )
        case 14:
            return (
                "Disciplined",
                "Two weeks of mastery. You're building new neural pathways."
            )
        case 30:
            return (
                "Rewired",
                "A month of transformation. Your brain is adapting to new patterns."
            )
        case 45:
            return (
                "Transformed",
                "Six weeks of dedication. You're becoming a new person."
            )
        case 60:
            return (
                "Master",
                "Two months of mastery. Your discipline is inspiring."
            )
        case 90:
            return (
                "Enlightened",
                "Three months of freedom. You've achieved what few can."
            )
        case 180:
            return (
                "Sage",
                "Six months of wisdom. You're a beacon of transformation."
            )
        case 365:
            return (
                "Transcendent",
                "One year of mastery. You've rewritten your story."
            )
        default:
            return ("", "")
        }
    }
    
    // MARK: - Dopamine-Maximizing Color System
    private var streakColors: (primary: Color, secondary: Color, accent: Color, glow: Color) {
        switch streakDays {
        case 0:
            return (Color.gray, Color.gray.opacity(0.6), Color.white, Color.gray)
        case 1:
            return (Color.cyan, Color.cyan.opacity(0.7), Color.white, Color.cyan)
        case 2...3:
            return (Color.orange, Color.orange.opacity(0.7), Color.white, Color.orange)
        case 4...6:
            return (Color.purple, Color.purple.opacity(0.7), Color.white, Color.purple)
        case 7...13:
            return (Color.yellow, Color.yellow.opacity(0.7), Color.white, Color.yellow)
        case 14...29:
            return (Color.green, Color.green.opacity(0.7), Color.white, Color.green)
        case 30...44:
            return (Color.red, Color.red.opacity(0.7), Color.white, Color.red)
        case 45...59:
            return (Color.blue, Color.blue.opacity(0.7), Color.white, Color.blue)
        case 60...89:
            return (
                Color(red: 1.0, green: 0.84, blue: 0.0),
                Color(red: 1.0, green: 0.84, blue: 0.0).opacity(0.7),
                Color.white,
                Color(red: 1.0, green: 0.84, blue: 0.0)
            )
        case 90...179:
            return (Color.indigo, Color.indigo.opacity(0.7), Color.white, Color.indigo)
        case 180...364:
            return (Color.mint, Color.mint.opacity(0.7), Color.white, Color.mint)
        default:
            // Transcendent (365+ days) - Glowing white effect
            return (
                Color.white,
                Color.white.opacity(0.8),
                Color.white,
                Color.white
            )
        }
    }
    
    private var isMilestoneDay: Bool {
        return [1, 2, 3, 4, 5, 6, 7, 14, 30, 45, 60, 75, 90].contains(streakDays) || 
               (streakDays > 90 && streakDays % 15 == 0)
    }
    
    private var milestoneIntensity: CGFloat {
        return isMilestoneDay ? 1.3 : 1.0
    }
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                // Dynamic streak-colored glass sphere
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(0.4),
                                streakColors.secondary.opacity(0.6),
                                streakColors.primary.opacity(0.7),
                                streakColors.primary.opacity(0.4)
                            ],
                            center: UnitPoint(x: 0.3, y: 0.2),
                            startRadius: 0,
                            endRadius: 70
                        )
                    )
                    .frame(width: 140, height: 140)
                    .scaleEffect(lifeforceScale * 1.02 * milestoneIntensity)
                    .shadow(color: Color.black.opacity(0.15), radius: lifeforceScale * 12)
                    .shadow(color: streakColors.glow.opacity(0.3 * milestoneIntensity), radius: lifeforceScale * 25)
                    .shadow(color: streakColors.glow.opacity(0.5 * milestoneIntensity), radius: lifeforceScale * 35 * milestoneGlow)
                    .animation(.easeInOut(duration: 0.8), value: streakColors.primary)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: milestoneGlow)
                
                // Dynamic reward-system core
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                streakColors.accent.opacity(0.95),
                                streakColors.accent.opacity(0.8),
                                streakColors.accent.opacity(0.4),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 15
                        )
                    )
                    .frame(width: 30 * milestoneIntensity, height: 30 * milestoneIntensity)
                    .scaleEffect(vitalityPulse * 1.15 * milestoneIntensity)
                    .shadow(color: streakColors.accent.opacity(0.9), radius: vitalityPulse * 15 * milestoneIntensity)
                    .shadow(color: streakColors.glow.opacity(0.6), radius: vitalityPulse * 20 * milestoneGlow)
                    .animation(.easeInOut(duration: 0.6), value: streakColors.accent)
                
                                // Dopamine-trigger energy pulse
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                streakColors.glow.opacity(0.7 * milestoneIntensity),
                                streakColors.glow.opacity(0.4 * milestoneIntensity),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 25
                        )
                    )
                    .frame(width: 50 * milestoneIntensity, height: 50 * milestoneIntensity)
                    .scaleEffect(energyPulse * 1.2 * milestoneGlow)
                    .opacity(0.8)
                    .blur(radius: 2)
                    .animation(.easeInOut(duration: 0.7), value: streakColors.glow)
                    .overlay(
                        ZStack {
                            // Luxury gamification reflection
                            Circle()
                                .stroke(
                                    AngularGradient(
                                        colors: [
                                            Color.clear,
                                            streakColors.accent.opacity(0.9 * milestoneIntensity),
                                            streakColors.glow.opacity(0.6 * milestoneIntensity),
                                            streakColors.accent.opacity(0.7 * milestoneIntensity),
                                            Color.clear,
                                            Color.clear
                                        ],
                                        center: .center,
                                        startAngle: .degrees(0),
                                        endAngle: .degrees(360)
                                    ),
                                    lineWidth: 2 * milestoneIntensity
                                )
                                .rotationEffect(.degrees(auraRotation))
                                .opacity(energyPulse * 0.8 * milestoneGlow)
                                .animation(.linear(duration: 3.0).repeatForever(autoreverses: false), value: auraRotation)
                                .animation(.easeInOut(duration: 0.5), value: streakColors.glow)
                                .blur(radius: 0.2)
                            
                            // Neuro-rewiring shimmer
                            Circle()
                                .stroke(
                                    AngularGradient(
                                        colors: [
                                            streakColors.accent.opacity(0.5),
                                            Color.clear,
                                            streakColors.primary.opacity(0.3),
                                            Color.clear,
                                            streakColors.accent.opacity(0.4),
                                            Color.clear
                                        ],
                                        center: .center,
                                        startAngle: .degrees(0),
                                        endAngle: .degrees(360)
                                    ),
                                    lineWidth: 1
                                )
                                .rotationEffect(.degrees(-auraRotation * 0.6))
                                .opacity(vitalityPulse * 0.6)
                                .animation(.easeInOut(duration: 0.4), value: streakColors.primary)
                                .blur(radius: 1)
                        }
                    )
                    .scaleEffect(pulse ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: pulse)



                
                // Dopamine progress ring
                if streakDays > 0 && showProgressRing {
                    Circle()
                        .trim(from: 0, to: min(Double(streakDays) / 30.0, 1.0))
                        .stroke(
                            LinearGradient(
                                colors: [
                                    streakColors.primary.opacity(0.6),
                                    streakColors.glow.opacity(0.9),
                                    streakColors.primary.opacity(0.6)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 3 * milestoneIntensity, lineCap: .round)
                        )
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(-90))
                        .opacity(0.8)
                        .shadow(color: streakColors.glow.opacity(0.4), radius: 6 * milestoneIntensity, x: 0, y: 0)
                        .animation(.easeInOut(duration: 0.8), value: streakColors.primary)
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .center)
        .overlay(
            Group {
                if showMilestoneMessage && !milestoneTitle.isEmpty && !milestoneMessage.isEmpty {
                    VStack(spacing: 12) {
                        Text(milestoneTitle)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(streakColors.primary)
                        
                        Text(milestoneMessage)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Theme.surfaceSecondary)
                            .shadow(color: Color.black.opacity(0.2), radius: 10)
                    )
                    .transition(.scale.combined(with: .opacity))
                }
            }
        )
        .onAppear {
            pulse.toggle()
            rotateRings.toggle()
            neuronActivity.toggle()
            
            // Milestone celebration effects
            if isMilestoneDay {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    milestoneGlow = 1.4
                }
                
                // Subtle particle burst for major milestones
                if [7, 14, 30, 45, 60, 75, 90].contains(streakDays) {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                        particleBurst = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        particleBurst = false
                    }
                }
            } else {
                milestoneGlow = 1.0
            }
        }
        .onChange(of: streakDays) { newDays in
            if isMilestoneDay {
                // Get milestone info
                let milestone = getMilestoneInfo(for: newDays)
                milestoneTitle = milestone.title
                milestoneMessage = milestone.message
                
                // Show milestone message
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    showMilestoneMessage = true
                    milestoneGlow = 1.4
                }
                
                // Haptic feedback
                let impact = UIImpactFeedbackGenerator(style: .heavy)
                impact.impactOccurred()
                
                // Auto-hide message after 4 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    withAnimation {
                        showMilestoneMessage = false
                    }
                }
            }
        }
    }
}

// MARK: - Badge Progress Grid System Aura Orb (Traditional Novice → Apprentice → Warrior System)
struct BadgeProgressGridAuraOrb: View {
    let auraScale: CGFloat
    let lifeforceScale: CGFloat
    let energyPulse: CGFloat
    let vitalityPulse: CGFloat
    let coreGlow: Double
    let outerEnergy: CGFloat
    let auraRotation: Double
    let streakDays: Int
    
    // Badge progress for the grid view (1/11 badges unlocked system)
    private var badgeInfo: (current: String, next: String, progress: Double, color: Color, totalBadges: Int, unlockedCount: Int) {
        switch streakDays {
        case 0:
            return ("Novice", "Apprentice", 0.0, Color.brown, 11, 1)
        case 1..<3:
            return ("Novice", "Apprentice", Double(streakDays) / 3.0, Color.brown, 11, 1)
        case 3..<7:
            return ("Apprentice", "Warrior", Double(streakDays - 3) / 4.0, Color.cyan, 11, 2)
        case 7..<15:
            return ("Warrior", "Guardian", Double(streakDays - 7) / 8.0, Color.blue, 11, 3)
        case 15..<30:
            return ("Guardian", "Champion", Double(streakDays - 15) / 15.0, Color.green, 11, 4)
        case 30..<45:
            return ("Champion", "Master", Double(streakDays - 30) / 15.0, Color.orange, 11, 5)
        case 45..<60:
            return ("Master", "Legend", Double(streakDays - 45) / 15.0, Color.red, 11, 6)
        case 60..<90:
            return ("Legend", "Hero", Double(streakDays - 60) / 30.0, Color.purple, 11, 7)
        case 90..<120:
            return ("Hero", "Mythic", Double(streakDays - 90) / 30.0, Color.pink, 11, 8)
        case 120..<180:
            return ("Mythic", "Legendary", Double(streakDays - 120) / 60.0, Color.indigo, 11, 9)
        case 180..<365:
            return ("Legendary", "Transcendent", Double(streakDays - 180) / 185.0, Color.yellow, 11, 10)
        default:
            return ("Transcendent", "MAX", 1.0, Color.white, 11, 11)
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Exact match to the minimalist orb image
            ZStack {
                // Main glass-like orb
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white,
                                Color(red: 0.9, green: 0.9, blue: 0.9),
                                Color(red: 0.7, green: 0.7, blue: 0.7),
                                Color(red: 0.5, green: 0.5, blue: 0.5)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                    .scaleEffect(vitalityPulse)
                
                // Subtle outer stroke
                Circle()
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    .frame(width: 160, height: 160)
                
                // Thin progress ring - exactly like your image
                Circle()
                    .trim(from: 0, to: badgeInfo.progress)
                    .stroke(
                        Color.white.opacity(0.8),
                        style: StrokeStyle(lineWidth: 2, lineCap: .round)
                    )
                    .frame(width: 166, height: 166)
                    .rotationEffect(.degrees(-90))
            }
            
            // Badge grid progress info
            VStack(spacing: 6) {
                Text("Badge Progress")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                Text("\(badgeInfo.unlockedCount)/\(badgeInfo.totalBadges) badges unlocked")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                
                Text("Current: \(badgeInfo.current)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(badgeInfo.color)
                
                if badgeInfo.current != "Transcendent" {
                    Text("Next: \(badgeInfo.next)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .center)
    }
}

// MARK: - Badge Progress Aura Orb (NPC → BETA → NORMIE → SIGMA → MINI CHAD System)
struct BadgeProgressAuraOrb: View {
    let auraScale: CGFloat
    let lifeforceScale: CGFloat
    let energyPulse: CGFloat
    let vitalityPulse: CGFloat
    let coreGlow: Double
    let outerEnergy: CGFloat
    let auraRotation: Double
    let streakDays: Int
    
    // Badge system: NPC → BETA → NORMIE → SIGMA → MINI CHAD progression
    private var currentBadge: (name: String, emoji: String, color: Color, requiredDays: Int, progress: Double) {
        switch streakDays {
        case 0:
            return ("NPC", "🤖", Color.cyan, 1, 0.0)
        case 1..<7:
            return ("BETA", "😅", Color.brown, 7, Double(streakDays) / 7.0)
        case 7..<14:
            return ("NORMIE", "😐", Color.cyan, 14, Double(streakDays - 7) / 7.0)
        case 14..<30:
            return ("SIGMA", "😎", Color.blue, 30, Double(streakDays - 14) / 16.0)
        case 30..<60:
            return ("MINI CHAD", "💪", Color.green, 60, Double(streakDays - 30) / 30.0)
        case 60..<90:
            return ("CHAD", "🗿", Color.orange, 90, Double(streakDays - 60) / 30.0)
        case 90..<180:
            return ("GIGA CHAD", "👑", Color.red, 180, Double(streakDays - 90) / 90.0)
        case 180..<365:
            return ("ALPHA CHAD", "⚡", Color.purple, 365, Double(streakDays - 180) / 185.0)
        default:
            return ("OMEGA CHAD", "🌈", Color.white, Int.max, 1.0)
        }
    }
    
    // Next badge info
    private var nextBadge: (name: String, emoji: String, daysLeft: Int)? {
        let current = currentBadge
        if current.name == "OMEGA CHAD" { return nil }
        
        switch current.name {
        case "NPC": return ("BETA", "😅", 1 - streakDays)
        case "BETA": return ("NORMIE", "😐", 7 - streakDays)
        case "NORMIE": return ("SIGMA", "😎", 14 - streakDays)
        case "SIGMA": return ("MINI CHAD", "💪", 30 - streakDays)
        case "MINI CHAD": return ("CHAD", "🗿", 60 - streakDays)
        case "CHAD": return ("GIGA CHAD", "👑", 90 - streakDays)
        case "GIGA CHAD": return ("ALPHA CHAD", "⚡", 180 - streakDays)
        case "ALPHA CHAD": return ("OMEGA CHAD", "🌈", 365 - streakDays)
        default: return nil
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Badge progress aura orb
            ZStack {
                // Outer progress ring - shows progress to next badge
                Circle()
                    .stroke(currentBadge.color.opacity(0.3), lineWidth: 8)
                    .frame(width: 140, height: 140)
                
                Circle()
                    .trim(from: 0, to: currentBadge.progress)
                    .stroke(
                        LinearGradient(
                            colors: [currentBadge.color, currentBadge.color.opacity(0.6)],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))
                    .scaleEffect(outerEnergy)
                
                // Main aura background
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                currentBadge.color.opacity(0.4 * coreGlow),
                                currentBadge.color.opacity(0.25 * coreGlow),
                                currentBadge.color.opacity(0.1 * coreGlow),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 65
                        )
                    )
                    .frame(width: 120, height: 120)
                    .scaleEffect(energyPulse)
                
                // Inner energy core
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(0.9),
                                currentBadge.color.opacity(coreGlow),
                                currentBadge.color.opacity(coreGlow * 0.7),
                                currentBadge.color.opacity(coreGlow * 0.4),
                                Color.clear
                            ],
                            center: UnitPoint(x: 0.3, y: 0.3),
                            startRadius: 5,
                            endRadius: 45
                        )
                    )
                    .frame(width: 100, height: 100)
                    .scaleEffect(vitalityPulse)
                    .overlay(
                        // Badge energy shimmer
                        Circle()
                            .fill(
                                AngularGradient(
                                    colors: [
                                        Color.clear,
                                        Color.white.opacity(0.9),
                                        currentBadge.color.opacity(0.8),
                                        Color.white.opacity(0.6),
                                        currentBadge.color.opacity(0.4),
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
                            .opacity(coreGlow * 0.8)
                            .blendMode(.overlay)
                    )
                    .shadow(color: currentBadge.color.opacity(0.6 * coreGlow), radius: 20, x: 0, y: 0)
                    .shadow(color: Color.white.opacity(0.3 * coreGlow), radius: 30, x: 0, y: 0)
                
                // Badge emoji in center
                Text(currentBadge.emoji)
                    .font(.system(size: 40))
                    .scaleEffect(lifeforceScale)
                    .shadow(color: currentBadge.color.opacity(0.5), radius: 10, x: 0, y: 0)
            }
            
            // Badge info
            VStack(spacing: 8) {
                // Current badge
                Text(currentBadge.name)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(currentBadge.color)
                
                // Progress indicator
                if let next = nextBadge {
                    VStack(spacing: 4) {
                        Text("Next: \(next.emoji) \(next.name)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("\(next.daysLeft) days to go")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                    }
                } else {
                    Text("🌈 Maximum Badge Achieved!")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                // Progress percentage
                Text("\(Int(currentBadge.progress * 100))% Complete")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(currentBadge.color.opacity(0.8))
            }
        }
        .frame(maxHeight: .infinity, alignment: .center)
    }
}

// MARK: - Pre-"Talk to Nuro" Dynamic Aura Orb (Complete Color System)
struct DynamicAuraOrb: View {
    let auraScale: CGFloat
    let lifeforceScale: CGFloat
    let energyPulse: CGFloat
    let vitalityPulse: CGFloat
    let coreGlow: Double
    let outerEnergy: CGFloat
    let auraRotation: Double
    let streakDays: Int
    
    // Get colors based on streak days
    private var colors: (core: [Color], aura: [Color], ring: [Color]) {
        switch streakDays {
        case 0:
            // Day 0: STUNNING first impression - Electric blue with gold accents
            return (
                core: [
                    Color.white,
                    Color(red: 0.3, green: 0.8, blue: 1.0), // Electric blue
                    Color(red: 0.0, green: 0.6, blue: 1.0), // Deep blue
                    Color(red: 1.0, green: 0.9, blue: 0.3), // Gold
                    Color(red: 0.2, green: 0.7, blue: 1.0)  // Bright blue
                ],
                aura: [
                    Color(red: 0.0, green: 0.7, blue: 1.0).opacity(0.6), // Bright blue
                    Color(red: 0.3, green: 0.9, blue: 1.0).opacity(0.4), // Cyan
                    Color(red: 1.0, green: 0.9, blue: 0.3).opacity(0.3), // Gold
                    Color.clear
                ],
                ring: [
                    Color.white,
                    Color(red: 0.0, green: 0.8, blue: 1.0),
                    Color(red: 1.0, green: 0.9, blue: 0.3)
                ]
            )
        case 1:
            return (
                core: [Color.white, Color.cyan, Color(red: 0.0, green: 0.8, blue: 1.0), Color.blue],
                aura: [Color.cyan.opacity(0.5), Color.blue.opacity(0.3), Color.clear],
                ring: [Color.cyan, Color.white, Color.blue]
            )
        case 2...3:
            return (
                core: [Color.white, Color.cyan, Color.teal, Color.blue],
                aura: [Color.cyan.opacity(0.5), Color.teal.opacity(0.3), Color.blue.opacity(0.2), Color.clear],
                ring: [Color.cyan, Color.teal, Color.blue]
            )
        case 4...6:
            return (
                core: [Color.white, Color.teal, Color.green, Color.cyan],
                aura: [Color.teal.opacity(0.5), Color.green.opacity(0.3), Color.cyan.opacity(0.2), Color.clear],
                ring: [Color.teal, Color.green, Color.cyan]
            )
        case 7...13:
            return (
                core: [Color.white, Color.green, Color.mint, Color.teal],
                aura: [Color.green.opacity(0.5), Color.mint.opacity(0.3), Color.teal.opacity(0.2), Color.clear],
                ring: [Color.green, Color.mint, Color.teal]
            )
        case 14...29:
            return (
                core: [Color.white, Color.green, Color.yellow, Color.mint],
                aura: [Color.green.opacity(0.5), Color.yellow.opacity(0.4), Color.mint.opacity(0.2), Color.clear],
                ring: [Color.green, Color.yellow, Color.mint]
            )
        case 30...59:
            return (
                core: [Color.white, Color.yellow, Color.orange, Color.green],
                aura: [Color.yellow.opacity(0.5), Color.orange.opacity(0.4), Color.green.opacity(0.2), Color.clear],
                ring: [Color.yellow, Color.orange, Color.green]
            )
        case 60...89:
            return (
                core: [Color.white, Color.orange, Color.red, Color.yellow],
                aura: [Color.orange.opacity(0.5), Color.red.opacity(0.4), Color.yellow.opacity(0.3), Color.clear],
                ring: [Color.orange, Color.red, Color.yellow]
            )
        case 90...119:
            return (
                core: [Color.white, Color.red, Color.pink, Color.orange],
                aura: [Color.red.opacity(0.5), Color.pink.opacity(0.4), Color.orange.opacity(0.3), Color.clear],
                ring: [Color.red, Color.pink, Color.orange]
            )
        case 120...179:
            return (
                core: [Color.white, Color.pink, Color.purple, Color.red],
                aura: [Color.pink.opacity(0.5), Color.purple.opacity(0.4), Color.red.opacity(0.3), Color.clear],
                ring: [Color.pink, Color.purple, Color.red]
            )
        case 180...364:
            return (
                core: [Color.white, Color.purple, Color.indigo, Color.pink],
                aura: [Color.purple.opacity(0.5), Color.indigo.opacity(0.4), Color.pink.opacity(0.3), Color.clear],
                ring: [Color.purple, Color.indigo, Color.pink]
            )
        default:
            // 365+ days: LEGENDARY rainbow iridescent
            return (
                core: [Color.white, Color.red, Color.orange, Color.yellow, Color.green, Color.blue, Color.purple],
                aura: [Color.red.opacity(0.4), Color.orange.opacity(0.3), Color.yellow.opacity(0.3), Color.green.opacity(0.3), Color.blue.opacity(0.3), Color.purple.opacity(0.3), Color.clear],
                ring: [Color.red, Color.orange, Color.yellow, Color.green, Color.blue, Color.purple]
            )
        }
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Dynamic multi-layered aura orb that evolves with your journey
            ZStack {
                // Outer aura field - changes color based on streak
                Circle()
                    .fill(
                        RadialGradient(
                            colors: colors.aura,
                            center: .center,
                            startRadius: 0,
                            endRadius: 85
                        )
                    )
                    .frame(width: 130, height: 130)
                    .scaleEffect(outerEnergy * 1.05)
                    .opacity(0.8)
                
                // Middle layer - enhanced color blending
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(0.4 * coreGlow),
                                colors.core[1].opacity(0.6 * coreGlow),
                                colors.core[2].opacity(0.4 * coreGlow),
                                colors.core[3].opacity(0.3 * coreGlow),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 55
                        )
                    )
                    .frame(width: 120, height: 120)
                    .scaleEffect(energyPulse * 1.08)
                    .opacity(0.75)
                
                // Inner energy layer - primary colors
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(0.9),
                                colors.core[1].opacity(coreGlow),
                                colors.core[2].opacity(coreGlow),
                                colors.core[3].opacity(coreGlow * 0.8),
                                Color.clear
                            ],
                            center: UnitPoint(x: 0.3, y: 0.3),
                            startRadius: 5,
                            endRadius: 40
                        )
                    )
                    .frame(width: 115, height: 115)
                    .scaleEffect(lifeforceScale)
                
                // Main dynamic core - full color spectrum
                Circle()
                    .fill(
                        RadialGradient(
                            colors: colors.core,
                            center: UnitPoint(x: 0.3, y: 0.3),
                            startRadius: 5,
                            endRadius: 50
                        )
                    )
                    .frame(width: 100, height: 100)
                    .scaleEffect(vitalityPulse)
                    .overlay(
                        // Dynamic energy shimmer
                        Circle()
                            .fill(
                                AngularGradient(
                                    colors: [
                                        Color.clear,
                                        Color.white.opacity(0.9),
                                        colors.core[1].opacity(0.8),
                                        colors.core[3].opacity(0.6),
                                        colors.core[2].opacity(0.4),
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
                            .opacity(coreGlow * 0.8)
                            .blendMode(.overlay)
                    )
                    .overlay(
                        // Counter-flow ring shimmer
                        Circle()
                            .fill(
                                AngularGradient(
                                    colors: [
                                        Color.clear,
                                        Color.clear,
                                        colors.ring[2].opacity(0.7),
                                        colors.ring[1].opacity(0.5),
                                        Color.clear,
                                        Color.white.opacity(0.4),
                                        colors.ring[0].opacity(0.3),
                                        Color.clear,
                                        Color.clear
                                    ],
                                    center: .center,
                                    startAngle: .degrees(0),
                                    endAngle: .degrees(360)
                                )
                            )
                            .rotationEffect(.degrees(-auraRotation * 0.7))
                            .opacity(coreGlow * 0.6)
                            .blendMode(.screen)
                    )
                    .overlay(
                        // Dynamic ring - changes with streak
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: colors.ring,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                            .frame(width: 95, height: 95)
                            .scaleEffect(energyPulse * 0.98)
                    )
                    .shadow(color: colors.core[1].opacity(0.8 * coreGlow), radius: 25, x: 0, y: 0)
                    .shadow(color: colors.core[3].opacity(0.6 * coreGlow), radius: 15, x: 0, y: 0)
                    .shadow(color: Color.white.opacity(0.4 * coreGlow), radius: 35, x: 0, y: 0)
                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                
                // Streak progress indicator
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                colors.ring[1].opacity(min(Double(streakDays) * 0.01, 0.6)),
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
            
            // Dynamic streak indicator
            if streakDays >= 365 {
                Text("🌈 LEGENDARY MASTER")
                    .font(.caption)
                    .foregroundColor(Color.purple)
                    .padding(.top, 8)
            } else if streakDays >= 180 {
                Text("👑 ADVANCED GUARDIAN")
                    .font(.caption)
                    .foregroundColor(Color.indigo)
                    .padding(.top, 8)
            } else if streakDays >= 90 {
                Text("🔥 STREAK WARRIOR")
                    .font(.caption)
                    .foregroundColor(Color.red)
                    .padding(.top, 8)
            } else if streakDays >= 30 {
                Text("⚡ RISING CHAMPION")
                    .font(.caption)
                    .foregroundColor(Color.orange)
                    .padding(.top, 8)
            } else if streakDays >= 7 {
                Text("🌟 BUILDING MOMENTUM")
                    .font(.caption)
                    .foregroundColor(Color.green)
                    .padding(.top, 8)
            }
        }
        .frame(maxHeight: .infinity, alignment: .center)
    }
}

// MARK: - Wednesday 11:18 PM Debug Testing Orb (Day 0 STUNNING Electric Blue)
struct Wednesday11_18PMDebugOrb: View {
    let auraScale: CGFloat
    let lifeforceScale: CGFloat
    let energyPulse: CGFloat
    let vitalityPulse: CGFloat
    let coreGlow: Double
    let outerEnergy: CGFloat
    let auraRotation: Double
    let streakDays: Int
    
    var body: some View {
        VStack(spacing: 24) {
            // Day 0 STUNNING first impression orb - Electric blue with gold accents
            ZStack {
                // Outer electric blue aura field
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 0.0, green: 0.7, blue: 1.0).opacity(0.6 * coreGlow), // Bright blue
                                Color(red: 0.3, green: 0.9, blue: 1.0).opacity(0.4 * coreGlow), // Cyan
                                Color(red: 1.0, green: 0.9, blue: 0.3).opacity(0.3 * coreGlow), // Gold
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 85
                        )
                    )
                    .frame(width: 130, height: 130)
                    .scaleEffect(outerEnergy * 1.05)
                    .opacity(0.8)
                
                // Middle layer - electric blue shimmer
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(0.4 * coreGlow),
                                Color(red: 0.3, green: 0.8, blue: 1.0).opacity(0.6 * coreGlow), // Electric blue
                                Color(red: 0.0, green: 0.6, blue: 1.0).opacity(0.4 * coreGlow), // Deep blue
                                Color(red: 1.0, green: 0.9, blue: 0.3).opacity(0.3 * coreGlow), // Gold
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 55
                        )
                    )
                    .frame(width: 120, height: 120)
                    .scaleEffect(energyPulse * 1.08)
                    .opacity(0.75)
                
                // Inner energy layer - electric blue focused
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(0.9),
                                Color(red: 0.3, green: 0.8, blue: 1.0).opacity(coreGlow), // Electric blue
                                Color(red: 0.0, green: 0.6, blue: 1.0).opacity(coreGlow), // Deep blue
                                Color(red: 1.0, green: 0.9, blue: 0.3).opacity(coreGlow * 0.8), // Gold
                                Color.clear
                            ],
                            center: UnitPoint(x: 0.3, y: 0.3),
                            startRadius: 5,
                            endRadius: 40
                        )
                    )
                    .frame(width: 115, height: 115)
                    .scaleEffect(lifeforceScale)
                
                // Main stunning core - electric blue to gold transition
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white,
                                Color(red: 0.3, green: 0.8, blue: 1.0), // Electric blue
                                Color(red: 0.0, green: 0.6, blue: 1.0), // Deep blue
                                Color(red: 1.0, green: 0.9, blue: 0.3), // Gold
                                Color(red: 0.2, green: 0.7, blue: 1.0)  // Bright blue
                            ],
                            center: UnitPoint(x: 0.3, y: 0.3),
                            startRadius: 5,
                            endRadius: 50
                        )
                    )
                    .frame(width: 100, height: 100)
                    .scaleEffect(vitalityPulse)
                    .overlay(
                        // Electric blue energy shimmer - Wednesday 11:18 PM test pattern
                        Circle()
                            .fill(
                                AngularGradient(
                                    colors: [
                                        Color.clear,
                                        Color.white.opacity(0.9),
                                        Color(red: 0.3, green: 0.8, blue: 1.0).opacity(0.8), // Electric blue
                                        Color(red: 1.0, green: 0.9, blue: 0.3).opacity(0.6), // Gold
                                        Color(red: 0.0, green: 0.7, blue: 1.0).opacity(0.4), // Bright blue
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
                            .opacity(coreGlow * 0.8)
                            .blendMode(.overlay)
                    )
                    .overlay(
                        // Counter-flow gold shimmer for testing
                        Circle()
                            .fill(
                                AngularGradient(
                                    colors: [
                                        Color.clear,
                                        Color.clear,
                                        Color(red: 1.0, green: 0.9, blue: 0.3).opacity(0.7), // Gold
                                        Color(red: 0.0, green: 0.8, blue: 1.0).opacity(0.5), // Electric blue
                                        Color.clear,
                                        Color.white.opacity(0.4),
                                        Color(red: 0.2, green: 0.7, blue: 1.0).opacity(0.3), // Bright blue
                                        Color.clear,
                                        Color.clear
                                    ],
                                    center: .center,
                                    startAngle: .degrees(0),
                                    endAngle: .degrees(360)
                                )
                            )
                            .rotationEffect(.degrees(-auraRotation * 0.7))
                            .opacity(coreGlow * 0.6)
                            .blendMode(.screen)
                    )
                    .overlay(
                        // Electric blue ring - debug test design
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white,
                                        Color(red: 0.0, green: 0.8, blue: 1.0),
                                        Color(red: 1.0, green: 0.9, blue: 0.3)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                            .frame(width: 95, height: 95)
                            .scaleEffect(energyPulse * 0.98)
                    )
                    .shadow(color: Color(red: 0.3, green: 0.8, blue: 1.0).opacity(0.8 * coreGlow), radius: 25, x: 0, y: 0)
                    .shadow(color: Color(red: 1.0, green: 0.9, blue: 0.3).opacity(0.6 * coreGlow), radius: 15, x: 0, y: 0)
                    .shadow(color: Color.white.opacity(0.4 * coreGlow), radius: 35, x: 0, y: 0)
                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                
                // Badge testing indicator - brighter for Day 0
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 0.0, green: 0.8, blue: 1.0).opacity(0.6), // Electric blue - more intense for testing
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 20
                        )
                    )
                    .frame(width: 60, height: 60)
                    .scaleEffect(lifeforceScale * 1.15) // Extra scale for Wednesday testing
            }
            
            // Debug indicator for Wednesday 11:18 PM testing
            Text("DEBUG: Day 0 STUNNING Electric Blue")
                .font(.caption)
                .foregroundColor(Color(red: 0.3, green: 0.8, blue: 1.0))
                .padding(.top, 8)
        }
        .frame(maxHeight: .infinity, alignment: .center)
    }
}

// MARK: - ACTUAL June 6th 11:21 PM Backup Life Force Energy Ball
struct ActualJune6thLifeForceOrb: View {
    let auraScale: CGFloat
    let lifeforceScale: CGFloat
    let energyPulse: CGFloat
    let vitalityPulse: CGFloat
    let coreGlow: Double
    let outerEnergy: CGFloat
    let auraRotation: Double
    let streakDays: Int

    var body: some View {
        VStack(spacing: 24) {
            // Multi-layered Life Force Energy Ball - EXACT June 6th backup
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
    }
}

// MARK: - June 6th Backup Aura Orb Configuration (Blue Version - Not Original)
struct June6thAuraOrb: View {
    let auraScale: CGFloat
    let lifeforceScale: CGFloat
    let energyPulse: CGFloat
    let vitalityPulse: CGFloat
    let coreGlow: Double
    let outerEnergy: CGFloat
    let auraRotation: Double
    
    @State private var ringAngle: Double = 0

    var body: some View {
        ZStack {
            // June 6th Electric Blue Glow Background - 220x220 frame
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.3, green: 0.8, blue: 1.0).opacity(0.4 * coreGlow), // Electric blue
                            Color(red: 0.0, green: 0.7, blue: 1.0).opacity(0.25 * coreGlow), // Bright blue
                            Color(red: 0.0, green: 0.6, blue: 1.0).opacity(0.12 * coreGlow), // Deep blue
                            Color(red: 0.2, green: 0.7, blue: 1.0).opacity(0.06 * coreGlow), // Bright blue
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 120
                    )
                )
                .frame(width: 220, height: 220)
                .scaleEffect(outerEnergy)
                .blur(radius: 8)

            // Main orb with June 6th white-to-electric-blue gradient - 150x150 main orb
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.95), // White center
                            Color(red: 0.3, green: 0.8, blue: 1.0).opacity(1.0 * coreGlow), // Electric blue
                            Color(red: 0.0, green: 0.6, blue: 1.0).opacity(0.7 * coreGlow), // Deep blue
                            Color(red: 0.2, green: 0.7, blue: 1.0).opacity(0.3 * coreGlow), // Bright blue
                            Color.clear // Transparent
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 80 * energyPulse
                    )
                )
                .frame(width: 150, height: 150)
                .scaleEffect(lifeforceScale)
                .shadow(color: Color(red: 0.0, green: 0.7, blue: 1.0).opacity(0.25), radius: 32, x: 0, y: 0)
                .shadow(color: Color(red: 0.3, green: 0.8, blue: 1.0).opacity(0.15), radius: 48, x: 0, y: 0)
                .shadow(color: Color.white.opacity(0.08), radius: 64, x: 0, y: 0)
                .overlay(
                    // Enhanced inner white core
                    Circle()
                        .fill(Color.white.opacity(0.18 * coreGlow))
                        .frame(width: 38, height: 38)
                        .scaleEffect(vitalityPulse)
                        .blur(radius: 0.5)
                )

            // June 6th Energy Flow System - Sleek dual-rotating energy rings
            ZStack {
                // Primary energy stream - 4-second continuous aura rotation
                Circle()
                    .trim(from: 0, to: 0.25)
                    .stroke(
                        AngularGradient(
                            colors: [
                                Color.white.opacity(0.9),
                                Color(red: 0.3, green: 0.8, blue: 1.0).opacity(0.6), // Electric blue
                                Color(red: 0.0, green: 0.7, blue: 1.0).opacity(0.4), // Bright blue
                                Color.clear,
                                Color.clear,
                                Color.clear
                            ],
                            center: .center,
                            startAngle: .degrees(0),
                            endAngle: .degrees(360)
                        ),
                        style: StrokeStyle(lineWidth: 1.5, lineCap: .round)
                    )
                    .frame(width: 180, height: 180)
                    .rotationEffect(.degrees(auraRotation))
                    .scaleEffect(auraScale)
                    .blur(radius: 0.4)
                
                // Counter-flow energy ring
                Circle()
                    .trim(from: 0, to: 0.15)
                    .stroke(
                        AngularGradient(
                            colors: [
                                Color(red: 0.0, green: 0.6, blue: 1.0).opacity(0.7), // Deep blue
                                Color.white.opacity(0.5),
                                Color(red: 0.2, green: 0.7, blue: 1.0).opacity(0.3), // Bright blue
                                Color.clear,
                                Color.clear
                            ],
                            center: .center,
                            startAngle: .degrees(0),
                            endAngle: .degrees(360)
                        ),
                        style: StrokeStyle(lineWidth: 1, lineCap: .round)
                    )
                    .frame(width: 190, height: 190)
                    .rotationEffect(.degrees(-auraRotation * 0.7)) // Counter-flow pattern
                    .scaleEffect(auraScale * 1.05)
                    .blur(radius: 0.6)
                
                // Internal energy pulse ring
                Circle()
                    .stroke(
                        Color.white.opacity(0.1 + 0.05 * sin(auraRotation * 0.1)),
                        lineWidth: 0.5
                    )
                    .frame(width: 165, height: 165)
                    .scaleEffect(energyPulse * 0.95)
                    .opacity(0.6 + 0.4 * sin(auraRotation * 0.08))
            }
        }
        .frame(width: 220, height: 220) // Exact June 6th size specifications
        .onAppear {
            // Ultra-smooth 15-second energy flow animation cycle
            withAnimation(.linear(duration: 15.0).repeatForever(autoreverses: false)) {
                ringAngle = 360
            }
        }
    }
}

struct PremiumGlassyOrb: View {
    @State private var ringAngle: Double = 0
    @State private var pulse: CGFloat = 1.0
    @State private var energyPulse: CGFloat = 1.0
    @State private var vitalityPulse: CGFloat = 1.0
    @State private var auraScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            // Blue glow fading to transparent
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.blue.opacity(0.4),
                            Color.blue.opacity(0.25),
                            Color.blue.opacity(0.12),
                            Color.blue.opacity(0.06),
                            Color.blue.opacity(0.0)
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 120
                    )
                )
                .frame(width: 220, height: 220)
                .blur(radius: 8)

            // Main orb with solid blue fading to transparent
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.95),
                            Color.blue.opacity(1.0),
                            Color.blue.opacity(0.7),
                            Color.blue.opacity(0.3),
                            Color.blue.opacity(0.0)
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 80 * pulse
                    )
                )
                .frame(width: 150, height: 150)
                .shadow(color: Color.blue.opacity(0.25), radius: 32, x: 0, y: 0)
                .shadow(color: Color.blue.opacity(0.15), radius: 48, x: 0, y: 0)
                .shadow(color: Color.white.opacity(0.08), radius: 64, x: 0, y: 0)
                .overlay(
                    // Faint inner white core
                    Circle()
                        .fill(Color.white.opacity(0.18))
                        .frame(width: 38, height: 38)
                        .blur(radius: 0.5)
                )

            // Sleek energy flow system
            ZStack {
                // Primary energy stream
                Circle()
                    .trim(from: 0, to: 0.25)
                    .stroke(
                        AngularGradient(
                            colors: [
                                Color.white.opacity(0.9),
                                Color.white.opacity(0.6),
                                Color.blue.opacity(0.4),
                                Color.clear,
                                Color.clear,
                                Color.clear
                            ],
                            center: .center,
                            startAngle: .degrees(0),
                            endAngle: .degrees(360)
                        ),
                        style: StrokeStyle(lineWidth: 1.5, lineCap: .round)
                    )
                    .frame(width: 180, height: 180)
                    .rotationEffect(.degrees(ringAngle))
                    .blur(radius: 0.4)
                
                // Counter-flow energy
                Circle()
                    .trim(from: 0, to: 0.15)
                    .stroke(
                        AngularGradient(
                            colors: [
                                Color.blue.opacity(0.7),
                                Color.white.opacity(0.5),
                                Color.clear,
                                Color.clear,
                                Color.clear
                            ],
                            center: .center,
                            startAngle: .degrees(0),
                            endAngle: .degrees(360)
                        ),
                        style: StrokeStyle(lineWidth: 1, lineCap: .round)
                    )
                    .frame(width: 190, height: 190)
                    .rotationEffect(.degrees(-ringAngle * 0.7))
                    .blur(radius: 0.6)
                
                // Internal energy pulse
                Circle()
                    .stroke(
                        Color.white.opacity(0.1 + 0.05 * sin(ringAngle * 0.1)),
                        lineWidth: 0.5
                    )
                    .frame(width: 165, height: 165)
                    .opacity(0.6 + 0.4 * sin(ringAngle * 0.08))
            }
            
        }
        .frame(width: 220, height: 220)
        .onAppear {
            // Ultra-smooth energy flow animation
            withAnimation(.linear(duration: 15.0).repeatForever(autoreverses: false)) {
                ringAngle = 360
            }
        }
    }
}


