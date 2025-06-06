import SwiftUI

struct QuizIntroView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    
    var body: some View {
        VStack(spacing: Theme.padding24) {
            Spacer()
            
            Text("Let's start by finding out if you have a problem with porn")
                .font(Theme.titleFont)
                .foregroundColor(Theme.textColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Theme.padding24)
            
            Spacer()
            
            Button("Start Quiz") {
                onboardingState.navigateTo(.quiz(1))
            }
            .primaryButton()
            .padding(.horizontal, Theme.padding24)
            .padding(.bottom, Theme.padding32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.backgroundColor)
    }
}

#Preview {
    QuizIntroView()
        .environmentObject(OnboardingState())
} 