import SwiftUI

struct CalculatingView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    @State private var progress: Double = 0
    @State private var currentText = "Learning relapse triggers"
    
    private let loadingTexts = [
        "Learning relapse triggers",
        "Analyzing patterns",
        "Creating your plan",
        "Almost there"
    ]
    
    var body: some View {
        ZStack {
            // Animated stars background
            AnimatedStarsBackground()
            
            VStack(spacing: Theme.padding24) {
                Spacer()
                
                // Progress circle
                ZStack {
                    // Background circle
                    Circle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 12)
                        .frame(width: 200, height: 200)
                    
                    // Progress circle
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(Color.green, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(-90))
                    
                    // Percentage text
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Text("Calculating")
                    .font(Theme.titleFont)
                    .foregroundColor(Theme.textColor)
                
                Text(currentText)
                    .font(Theme.bodyFont)
                    .foregroundColor(Theme.textColor.opacity(0.6))
                
                Spacer()
            }
            .padding(.horizontal, Theme.padding24)
        }
        .backgroundGradient()
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        // Animate progress from 0 to 1 over 3 seconds
        withAnimation(.easeInOut(duration: 3)) {
            progress = 1.0
        }
        
        // Change text every 0.75 seconds
        var textIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.75, repeats: true) { timer in
            withAnimation {
                currentText = loadingTexts[textIndex % loadingTexts.count]
            }
            textIndex += 1
            
            // Stop timer after 3 seconds
            if textIndex >= 4 {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    onboardingState.navigateTo(.symptoms(1))
                }
            }
        }
    }
}

#Preview {
    CalculatingView()
        .environmentObject(OnboardingState())
} 