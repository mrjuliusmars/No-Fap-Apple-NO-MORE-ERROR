import SwiftUI

struct QuizQuestionView: View {
    let questionNumber: Int
    @EnvironmentObject var onboardingState: OnboardingState
    @Environment(\.dismiss) private var dismiss
    @State private var selectedOption: Int? = nil
    @State private var isVisible = false
    
    private var question: QuizQuestion {
        quizQuestions[questionNumber - 1]
    }
    
    private var progress: CGFloat {
        CGFloat(questionNumber) / CGFloat(quizQuestions.count)
    }
    
    // Safe access to current question's answer
    private var currentAnswer: Int? {
        onboardingState.quizAnswers[questionNumber]
    }
    
    // Check if quiz has been completed (all questions answered)
    private var isQuizCompleted: Bool {
        for i in 1...quizQuestions.count {
            if onboardingState.quizAnswers[i] == nil {
                return false
            }
        }
        return true
    }
    
    var body: some View {
        GeometryReader { geometry in
        ZStack {
                // Updated gradient background to match the image
                LinearGradient(
                    colors: [
                        Color(red: 0.08, green: 0.15, blue: 0.28),   // Light navy top
                        Color(red: 0.06, green: 0.12, blue: 0.22),   // Slightly deeper navy
                        Color(red: 0.05, green: 0.1, blue: 0.2)      // Consistent light navy bottom
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Subtle floating particles
                ForEach(0..<6, id: \.self) { index in
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
                    // Top branding
                    VStack(spacing: Theme.spacing8) {
                        HStack {
                            // Back button - only show if quiz hasn't been completed
                            if !isQuizCompleted {
                                Button(action: {
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                    
                                    if questionNumber == 1 {
                                        // Go back to welcome screen for first question
                                        onboardingState.navigateTo(.welcome)
                                    } else {
                                        // Go to previous question
                                        onboardingState.navigateTo(.quiz(questionNumber - 1))
                                    }
                                }) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.8))
                                        .padding(12)
                                }
                                .opacity(isVisible ? 1.0 : 0.0)
                                .animation(.easeOut(duration: 0.6).delay(0.2), value: isVisible)
                            } else {
                                // Empty space to maintain layout when back button is hidden
                                Spacer()
                                    .frame(width: 42) // Match the back button width
                            }
                            
                            Spacer()
                            
                            Text("UNFAP")
                                .font(.system(size: 28, weight: .black, design: .rounded))
                                .tracking(1)
                                .foregroundColor(.white)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .animation(.easeOut(duration: 0.6).delay(0.1), value: isVisible)
                            
                            Spacer()
                            
                            // Skip option
                            Button("Skip") {
                                onboardingState.navigateTo(.userInfo)
                            }
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.horizontal, Theme.spacing24)
                        .padding(.top, 10)
                        
                        // Progress section
                        VStack(spacing: Theme.spacing8) {
                            HStack {
                                Text("Question \(questionNumber) of \(quizQuestions.count)")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.7))
                                Spacer()
                            }
                            
                            GeometryReader { progressGeometry in
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .fill(Color.white.opacity(0.2))
                                        .frame(height: 4)
                                        .cornerRadius(2)
                                    
                                    Rectangle()
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.white, Color.white.opacity(0.8)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(width: progressGeometry.size.width * progress, height: 4)
                                        .cornerRadius(2)
                                        .animation(.easeInOut(duration: 0.3), value: progress)
                        }
                    }
                    .frame(height: 4)
                        }
                        .padding(.horizontal, Theme.spacing24)
                    }
                    
                    // Question content
                    VStack(spacing: Theme.spacing32) {
                        // Question title
                    Text(question.question)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        .lineSpacing(4)
                            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                            .opacity(isVisible ? 1.0 : 0.0)
                            .offset(y: isVisible ? 0 : 30)
                            .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.3), value: isVisible)
                            .padding(.horizontal, Theme.spacing24)
                            .padding(.top, Theme.spacing24)
                
                // Options
                        VStack(spacing: Theme.spacing16) {
                    ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                        Button(action: {
                                    // Haptic feedback
                                    let impact = UIImpactFeedbackGenerator(style: .medium)
                                    impact.impactOccurred()
                                    
                            selectedOption = index
                            onboardingState.quizAnswers[questionNumber] = index
                            
                            // Delay navigation to show the selection
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                if questionNumber == quizQuestions.count {
                                    onboardingState.navigateTo(.userInfo)
                                } else {
                                    onboardingState.navigateTo(.quiz(questionNumber + 1))
                                }
                            }
                        }) {
                                    HStack(spacing: Theme.spacing16) {
                                        // Clean circular number indicator
                                        ZStack {
                                            Circle()
                                                .fill(
                                                    selectedOption == index || currentAnswer == index ?
                                                    Color.cyan : Color.white.opacity(0.1)
                                                )
                                                .frame(width: 36, height: 36)
                                                .overlay(
                                                    Circle()
                                                        .stroke(
                                                            selectedOption == index || currentAnswer == index ?
                                                            Color.cyan : Color.white.opacity(0.3),
                                                            lineWidth: 2
                                                        )
                                                )
                                            
                                            Text("\(index + 1)")
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(
                                                    selectedOption == index || currentAnswer == index ?
                                                    .black : .white
                                                )
                                        }
                                        
                                        // Option text
                            Text(option)
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Spacer()
                        }
                                    .padding(.horizontal, Theme.spacing20)
                                    .padding(.vertical, Theme.spacing16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(
                                                selectedOption == index || currentAnswer == index ?
                                                Color.white.opacity(0.04) : Color.white.opacity(0.015)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(
                                                        selectedOption == index || currentAnswer == index ? 
                                                        Color.cyan.opacity(0.2) : Color.white.opacity(0.05),
                                                        lineWidth: 1
                                                    )
                                            )
                                    )
                }
                                .scaleEffect(selectedOption == index || currentAnswer == index ? 1.02 : 1.0)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .offset(y: isVisible ? 0 : 30)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5 + Double(index) * 0.1), value: isVisible)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedOption)
                            }
                        }
                        .padding(.horizontal, Theme.spacing24)
                    }
                
                Spacer()
                
                    // Bottom spacing
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: geometry.safeAreaInsets.bottom + Theme.spacing32)
            }
        }
        }
        .navigationBarHidden(true)
        .onAppear {
            isVisible = true
            // Load any previously selected answer
            selectedOption = currentAnswer
        }
    }
}

#Preview {
    NavigationStack {
        QuizQuestionView(questionNumber: 1)
            .environmentObject(OnboardingState())
    }
} 
