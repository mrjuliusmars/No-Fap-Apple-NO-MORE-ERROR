import SwiftUI

struct ResultsView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    @State private var showScore = false
    @State private var showImpacts = false
    @State private var showRecommendation = false
    @State private var animatingCircle = false
    
    private var severityScore: Int {
        calculateSeverityScore(answers: onboardingState.quizAnswers)
    }
    
    private var impacts: [(title: String, description: String)] {
        [
            (
                "Mental Health",
                "Your answers indicate significant impacts on focus, motivation, and emotional well-being"
            ),
            (
                "Relationships",
                "Your responses suggest this is affecting your ability to form genuine connections"
            ),
            (
                "Productivity",
                "You could be losing up to 2-3 hours daily to this habit"
            ),
            (
                "Self-Image",
                "This is likely affecting your confidence and self-worth"
            )
        ]
    }
    
    var body: some View {
        ZStack {
            AnimatedStarsBackground()
            
            ScrollView {
                VStack(spacing: Theme.padding32) {
                    // Score circle
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.1), lineWidth: 12)
                            .frame(width: 200, height: 200)
                        
                        Circle()
                            .trim(from: 0, to: animatingCircle ? Double(severityScore) / 100 : 0)
                            .stroke(
                                severityScore > 75 ? Color.red :
                                    severityScore > 50 ? Color.orange :
                                    Color.yellow,
                                style: StrokeStyle(lineWidth: 12, lineCap: .round)
                            )
                            .frame(width: 200, height: 200)
                            .rotationEffect(.degrees(-90))
                        
                        VStack {
                            Text("\(showScore ? severityScore : 0)%")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Severity Score")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .padding(.top, Theme.padding32)
                    
                    // Impact areas
                    VStack(alignment: .leading, spacing: Theme.padding24) {
                        Text("Areas of Impact")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        ForEach(impacts.indices, id: \.self) { index in
                            if showImpacts {
                                ImpactRow(
                                    title: impacts[index].title,
                                    description: impacts[index].description,
                                    delay: Double(index) * 0.2
                                )
                            }
                        }
                    }
                    .padding(.horizontal, Theme.padding24)
                    
                    // Recommendation
                    if showRecommendation {
                        VStack(spacing: Theme.padding16) {
                            Text("Recommended Action")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(getRecommendation(severityScore: severityScore))
                                .font(.system(size: 18))
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, Theme.padding24)
                            
                            Button(action: {
                                onboardingState.navigateTo(.paywall)
                            }) {
                                Text("See Your Recovery Plan")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .primaryButton()
                            .padding(.horizontal, Theme.padding24)
                            .padding(.top, Theme.padding16)
                        }
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .padding(.bottom, Theme.padding32)
            }
        }
        .backgroundGradient()
        .onAppear {
            animateResults()
        }
    }
    
    private func animateResults() {
        // Animate score
        withAnimation(.easeOut(duration: 2.0)) {
            animatingCircle = true
            showScore = true
        }
        
        // Show impacts after score
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut(duration: 0.5)) {
                showImpacts = true
            }
        }
        
        // Show recommendation last
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            withAnimation(.easeOut(duration: 0.5)) {
                showRecommendation = true
            }
        }
    }
}

struct ImpactRow: View {
    let title: String
    let description: String
    let delay: Double
    
    @State private var opacity: Double = 0
    @State private var offset: CGFloat = 20
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.padding8) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            Text(description)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(Theme.padding16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .opacity(opacity)
        .offset(y: offset)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(delay)) {
                opacity = 1
                offset = 0
            }
        }
    }
}

// MARK: - Preview
struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview with mock data
            ResultsView()
                .environmentObject(OnboardingState(quizAnswers: [
                    1: 3, // High frequency
                    2: 2, // Medium duration
                    3: 3, // Often late
                    4: 3, // Relationship problems
                    5: 2  // Mental health impact
                ]))
                .previewDisplayName("High Severity")
            
            // Preview with lower severity
            ResultsView()
                .environmentObject(OnboardingState(quizAnswers: [
                    1: 1, // Low frequency
                    2: 1, // Short duration
                    3: 0, // Never late
                    4: 1, // Minor relationship issues
                    5: 1  // Slight mental health impact
                ]))
                .previewDisplayName("Low Severity")
        }
    }
} 