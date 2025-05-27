import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    @State private var isVisible = false
    @State private var pulseAnimation = false
    @State private var hasInitialized = false
    
    // Stable random values for stars - generated once
    @State private var starPositions: [(x: CGFloat, y: CGFloat, size: CGFloat, opacity: Double, duration: Double)] = []
    @State private var mediumStarPositions: [(x: CGFloat, y: CGFloat, size: CGFloat, opacity: Double, duration: Double)] = []
    @State private var brightStarPositions: [(x: CGFloat, y: CGFloat, size: CGFloat, opacity: Double, duration: Double)] = []
    
    var body: some View {
        NavigationStack(path: $onboardingState.path) {
            GeometryReader { geometry in
            ZStack {
                    // Space-themed gradient background
                    LinearGradient(
                        colors: [
                            Color(red: 0.05, green: 0.1, blue: 0.3),     // Deep space blue
                            Color(red: 0.1, green: 0.05, blue: 0.25),    // Dark purple-blue
                            Color(red: 0.15, green: 0.02, blue: 0.2),    // Purple nebula
                            Color(red: 0.08, green: 0.01, blue: 0.15),   // Deep purple
                            Color(red: 0.02, green: 0.01, blue: 0.08),   // Almost black
                            Color.black                                   // Black void
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    // Distant stars - using stable positions
                    ForEach(starPositions.indices, id: \.self) { index in
                        Circle()
                            .fill(Color.white.opacity(0.6))
                            .frame(width: starPositions[index].size)
                            .position(x: starPositions[index].x, y: starPositions[index].y)
                            .opacity(pulseAnimation ? starPositions[index].opacity * 1.5 : starPositions[index].opacity)
                            .animation(
                                .easeInOut(duration: starPositions[index].duration)
                                .repeatForever(autoreverses: true),
                                value: pulseAnimation
                            )
                    }
                    
                    // Medium stars - using stable positions
                    ForEach(mediumStarPositions.indices, id: \.self) { index in
                        Circle()
                            .fill(Color.white.opacity(0.8))
                            .frame(width: mediumStarPositions[index].size)
                            .position(x: mediumStarPositions[index].x, y: mediumStarPositions[index].y)
                            .opacity(pulseAnimation ? mediumStarPositions[index].opacity * 1.3 : mediumStarPositions[index].opacity)
                            .animation(
                                .easeInOut(duration: mediumStarPositions[index].duration)
                                .repeatForever(autoreverses: true),
                                value: pulseAnimation
                            )
                    }
                    
                    // Bright stars - using stable positions
                    ForEach(brightStarPositions.indices, id: \.self) { index in
                        Circle()
                            .fill(Color.white)
                            .frame(width: brightStarPositions[index].size)
                            .position(x: brightStarPositions[index].x, y: brightStarPositions[index].y)
                            .opacity(pulseAnimation ? brightStarPositions[index].opacity : brightStarPositions[index].opacity * 0.7)
                            .animation(
                                .easeInOut(duration: brightStarPositions[index].duration)
                                .repeatForever(autoreverses: true),
                                value: pulseAnimation
                            )
                    }
                    
                    VStack(spacing: 0) {
                        // NO FAP logo - positioned under camera/status bar
                        VStack(spacing: Theme.spacing8) {
                            Text("NO FAP")
                                .font(.system(size: 40, weight: .black, design: .rounded))
                                .tracking(2)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color.white,
                                            Color.white.opacity(0.9),
                                            Color.white.opacity(0.8)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .offset(y: isVisible ? 0 : -30)
                                .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.3), value: isVisible)
                        }
                        .padding(.top, geometry.safeAreaInsets.top - 45)
                        
                        Spacer()
                        
                        // Main content section - centered
                        VStack(spacing: Theme.spacing32) {
                            // Welcome section
                            VStack(spacing: Theme.spacing20) {
                        Text("Welcome!")
                                    .font(.system(size: 36, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                                    .opacity(isVisible ? 1.0 : 0.0)
                                    .offset(y: isVisible ? 0 : 40)
                                    .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.6), value: isVisible)
                        
                                Text("Let's start by finding out if you\nhave a problem with porn")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white.opacity(0.85))
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(3)
                                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                                    .opacity(isVisible ? 1.0 : 0.0)
                                    .offset(y: isVisible ? 0 : 30)
                                    .animation(.easeOut(duration: 0.8).delay(0.9), value: isVisible)
                    }
                            .padding(.horizontal, Theme.spacing32)
                    
                            // Star rating
                            HStack(spacing: Theme.spacing8) {
                        Image(systemName: "laurel.leading")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                        
                                ForEach(0..<5, id: \.self) { index in
                                Image(systemName: "star.fill")
                                        .foregroundColor(Color(red: 1.0, green: 0.84, blue: 0.0))
                                        .font(.system(size: 18, weight: .bold))
                                        .shadow(color: Color.yellow.opacity(0.5), radius: 4, x: 0, y: 2)
                                        .scaleEffect(isVisible ? 1.0 : 0.3)
                                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.2 + Double(index) * 0.1), value: isVisible)
                                }
                        
                        Image(systemName: "laurel.trailing")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                    }
                            .opacity(isVisible ? 1.0 : 0.0)
                            .offset(y: isVisible ? 0 : 20)
                            .animation(.easeOut(duration: 0.8).delay(1.2), value: isVisible)
                        }
                    
                    Spacer()
                    
                        // CTA section - bottom
                        VStack(spacing: Theme.spacing16) {
                            Button(action: {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                
                                onboardingState.clearPath()
                                onboardingState.navigateTo(.quiz(1))
                            }) {
                                HStack(spacing: Theme.spacing12) {
                                    Text("Start Quiz")
                                        .font(.system(size: 20, weight: .bold))
                                    
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.system(size: 18, weight: .bold))
                                }
                                .foregroundColor(.black)
                                .frame(height: 48)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color.white,
                                                    Color.white.opacity(0.95),
                                                    Color.white.opacity(0.9)
                                                ],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
                                        .shadow(color: .white.opacity(0.1), radius: 1, x: 0, y: 1)
                                )
                            }
                            .scaleEffect(isVisible ? 1.0 : 0.9)
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(1.8), value: isVisible)
                        }
                        .padding(.horizontal, Theme.spacing32)
                        .padding(.bottom, geometry.safeAreaInsets.bottom + Theme.spacing32)
                    }
                }
            }
            .onAppear {
                // Initialize star positions once
                if !hasInitialized {
                    starPositions = (0..<8).map { _ in
                        (
                            x: CGFloat.random(in: 50...350),
                            y: CGFloat.random(in: 50...600),
                            size: CGFloat.random(in: 0.5...1.5),
                            opacity: Double.random(in: 0.1...0.4),
                            duration: Double.random(in: 3...5)
                        )
                    }
                    
                    mediumStarPositions = (0..<5).map { _ in
                        (
                            x: CGFloat.random(in: 50...350),
                            y: CGFloat.random(in: 50...600),
                            size: CGFloat.random(in: 1...2.5),
                            opacity: Double.random(in: 0.2...0.5),
                            duration: Double.random(in: 2...4)
                        )
                    }
                    
                    brightStarPositions = (0..<3).map { _ in
                        (
                            x: CGFloat.random(in: 50...350),
                            y: CGFloat.random(in: 50...600),
                            size: CGFloat.random(in: 2...3),
                            opacity: Double.random(in: 0.3...0.6),
                            duration: Double.random(in: 2...4)
                        )
                    }
                    
                    hasInitialized = true
                }
                
                isVisible = true
                pulseAnimation = true
            }
            .navigationDestination(for: OnboardingFlow.self) { flow in
                switch flow {
                case .welcome:
                    WelcomeView()
                case .quiz(let questionNumber):
                    QuizQuestionView(questionNumber: questionNumber)
                case .userInfo:
                    UserInfoView()
                case .calculating:
                    CalculatingView()
                case .analysisResult:
                    AnalysisResultView()
                case .symptoms(let categoryId):
                    SymptomsView(categoryId: categoryId)
                case .educational(let slideNumber):
                    EducationalSlideView(slideNumber: slideNumber)
                        .navigationBarBackButtonHidden()
                        .id("educational_\(slideNumber)")
                case .goals:
                    GoalsView()
                        .navigationBarBackButtonHidden()
                case .planReady:
                    PlanReadyView()
                        .navigationBarBackButtonHidden()
                case .paywall:
                    PaywallView()
                        .navigationBarBackButtonHidden()
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(OnboardingState())
} 
