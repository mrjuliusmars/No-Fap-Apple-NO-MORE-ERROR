import SwiftUI
import StoreKit

struct PaywallView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    @State private var selectedPlan: SubscriptionPlan = .yearly
    @State private var showFeatures = false
    @State private var isLoading = false
    
    private let features = [
        (icon: "brain.head.profile", title: "Personalized Recovery Plan", description: "Based on your assessment results"),
        (icon: "chart.line.uptrend.xyaxis", title: "Progress Tracking", description: "Monitor your streaks and improvements"),
        (icon: "person.2.fill", title: "Community Support", description: "Connect with others on the same journey"),
        (icon: "lock.shield", title: "Emergency Tools", description: "Instant urge management techniques"),
        (icon: "book.fill", title: "Expert Resources", description: "Science-backed recovery materials"),
        (icon: "bell.badge", title: "Smart Notifications", description: "AI-powered support when you need it most")
    ]
    
    enum SubscriptionPlan: String, CaseIterable {
        case monthly = "Monthly"
        case yearly = "Yearly"
        
        var price: String {
            switch self {
            case .monthly: return "$14.99"
            case .yearly: return "$99.99"
            }
        }
        
        var savings: String? {
            switch self {
            case .yearly: return "Save 45%"
            default: return nil
            }
        }
        
        var period: String {
            switch self {
            case .monthly: return "/month"
            case .yearly: return "/year"
            }
        }
    }
    
    var body: some View {
        ZStack {
            AnimatedStarsBackground()
            
            ScrollView {
                VStack(spacing: Theme.padding32) {
                    // Header
                    VStack(spacing: Theme.padding16) {
                        Text("Your Recovery Journey Starts Here")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("Join thousands who have successfully broken free")
                            .font(.system(size: 18))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, Theme.padding32)
                    
                    // Features
                    VStack(alignment: .leading, spacing: Theme.padding24) {
                        ForEach(features.indices, id: \.self) { index in
                            FeatureRow(
                                icon: features[index].icon,
                                title: features[index].title,
                                description: features[index].description,
                                delay: Double(index) * 0.1
                            )
                        }
                    }
                    .padding(.horizontal, Theme.padding24)
                    
                    // Subscription Plans
                    VStack(spacing: Theme.padding16) {
                        Text("Choose Your Plan")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        HStack(spacing: Theme.padding16) {
                            ForEach(SubscriptionPlan.allCases, id: \.self) { plan in
                                PlanCard(
                                    plan: plan,
                                    isSelected: selectedPlan == plan,
                                    action: { selectedPlan = plan }
                                )
                            }
                        }
                        .padding(.horizontal, Theme.padding24)
                    }
                    
                    // Subscribe Button
                    Button(action: {
                        isLoading = true
                        // TODO: Implement subscription logic
                    }) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            }
                            Text("Start Your Journey")
                                .font(.system(size: 18, weight: .semibold))
                        }
                    }
                    .primaryButton()
                    .padding(.horizontal, Theme.padding24)
                    
                    // Terms
                    Text("Cancel anytime. Subscription auto-renews.")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.top, Theme.padding8)
                }
                .padding(.bottom, Theme.padding32)
            }
        }
        .backgroundGradient()
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    let delay: Double
    
    @State private var opacity: Double = 0
    @State private var offset: CGFloat = 20
    
    var body: some View {
        HStack(spacing: Theme.padding16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: Theme.padding4) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))
            }
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

struct PlanCard: View {
    let plan: PaywallView.SubscriptionPlan
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Theme.padding8) {
                Text(plan.rawValue)
                    .font(.system(size: 18, weight: .semibold))
                
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(plan.price)
                        .font(.system(size: 24, weight: .bold))
                    
                    Text(plan.period)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                if let savings = plan.savings {
                    Text(savings)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(Theme.padding16)
            .background(isSelected ? Color.white.opacity(0.2) : Color.white.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
} 