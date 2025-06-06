import SwiftUI
import Foundation

struct HomeView: View {
    @StateObject private var streakManager = StreakManager()
    @State private var showingResetConfirmation = false
    @State private var showingPanicMode = false
    @State private var isVisible = false
    @State private var particlesAnimating = false
    @State private var currentTime = Date()
    @State private var discRotation = 0.0
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var timeBreakdown: (hours: Int, minutes: Int, seconds: Int) {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let timeInterval = Int(now.timeIntervalSince(startOfDay))
        
        let hours = (timeInterval / 3600) % 24
        let minutes = (timeInterval / 60) % 60
        let seconds = timeInterval % 60
        
        return (hours, minutes, seconds)
    }
    
    private var recoveryProgress: Int {
        return min(Int(Double(streakManager.currentStreak) * 1.5), 100)
    }
    
    private var currentWeekDay: Int {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: Date())
        return weekday == 1 ? 6 : weekday - 2 // Convert to 0-6 (Mon-Sun)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Dark starry background
                LinearGradient(
                    colors: [
                        Color(red: 0.05, green: 0.05, blue: 0.15),
                        Color(red: 0.02, green: 0.02, blue: 0.08),
                        Color.black
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Stars
                ForEach(0..<30, id: \.self) { index in
                    Circle()
                        .fill(Color.white.opacity(Double.random(in: 0.3...0.8)))
                        .frame(width: CGFloat.random(in: 1...3))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .animation(
                            .easeInOut(duration: Double.random(in: 10...20))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...8)),
                            value: particlesAnimating
                        )
                        .opacity(particlesAnimating ? Double.random(in: 0.4...0.9) : 0.3)
                }
                
                VStack(spacing: 0) {
                    // Header with QUITTR branding and icons
                    HStack {
                        Text("NO FAP")
                            .font(.custom("DM Sans", size: 28))
                            .fontWeight(.black)
                            .foregroundColor(.white)
                            .tracking(3)
                        
                        Spacer()
                        
                        HStack(spacing: 16) {
                            // Flame icon with number
                            HStack(spacing: 4) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.orange)
                                
                                Text("1")
                                    .font(.custom("DM Sans", size: 16))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            
                            Button(action: {}) {
                                Image(systemName: "heart.circle")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            Button(action: {}) {
                                Image(systemName: "power.circle")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 20)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.1), value: isVisible)
                    
                    // Week Progress Circles
                    HStack(spacing: 12) {
                        ForEach(0..<7, id: \.self) { dayIndex in
                            VStack(spacing: 8) {
                                ZStack {
                                    Circle()
                                        .fill(dayIndex <= currentWeekDay ? Color.purple.opacity(0.9) : Color.white.opacity(0.15))
                                        .frame(width: 40, height: 40)
                                    
                                    if dayIndex < currentWeekDay {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.white)
                                    } else if dayIndex == currentWeekDay {
                                        Text("—")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                }
                                
                                Text(["F", "S", "S", "M", "T", "W", "T"][dayIndex])
                                    .font(.custom("DM Sans", size: 12))
                                    .fontWeight(.medium)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 32)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.3), value: isVisible)
                    
                    Spacer()
                    
                    // Metallic Brushed Disc
                    ZStack {
                        // Metallic disc with brushed effect
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color(red: 0.85, green: 0.80, blue: 0.60),
                                        Color(red: 0.75, green: 0.68, blue: 0.48),
                                        Color(red: 0.65, green: 0.56, blue: 0.36),
                                        Color(red: 0.55, green: 0.44, blue: 0.24)
                                    ],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 80
                                )
                            )
                            .frame(width: 180, height: 180)
                            .overlay(
                                // Brushed metal effect with radial lines
                                Circle()
                                    .stroke(
                                        AngularGradient(
                                            colors: [
                                                Color.white.opacity(0.6),
                                                Color.black.opacity(0.3),
                                                Color.white.opacity(0.6),
                                                Color.black.opacity(0.3),
                                                Color.white.opacity(0.6),
                                                Color.black.opacity(0.3),
                                                Color.white.opacity(0.6),
                                                Color.black.opacity(0.3),
                                                Color.white.opacity(0.6)
                                            ],
                                            center: .center,
                                            startAngle: .degrees(discRotation),
                                            endAngle: .degrees(discRotation + 360)
                                        ),
                                        lineWidth: 1
                                    )
                            )
                            .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 8)
                            .rotationEffect(.degrees(discRotation))
                            .animation(
                                .linear(duration: 60)
                                .repeatForever(autoreverses: false),
                                value: discRotation
                            )
                    }
                    .opacity(isVisible ? 1.0 : 0.0)
                    .scaleEffect(isVisible ? 1.0 : 0.3)
                    .animation(.spring(response: 1.2, dampingFraction: 0.6).delay(0.5), value: isVisible)
                    
                    Spacer()
                    
                    // Main text content
                    VStack(spacing: 16) {
                        Text("You've been porn-free for:")
                            .font(.custom("DM Sans", size: 18))
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.8))
                        
                        // Large day counter
                        HStack(alignment: .bottom, spacing: 8) {
                            Text("\(streakManager.currentStreak)")
                                .font(.custom("DM Sans", size: 80))
                                .fontWeight(.black)
                                .foregroundColor(.white)
                            
                            Text(streakManager.currentStreak == 1 ? "days" : "days")
                                .font(.custom("DM Sans", size: 28))
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.bottom, 8)
                        }
                        
                        // Time breakdown
                        Text("\(timeBreakdown.hours)hr \(timeBreakdown.minutes)m \(timeBreakdown.seconds)s")
                            .font(.custom("DM Sans", size: 18))
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.8))
                            .onReceive(timer) { _ in
                                currentTime = Date()
                            }
                    }
                    .opacity(isVisible ? 1.0 : 0.0)
                    .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.7), value: isVisible)
                    
                    Spacer()
                    
                    // Three action buttons
                    HStack(spacing: 0) {
                        ActionButton(icon: "hand.raised.fill", title: "Pledged", action: {})
                        ActionButton(icon: "arrow.clockwise", title: "Reset", action: { showingResetConfirmation = true })
                        ActionButton(icon: "ellipsis", title: "More", action: {})
                    }
                    .padding(.horizontal, 32)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.9), value: isVisible)
                    
                    // Brain Rewiring Progress
                    VStack(spacing: 12) {
                        HStack {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(Color.cyan)
                                    .frame(width: 8, height: 8)
                                
                                Text("Brain Rewiring")
                                    .font(.custom("DM Sans", size: 16))
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            Text("2%")
                                .font(.custom("DM Sans", size: 16))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.white.opacity(0.1))
                                .frame(height: 6)
                            
                            Capsule()
                                .fill(Color.cyan)
                                .frame(width: max(12, geometry.size.width * 0.75 * 0.02), height: 6)
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 32)
                    .padding(.top, 24)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(1.1), value: isVisible)
                    
                    // Panic Button
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .heavy)
                        impact.impactOccurred()
                        showingPanicMode = true
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Panic Button")
                                .font(.custom("DM Sans", size: 18))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 28)
                                        .stroke(Color.red, lineWidth: 2)
                                )
                        )
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 16)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(1.3), value: isVisible)
                    
                    // Bottom Navigation
                    HStack(spacing: 0) {
                        BottomNavButton(icon: "apps")
                        BottomNavButton(icon: "chart.bar.fill")
                        BottomNavButton(icon: "star.square")
                        BottomNavButton(icon: "message")
                        BottomNavButton(icon: "line.3.horizontal")
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 24)
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 20)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(1.5), value: isVisible)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            isVisible = true
            particlesAnimating = true
            discRotation = 360
        }
        .alert("Reset Streak?", isPresented: $showingResetConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                streakManager.resetStreak()
            }
        } message: {
            Text("This will reset your current streak to 0. This action cannot be undone.")
        }
        .fullScreenCover(isPresented: $showingPanicMode) {
            PanicModeView()
        }
    }
}

// Action button component
struct ActionButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                
                Text(title)
                    .font(.custom("DM Sans", size: 12))
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.7))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
        }
    }
}

// Bottom navigation button
struct BottomNavButton: View {
    let icon: String
    
    var body: some View {
        Button(action: {}) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
        }
    }
}

#Preview {
    HomeView()
} 