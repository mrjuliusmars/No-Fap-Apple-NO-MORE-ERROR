import SwiftUI

struct MotivationView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    @State private var selectedCardIndex = 0
    
    private let motivationalCards = [
        (title: "Your Future Self", content: "Every day you stay clean is a gift to your future self. Build the life you deserve.", icon: "person.fill.checkmark"),
        (title: "Reclaim Control", content: "You are stronger than your urges. Take back control of your mind and life.", icon: "brain.head.profile"),
        (title: "Real Connections", content: "Experience genuine relationships and deep emotional connections.", icon: "heart.circle.fill")
    ]
    
    var body: some View {
        ZStack {
            StarsBackground()
            
            VStack(spacing: Theme.padding32) {
                Text("Your Motivation")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 60)
                
                Text("Remember why you started")
                    .font(.system(size: 17))
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                // Motivation Cards
                TabView(selection: $selectedCardIndex) {
                    ForEach(0..<motivationalCards.count, id: \.self) { index in
                        VStack(spacing: Theme.padding24) {
                            Image(systemName: motivationalCards[index].icon)
                                .font(.system(size: 60))
                                .foregroundColor(Theme.primaryColor)
                            
                            Text(motivationalCards[index].title)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(motivationalCards[index].content)
                                .font(.system(size: 17))
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, Theme.padding24)
                        }
                        .padding(Theme.padding32)
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(20)
                        .padding(.horizontal, Theme.padding24)
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .frame(height: 300)
                
                Spacer()
                
                // Continue Button
                Button(action: {
                    onboardingState.navigateTo(.goals)
                }) {
                    HStack(spacing: 8) {
                        Text("Set Your Goals")
                        Image(systemName: "chevron.right")
                    }
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .foregroundColor(Theme.backgroundColor)
                    .frame(height: 52)
                    .frame(maxWidth: .infinity)
                    .background(Theme.primaryColor)
                    .cornerRadius(26)
                }
                .padding(.horizontal, Theme.padding24)
                .padding(.bottom, 48)
            }
        }
        .backgroundGradient()
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        MotivationView()
            .environmentObject(OnboardingState())
    }
} 