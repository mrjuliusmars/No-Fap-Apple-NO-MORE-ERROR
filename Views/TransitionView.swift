import SwiftUI

struct TransitionView: View {
    let category: QuestionCategory
    let action: () -> Void
    @State private var showContent = false
    
    private var transitionContent: (title: String, message: String, icon: String) {
        switch category {
        case .awareness:
            return (
                "Let's Start With Understanding",
                "The first step to recovery is acknowledging where you are.",
                "eye"
            )
        case .consequences:
            return (
                "Impact Assessment",
                "Let's explore how this has affected different areas of your life...",
                "chart.line.uptrend.xyaxis"
            )
        case .struggles:
            return (
                "Past Attempts",
                "Many try to quit alone. Let's understand why that might not work...",
                "arrow.clockwise"
            )
        case .costAnalysis:
            return (
                "The Real Cost",
                "Sometimes we don't realize what we're giving up...",
                "dollarsign.circle"
            )
        case .solution:
            return (
                "Finding What Works",
                "There's a better way to break free...",
                "key.fill"
            )
        case .commitment:
            return (
                "Your Commitment",
                "Real change starts with a decision...",
                "hand.raised.fill"
            )
        case .goals:
            return (
                "Your Future",
                "Let's envision where you want to be...",
                "star.fill"
            )
        }
    }
    
    var body: some View {
        ZStack {
            // Animated stars background
            AnimatedStarsBackground()
            
            VStack(spacing: Theme.padding32) {
                Spacer()
                
                // Icon
                Image(systemName: transitionContent.icon)
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                    .opacity(showContent ? 1 : 0)
                    .scaleEffect(showContent ? 1 : 0.5)
                
                // Title
                Text(transitionContent.title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                
                // Message
                Text(transitionContent.message)
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.padding24)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                
                Spacer()
                
                // Continue button
                Button(action: action) {
                    Text("Continue")
                        .font(.system(size: 18, weight: .semibold))
                }
                .primaryButton()
                .padding(.horizontal, Theme.padding24)
                .padding(.bottom, 48)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
            }
        }
        .backgroundGradient()
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                showContent = true
            }
        }
    }
}

// MARK: - Preview
struct TransitionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview different categories
            TransitionView(category: .awareness, action: {})
                .previewDisplayName("Awareness")
            
            TransitionView(category: .consequences, action: {})
                .previewDisplayName("Consequences")
            
            TransitionView(category: .struggles, action: {})
                .previewDisplayName("Struggles")
            
            TransitionView(category: .goals, action: {})
                .previewDisplayName("Goals")
        }
    }
} 