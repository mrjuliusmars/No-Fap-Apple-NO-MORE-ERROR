import SwiftUI

struct CalculatingView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    @Environment(\.dismiss) private var dismiss
    @State private var progress: Double = 0
    @State private var isVisible = false
    @State private var glowOpacity: Double = 0.3
    
    var body: some View {
        GeometryReader { geometry in
        ZStack {
                // Dark gradient background matching other screens
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
                
                // Subtle floating particles
                ForEach(0..<8, id: \.self) { index in
                    Circle()
                        .fill(Color.white.opacity(0.02))
                        .frame(width: CGFloat.random(in: 1...3))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .animation(
                            .easeInOut(duration: Double.random(in: 8...15))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...5)),
                            value: isVisible
                        )
                        .opacity(isVisible ? 0.1 : 0.02)
                }
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Main content - moved up
                    VStack(spacing: Theme.spacing48) {
                        // Progress circle with glow effect
                        ZStack {
                            // Glow effect - updated colors for dark background
                            Circle()
                                .fill(
                                    RadialGradient(
                                        gradient: Gradient(colors: [
                                            Color.cyan.opacity(glowOpacity),
                                            Color.cyan.opacity(glowOpacity * 0.5),
                                            Color.clear
                                        ]),
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 100
                                    )
                                )
                                .frame(width: 200, height: 200)
                                .blur(radius: 20)
                                .animation(
                                    Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                                    value: glowOpacity
                                )
                            
                            // Background circle
                            Circle()
                                .stroke(Color.white.opacity(0.2), lineWidth: 12)
                                .frame(width: 160, height: 160)
                    
                            // Progress circle - cyan color to match theme
                    Circle()
                        .trim(from: 0, to: progress)
                                .stroke(
                                    LinearGradient(
                                        colors: [Color.cyan, Color.cyan.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                                )
                                .frame(width: 160, height: 160)
                        .rotationEffect(.degrees(-90))
                                .animation(.easeInOut(duration: 0.3), value: progress)
                            
                            // Inner glow
                            Circle()
                                .fill(Color.cyan.opacity(0.1))
                                .frame(width: 140, height: 140)
                                .blur(radius: 10)
                    
                    // Percentage text
                    Text("\(Int(progress * 100))%")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(color: Color.cyan.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .scaleEffect(isVisible ? 1.0 : 0.8)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: isVisible)
                        
                        // Text content
                        VStack(spacing: Theme.spacing16) {
                            Text("Analyzing your responses")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .animation(.easeOut(duration: 0.6).delay(0.4), value: isVisible)
                    
                            Text("Creating your personalized recovery plan based on your specific needs and goals")
                                .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                                .lineSpacing(6)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .animation(.easeOut(duration: 0.6).delay(0.6), value: isVisible)
                        }
                        .padding(.horizontal, Theme.spacing32)
                }
                    
                    Spacer()
                    
                    // Bottom safe area spacing
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: geometry.safeAreaInsets.bottom + Theme.spacing32)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            isVisible = true
            glowOpacity = 0.8
            startCalculating()
        }
    }
    
    private func startCalculating() {
        // Multiple haptic generators for variety
        let lightGenerator = UIImpactFeedbackGenerator(style: .light)
        let mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
        let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
        let selectionGenerator = UISelectionFeedbackGenerator()
        
        // Prepare all generators
        lightGenerator.prepare()
        mediumGenerator.prepare()
        heavyGenerator.prepare()
        selectionGenerator.prepare()
        
        let totalDuration: Double = 4.0 // 4 seconds total
        let stepDuration: Double = 0.06 // Faster updates for smoother haptics (was 0.08)
        let totalSteps = Int(totalDuration / stepDuration)
        let progressPerStep = 1.0 / Double(totalSteps)
        
        func updateProgress(step: Int) {
            if step < totalSteps {
                let currentProgress = Double(step) * progressPerStep
                
                withAnimation(.easeInOut(duration: stepDuration)) {
                    progress += progressPerStep
                }
                
                // Enhanced haptic patterns that match the number movement
                
                // Every step gets a light haptic for continuous feeling
                if step % 2 == 0 {
                    lightGenerator.impactOccurred(intensity: 0.3)
                }
                
                // Medium haptics at 10% intervals for milestones
                if step % (totalSteps / 10) == 0 {
                    mediumGenerator.impactOccurred(intensity: 0.6)
                }
                
                // Selection feedback for number changes (every 5%)
                if step % (totalSteps / 20) == 0 {
                    selectionGenerator.selectionChanged()
                }
                
                // Special patterns for key moments
                switch Int(currentProgress * 100) {
                case 25:
                    // Quarter mark - double tap
                    mediumGenerator.impactOccurred(intensity: 0.7)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        lightGenerator.impactOccurred(intensity: 0.5)
                    }
                    
                case 50:
                    // Half way - triple tap
                    heavyGenerator.impactOccurred(intensity: 0.8)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        mediumGenerator.impactOccurred(intensity: 0.6)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        lightGenerator.impactOccurred(intensity: 0.4)
                    }
                    
                case 75:
                    // Three quarters - ascending pattern
                    lightGenerator.impactOccurred(intensity: 0.4)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        mediumGenerator.impactOccurred(intensity: 0.6)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        heavyGenerator.impactOccurred(intensity: 0.8)
                    }
                    
                case 90...99:
                    // Final stretch - rapid light taps
                    if step % 3 == 0 {
                        lightGenerator.impactOccurred(intensity: 0.5)
                    }
                    
                default:
                    break
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + stepDuration) {
                    updateProgress(step: step + 1)
                }
            } else {
                // Ensure we reach exactly 100%
                withAnimation(.easeInOut(duration: 0.3)) {
                progress = 1.0
                }
                
                // Epic completion sequence - crescendo of haptics
                heavyGenerator.impactOccurred(intensity: 1.0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    mediumGenerator.impactOccurred(intensity: 0.8)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    lightGenerator.impactOccurred(intensity: 0.6)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    selectionGenerator.selectionChanged()
                }
                
                // Navigate after completion
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    onboardingState.navigateTo(.analysisResult)
                }
            }
        }
        
        // Start the progress updates with a slight delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        updateProgress(step: 0)
        }
    }
}

#Preview {
    CalculatingView()
        .environmentObject(OnboardingState())
} 