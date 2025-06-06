import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    
    var body: some View {
        ZStack {
            // Background with stars
            StarsBackground()
            
            // Content
            VStack(spacing: Theme.padding24) {
                // Logo
                Text("No Fap")
                    .font(Theme.logoFont)
                    .foregroundColor(Theme.textColor)
                    .padding(.top, 60)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: Theme.padding16) {
                    Text("Welcome!")
                        .font(Theme.welcomeFont)
                        .foregroundColor(Theme.textColor)
                    
                    Text("Let's start by finding out if you have a problem with porn")
                        .font(Theme.bodyFont)
                        .foregroundColor(Theme.textColor.opacity(0.9))
                        .lineSpacing(4)
                }
                .padding(.horizontal, Theme.padding24)
                
                // Star rating with laurels
                HStack(spacing: -4) {
                    Image(systemName: "laurel.leading")
                        .imageScale(.large)
                        .foregroundColor(Theme.textColor.opacity(0.7))
                    
                    HStack(spacing: 4) {
                        ForEach(0..<5) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(Color.yellow)
                        }
                    }
                    .padding(.horizontal, 8)
                    
                    Image(systemName: "laurel.trailing")
                        .imageScale(.large)
                        .foregroundColor(Theme.textColor.opacity(0.7))
                }
                .padding(.top, Theme.padding32)
                
                Spacer()
                
                Button("Start Quiz") {
                    onboardingState.navigateTo(.quizIntro)
                }
                .primaryButton()
                .padding(.bottom, 48)
            }
        }
        .backgroundGradient()
    }
}

#Preview {
    WelcomeView()
        .environmentObject(OnboardingState())
} 
