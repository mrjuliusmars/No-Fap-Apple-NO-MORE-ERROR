import SwiftUI

struct DashboardView: View {
    @State private var streakDays = 2
    @State private var highScore = 89
    @State private var showCheckIn = false
    @State private var showChecklist = false
    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0
    @State private var timer: Timer?
    @State private var streakStartDate = Date()
    
    // Life force energy animation states
    @State private var lifeforceScale: CGFloat = 1.0
    @State private var energyPulse: CGFloat = 1.0
    @State private var coreGlow: Double = 0.8
    @State private var outerEnergy: CGFloat = 1.0
    @State private var auraRotation: Double = 0
    @State private var energyFlow: Double = 0
    @State private var vitalityPulse: CGFloat = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Top Navigation
                HStack {
                    Text("NO FAP")
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
                .padding(.vertical, 16)
                
                // Main Content
                ScrollView {
                    VStack(spacing: 24) {
                        // Life Force Energy Ball
                        VStack(spacing: 16) {
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
                            
                            VStack(spacing: 8) {
                                Text("You've been fap-free for:")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Theme.textSecondary)
                                
                                Text("\(streakDays) days")
                                    .font(.system(size: 48, weight: .bold, design: .rounded))
                                    .foregroundColor(Theme.textPrimary)
                                
                                // Time breakdown with live updating
                                Text("\(hours)hr \(minutes)m \(seconds)s")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(Theme.textSecondary)
                                    .padding(.top, 4)
                                
                                HStack(spacing: 6) {
                                    Image(systemName: "flame.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color(red: 1.0, green: 0.85, blue: 0.4))
                                    Text("Best Streak: \(highScore) days")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(Theme.textSecondary)
                                }
                                .padding(.top, 8)
                            }
                        }
                        .padding(.bottom, 36)
                        
                        // Action Buttons
                        HStack(spacing: 40) {
                            ActionButton(
                                icon: "circle.circle.fill",
                                title: "Checklist",
                                action: { showChecklist = true }
                            )
                            
                            ActionButton(
                                icon: "arrow.triangle.2.circlepath",
                                title: "Reset",
                                action: {}
                            )
                            
                            ActionButton(
                                icon: "bubble.left.and.bubble.right.fill",
                                title: "Join Chat",
                                action: {}
                            )
                        }
                        .padding(.horizontal, 24)
                        
                        // Challenge Card
                        VStack(alignment: .center, spacing: 16) {
                            Text("Current Challenge")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(Theme.textSecondary.opacity(0.8))
                                .tracking(1.2)
                                .textCase(.uppercase)
                            
                            Text("Reach 7 Days")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(Theme.textPrimary)
                            
                            Text("One day at a time.")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.purple.opacity(0.9))
                            
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
                                        .frame(width: geometry.size.width * 0.3, height: 8)
                                        .shadow(color: Color.yellow.opacity(0.4), radius: 4, x: 0, y: 2)
                                }
                            }
                            .frame(height: 8)
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 24)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.03))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    Color(red: 1.0, green: 0.85, blue: 0.4).opacity(0.2),
                                                    Color.clear
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 0.5
                                        )
                                )
                        )
                        .padding(.horizontal, 24)
                    }
                    .padding(.top, 48)
                }
                
                Spacer()
                
                // Panic Button
                VStack(spacing: 12) {
                    Button(action: {
                        // Panic button action - could trigger emergency protocol
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                            
                            Text("Panic Button")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .tracking(0.3)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color.red.opacity(0.4),
                                    Color.red.opacity(0.3)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(22)
                        .shadow(color: Color.red.opacity(0.2), radius: 6, x: 0, y: 3)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 12)
                
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
                    .background(Color.black.opacity(0.35))
                }
            }
        }
        .background(Theme.backgroundGradient.ignoresSafeArea())
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
            
            updateTimeComponents() // Calculate initial time
            startTimer() // Start the real-time counter
            startLifeforceAnimations() // Start energy animations
        }
        .onDisappear {
            stopTimer() // Stop timer when view disappears
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

#Preview {
    DashboardView()
} 