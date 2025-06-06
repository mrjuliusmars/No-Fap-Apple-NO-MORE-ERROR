import SwiftUI

struct GoalsView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    @State private var selectedGoals: Set<String> = []
    @State private var isVisible = false
    @State private var particlesAnimating = false
    
    private let goals = [
        (title: "Stronger relationships", icon: "heart.fill", color: Color.red),
        (title: "Better self-confidence", icon: "person.fill", color: Color.green),
        (title: "Improved mood", icon: "face.smiling.fill", color: Color.orange),
        (title: "More energy", icon: "bolt.fill", color: Color.yellow),
        (title: "Better intimacy", icon: "heart.text.square.fill", color: Color.pink),
        (title: "Better self-control", icon: "brain.head.profile", color: Color.cyan),
        (title: "Improved focus", icon: "sparkles", color: Color.blue)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Premium gradient background with enhanced depth
                LinearGradient(
                    colors: [
                        Color(red: 0.08, green: 0.15, blue: 0.28),   // Light navy top
                        Color(red: 0.06, green: 0.12, blue: 0.22),   // Slightly deeper navy
                        Color(red: 0.05, green: 0.1, blue: 0.2)      // Consistent light navy bottom
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Enhanced floating particles with premium glow
                ForEach(0..<15, id: \.self) { index in
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.white.opacity(0.08),
                                    Color.cyan.opacity(0.04),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 2
                            )
                        )
                        .frame(width: CGFloat.random(in: 2...4))
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
                        .opacity(particlesAnimating ? Double.random(in: 0.3...0.8) : 0.1)
                        .blur(radius: 1)
                }
                
                VStack(spacing: 0) {
                    // Clean top branding
                    VStack(spacing: Theme.spacing8) {
                        HStack {
                            Text("OVERKUM")
                                .font(.system(size: 24, weight: .black, design: .rounded))
                                .tracking(1)
                                .foregroundColor(.white)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.1), value: isVisible)
                            
                            Spacer()
                        }
                        .padding(.horizontal, Theme.spacing24)
                        .padding(.top, 15)
                    }
                    
                    // Main content
                    VStack(spacing: Theme.spacing24) {
                        // Premium title section with enhanced typography
                        VStack(spacing: Theme.spacing12) {
                            Text("What are your goals?")
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color.white,
                                            Color.white.opacity(0.95)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .offset(y: isVisible ? 0 : 25)
                                .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.3), value: isVisible)
                        }
                        .padding(.horizontal, Theme.spacing24)
                        .padding(.top, Theme.spacing16)
                        
                        // Compact goals list - no scroll
                        VStack(spacing: Theme.spacing12) {
                            ForEach(Array(goals.enumerated()), id: \.offset) { index, goal in
                                let isSelected = selectedGoals.contains(goal.title)
                                
                                Button(action: {
                                    // Haptic feedback
                                    let impact = UIImpactFeedbackGenerator(style: .medium)
                                    impact.impactOccurred()
                                    
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        if selectedGoals.contains(goal.title) {
                                            selectedGoals.remove(goal.title)
                                        } else {
                                            selectedGoals.insert(goal.title)
                                        }
                                    }
                                }) {
                                    CompactGoalSelectionRow(
                                        goal: goal,
                                        isSelected: isSelected
                                    )
                                }
                                .scaleEffect(isSelected ? 1.02 : 1.0)
                                .animation(.easeInOut(duration: 0.2), value: isSelected)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .offset(y: isVisible ? 0 : 30)
                                .animation(.easeOut(duration: 0.5).delay(0.7 + Double(index) * 0.1), value: isVisible)
                            }
                        }
                        .padding(.horizontal, Theme.spacing20)
                    }
                    
                    Spacer()
                    
                    // Premium fixed bottom CTA
                    VStack(spacing: Theme.spacing16) {
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            
                            onboardingState.selectedGoals = selectedGoals
                            onboardingState.navigateTo(.planReady)
                        }) {
                            HStack(spacing: Theme.spacing8) {
                                Text("Continue with \(selectedGoals.count) goal\(selectedGoals.count == 1 ? "" : "s")")
                                    .font(.system(size: 17, weight: .semibold))
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 15, weight: .bold))
                            }
                            .foregroundColor(.black)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 5)
                        }
                        .disabled(selectedGoals.isEmpty)
                        .opacity(selectedGoals.isEmpty ? 0.6 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: selectedGoals.isEmpty)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : 30)
                        .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(1.4), value: isVisible)
                    }
                    .padding(.horizontal, Theme.spacing24)
                    .padding(.bottom, geometry.safeAreaInsets.bottom + Theme.spacing16)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            isVisible = true
            particlesAnimating = true
        }
    }
}

struct CompactGoalSelectionRow: View {
    let goal: (title: String, icon: String, color: Color)
    let isSelected: Bool
    @State private var glowAnimation = false
    
    var body: some View {
        HStack(spacing: Theme.spacing12) {
            // Compact goal icon with enhanced styling
            ZStack {
                // Glow background
                Circle()
                    .fill(goal.color.opacity(glowAnimation ? 0.25 : 0.15))
                    .frame(width: 44, height: 44)
                    .blur(radius: 6)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: glowAnimation)
                
                Circle()
                    .fill(
                        isSelected ? 
                        LinearGradient(
                            colors: [goal.color, goal.color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.15),
                                Color.white.opacity(0.08)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(
                                isSelected ? 
                                goal.color.opacity(0.6) : 
                                Color.white.opacity(0.3),
                                lineWidth: 1
                            )
                    )
                    .shadow(
                        color: isSelected ? goal.color.opacity(0.3) : .black.opacity(0.1),
                        radius: isSelected ? 8 : 4,
                        x: 0,
                        y: isSelected ? 4 : 2
                    )
                
                Image(systemName: goal.icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(isSelected ? .white : goal.color)
                    .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
            }
            
            // Compact goal title - single line
            Text(goal.title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Compact selection indicator
            ZStack {
                Circle()
                    .fill(
                        isSelected ? 
                        LinearGradient(
                            colors: [Color.cyan, Color.cyan.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.1),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle()
                            .stroke(
                                isSelected ? 
                                Color.cyan.opacity(0.6) : 
                                Color.white.opacity(0.3),
                                lineWidth: 1
                            )
                    )
                    .shadow(
                        color: isSelected ? Color.cyan.opacity(0.2) : .clear,
                        radius: isSelected ? 6 : 0,
                        x: 0,
                        y: isSelected ? 3 : 0
                    )
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                }
            }
        }
        .padding(.horizontal, Theme.spacing16)
        .padding(.vertical, Theme.spacing12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [
                            isSelected ? 
                            Color.white.opacity(0.08) : 
                            Color.white.opacity(0.04),
                            isSelected ? 
                            Color.white.opacity(0.04) : 
                            Color.white.opacity(0.02)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    isSelected ? 
                                    Color.cyan.opacity(0.3) : 
                                    Color.white.opacity(0.1),
                                    isSelected ? 
                                    Color.cyan.opacity(0.1) : 
                                    Color.white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(
                    color: isSelected ? Color.cyan.opacity(0.1) : .black.opacity(0.05),
                    radius: isSelected ? 8 : 4,
                    x: 0,
                    y: isSelected ? 4 : 2
                )
        )
        .onAppear {
            glowAnimation = true
        }
    }
}

#Preview {
    NavigationStack {
        GoalsView()
            .environmentObject(OnboardingState())
    }
} 