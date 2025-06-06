import SwiftUI

struct EducationalView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    @State private var currentSlide = 0
    
    let slides = [
        Slide(
            title: "Rewire Your Brain",
            description: "Your brain will begin to heal and form new neural pathways as you maintain your streak.",
            icon: "brain.head.profile"
        ),
        Slide(
            title: "Track Your Progress",
            description: "Monitor your streak, symptoms, and improvements in real-time.",
            icon: "chart.line.uptrend.xyaxis"
        ),
        Slide(
            title: "Stay Accountable",
            description: "Join a community of like-minded individuals on the same journey.",
            icon: "person.2.fill"
        )
    ]
    
    var body: some View {
        VStack(spacing: Theme.padding32) {
            // Progress dots
            HStack(spacing: 8) {
                ForEach(0..<slides.count, id: \.self) { index in
                    Circle()
                        .fill(currentSlide == index ? Theme.primaryColor : Theme.primaryColor.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.top, Theme.padding32)
            
            TabView(selection: $currentSlide) {
                ForEach(0..<slides.count, id: \.self) { index in
                    VStack(spacing: Theme.padding32) {
                        Image(systemName: slides[index].icon)
                            .font(.system(size: 60))
                            .foregroundColor(Theme.primaryColor)
                        
                        Text(slides[index].title)
                            .font(.title.bold())
                        
                        Text(slides[index].description)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.padding32)
                            .foregroundColor(Theme.textColor.opacity(0.8))
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .never))
            
            Button(currentSlide == slides.count - 1 ? "Start Your Journey" : "Next") {
                if currentSlide == slides.count - 1 {
                    onboardingState.navigateTo(.dashboard)
                } else {
                    withAnimation {
                        currentSlide += 1
                    }
                }
            }
            .primaryButton()
            .padding(.horizontal, Theme.padding32)
            .padding(.bottom, Theme.padding32)
        }
        .foregroundColor(Theme.textColor)
        .background(Theme.backgroundColor)
    }
}

struct Slide {
    let title: String
    let description: String
    let icon: String
}

#Preview {
    EducationalView()
        .environmentObject(OnboardingState())
        .preferredColorScheme(.dark)
} 