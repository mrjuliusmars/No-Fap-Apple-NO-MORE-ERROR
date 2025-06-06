import SwiftUI

struct FreeTrialOfferView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Environment(\.dismiss) private var dismiss
    @State private var isVisible = false
    @State private var showErrorAlert = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Premium gradient background
                Theme.backgroundGradient
                    .ignoresSafeArea()
                
                // Floating sparkles/stars
                ForEach(0..<15, id: \.self) { index in
                    Image(systemName: ["sparkles", "star.fill", "diamond.fill"].randomElement() ?? "sparkles")
                        .font(.system(size: CGFloat.random(in: 12...24), weight: .regular))
                        .foregroundColor(Color.white.opacity(Double.random(in: 0.3...0.7)))
                        .position(
                            x: CGFloat.random(in: 50...max(50, geometry.size.width - 50)),
                            y: CGFloat.random(in: 100...max(100, geometry.size.height - 200))
                        )
                        .animation(
                            .easeInOut(duration: Double.random(in: 2...4))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...2)),
                            value: isVisible
                        )
                        .opacity(isVisible ? 1.0 : 0.0)
                }
                
                // Close button
                VStack {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white.opacity(0.8))
                                .frame(width: 40, height: 40)
                        }
                        .padding(.top, 20)
                        .padding(.leading, 24)
                        Spacer()
                    }
                    Spacer()
                }
                
                VStack(spacing: 40) {
                    // Logo area with more top spacing
                    Text("Overkum")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.8).delay(0.1), value: isVisible)
                        .padding(.top, 60)
                    
                    VStack(spacing: 16) {
                        // Main headline
                        Text("One Time Offer")
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.8).delay(0.2), value: isVisible)
                        
                        Text("You will never see this again")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.8).delay(0.3), value: isVisible)
                    }
                    
                    // Main Free Trial Card
                    VStack(spacing: 20) {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.3, green: 0.5, blue: 1.0),
                                        Color(red: 0.6, green: 0.3, blue: 1.0),
                                        Color(red: 0.8, green: 0.2, blue: 0.9)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 280)
                            .overlay(
                                VStack(spacing: 20) {
                                    // FREE TRIAL text
                                    Text("FREE TRIAL")
                                        .font(.system(size: 36, weight: .black, design: .rounded))
                                        .foregroundColor(.white)
                                        .tracking(2)
                                    
                                    // $0.00 DUE NOW badge
                                    Text("$0.00 DUE NOW")
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(Color.black.opacity(0.6))
                                        )
                                    
                                    VStack(spacing: 8) {
                                        Text("Start the journey and become")
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundColor(.white)
                                        
                                        Text("the best version of you.")
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(.horizontal, 24)
                            )
                            .shadow(color: Color(red: 0.5, green: 0.3, blue: 1.0).opacity(0.6), radius: 25, x: 0, y: 15)
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 1.0).delay(0.4), value: isVisible)
                            .padding(.horizontal, 32)
                    }
                    
                    Spacer()
                    
                    // Bottom CTA section
                    VStack(spacing: 16) {
                        // Main CTA Button
                        Button(action: {
                            Task {
                                print("🔥 Free Trial Offer button pressed!")
                                
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                
                                await subscriptionManager.purchaseFreeTrialSubscription()
                                
                                if subscriptionManager.isSubscribed {
                                    hasCompletedOnboarding = true
                                    print("🔥 Free trial started!")
                                }
                            }
                        }) {
                            if subscriptionManager.isLoading {
                                HStack(spacing: 16) {
                                    ProgressView()
                                        .scaleEffect(0.9)
                                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                    Text("Processing...")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.black)
                                }
                            } else {
                                Text("Claim your limited offer now!")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(.black)
                            }
                        }
                        .frame(height: 64)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 32))
                        .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
                        .disabled(subscriptionManager.isLoading)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.8).delay(0.6), value: isVisible)
                        
                        // No commitment text
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("No commitment - cancel anytime.")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.8).delay(0.7), value: isVisible)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom + 20, 30))
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            isVisible = true
        }
        .alert("Purchase Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("There was an error processing your free trial. Please try again.")
        }
    }
}

#Preview {
    let previewSubscriptionManager = SubscriptionManager()
    let previewOnboardingState = OnboardingState()
    
    return FreeTrialOfferView()
        .environmentObject(previewOnboardingState)
        .environmentObject(previewSubscriptionManager)
} 