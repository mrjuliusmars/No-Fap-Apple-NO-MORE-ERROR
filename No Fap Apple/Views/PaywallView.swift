import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Environment(\.dismiss) private var dismiss
    @State private var isVisible = false
    @State private var showErrorAlert = false
    @State private var showDiscountOffer = false
    @State private var discountOfferShownThisSession = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("hasSeenDiscountOffer") private var hasSeenDiscountOffer = false
    
    // Calculate quit date based on quiz answers (simulating analysis)
    private var quitDate: String {
        let calendar = Calendar.current
        
        if let futureDate = calendar.date(byAdding: .day, value: 60, to: Date()) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: futureDate)
        }
        
        return "Aug 23, 2025"
    }
    
    private var userName: String {
        let name = onboardingState.name.trimmingCharacters(in: .whitespacesAndNewlines)
        return name.isEmpty ? "Friend" : name.components(separatedBy: " ").first ?? name
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Premium gradient background
                Theme.backgroundGradient
                    .ignoresSafeArea()
                
                // Subtle floating particles
                ForEach(0..<12, id: \.self) { index in
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
                        .opacity(isVisible ? 0.15 : 0.02)
                }
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Reduced top spacing to center content
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: geometry.safeAreaInsets.top + 60)
                        
                        VStack(spacing: 32) {
                            // Hero section
                            VStack(spacing: 24) {
                                Text("\(userName), we've made you\na custom plan.")
                                    .font(.system(size: 26, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(3)
                                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                                    .opacity(isVisible ? 1.0 : 0.0)
                                    .animation(.easeOut(duration: 0.8).delay(0.1), value: isVisible)
                                
                                VStack(spacing: 16) {
                                    Text("You will quit porn by:")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.white.opacity(0.8))
                                        .opacity(isVisible ? 1.0 : 0.0)
                                        .animation(.easeOut(duration: 0.8).delay(0.2), value: isVisible)
                                    
                                    Text(quitDate)
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 25)
                                                .fill(
                                                    LinearGradient(
                                                        colors: [Color.white, Color.white.opacity(0.95)],
                                                        startPoint: .top,
                                                        endPoint: .bottom
                                                    )
                                                )
                                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                                        )
                                        .opacity(isVisible ? 1.0 : 0.0)
                                        .animation(.easeOut(duration: 0.8).delay(0.3), value: isVisible)
                                }
                            }
                            .padding(.horizontal, 24)
                            
                            // Elegant divider with optimized spacing
                            VStack(spacing: 32) {
                                HStack(spacing: 0) {
                                    Rectangle()
                                        .fill(Color.white.opacity(0.2))
                                        .frame(height: 1)
                                        .frame(width: 60)
                                    
                                    Circle()
                                        .fill(Color.white.opacity(0.4))
                                        .frame(width: 4, height: 4)
                                        .padding(.horizontal, 8)
                                    
                                    Rectangle()
                                        .fill(Color.white.opacity(0.2))
                                        .frame(height: 1)
                                        .frame(width: 60)
                                }
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .animation(.easeOut(duration: 0.8).delay(0.4), value: isVisible)
                                
                                // Brand section
                                VStack(spacing: 16) {
                                    // Stars
                                    HStack(spacing: 8) {
                                        Image(systemName: "laurel.leading")
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundColor(.white.opacity(0.7))
                                        
                                        HStack(spacing: 3) {
                                            ForEach(0..<5, id: \.self) { index in
                                                Image(systemName: "star.fill")
                                                    .font(.system(size: 13, weight: .bold))
                                                    .foregroundColor(.yellow)
                                                    .opacity(isVisible ? 1.0 : 0.0)
                                                    .animation(.easeOut(duration: 0.8).delay(0.5 + Double(index) * 0.05), value: isVisible)
                                            }
                                        }
                                        
                                        Image(systemName: "laurel.trailing")
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                    .opacity(isVisible ? 1.0 : 0.0)
                                    .animation(.easeOut(duration: 0.8).delay(0.5), value: isVisible)
                                    
                                    VStack(spacing: 8) {
                                        Text("Become the best of\nyourself with UNFAP")
                                            .font(.system(size: 28, weight: .bold, design: .rounded))
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                            .lineSpacing(3)
                                            .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
                                            .opacity(isVisible ? 1.0 : 0.0)
                                            .animation(.easeOut(duration: 0.8).delay(0.6), value: isVisible)
                                        
                                        Text("Stronger. Healthier. Happier.")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(.white.opacity(0.8))
                                            .opacity(isVisible ? 1.0 : 0.0)
                                            .animation(.easeOut(duration: 0.8).delay(0.7), value: isVisible)
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                            

                        }
                        
                        // Reduced bottom spacing for tighter layout
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 20)
                    }
                }
                
                // Fixed bottom CTA
                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Button(action: {
                            Task {
                                print("🔥 Start Your Journey button pressed!")
                                print("🔥 Products available: \(subscriptionManager.products.count)")
                                print("🔥 Yearly product: \(subscriptionManager.yearlyProduct?.displayName ?? "nil")")
                                
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                
                                await subscriptionManager.purchaseYearlySubscription()
                                
                                print("🔥 After purchase attempt - isSubscribed: \(subscriptionManager.isSubscribed)")
                                print("🔥 After purchase attempt - userCancelledPurchase: \(subscriptionManager.userCancelledPurchase)")
                                print("🔥 Subscription error: \(subscriptionManager.subscriptionError ?? "none")")
                                
                                // Complete onboarding if subscription was successful
                                if subscriptionManager.isSubscribed {
                                hasCompletedOnboarding = true
                                    print("🔥 Onboarding completed!")
                                } else if subscriptionManager.userCancelledPurchase && !discountOfferShownThisSession {
                                    print("🎯 Manual check: User cancelled, showing discount offer")
                                    showDiscountOffer = true
                                    discountOfferShownThisSession = true
                                    subscriptionManager.resetCancellationFlag()
                                }
                            }
                        }) {
                            if subscriptionManager.isLoading {
                                HStack(spacing: 16) {
                                    ProgressView()
                                        .scaleEffect(0.9)
                                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                    Text("Processing...")
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundColor(.black)
                                }
                            } else {
                                Text("Start Your Journey")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.black)
                            }
                        }
                        .frame(height: 64)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 32)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)
                        )
                        .disabled(subscriptionManager.isLoading)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.8).delay(1.1), value: isVisible)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 24)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            isVisible = true
        }
        .onChange(of: subscriptionManager.userCancelledPurchase) { _, cancelled in
            print("🔍 Purchase cancellation changed to: \(cancelled)")
            print("🔍 Has seen discount offer: \(hasSeenDiscountOffer)")
            print("🔍 Discount shown this session: \(discountOfferShownThisSession)")
            print("🔍 Is subscribed: \(subscriptionManager.isSubscribed)")
            
            if cancelled && !discountOfferShownThisSession && !subscriptionManager.isSubscribed {
                print("🎯 Showing discount offer due to cancellation")
                // User cancelled the StoreKit purchase - show discount offer
                showDiscountOffer = true
                discountOfferShownThisSession = true
                // Reset the cancellation flag
                subscriptionManager.userCancelledPurchase = false
            }
        }
        .alert("Purchase Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("There was an error processing your purchase. Please try again.")
        }
        .sheet(isPresented: $showDiscountOffer) {
            DiscountOfferView()
                .environmentObject(onboardingState)
                .environmentObject(subscriptionManager)
                .onDisappear {
                    hasSeenDiscountOffer = true
                    // If user still hasn't subscribed after seeing discount, dismiss main paywall
                    if !subscriptionManager.isSubscribed {
                        dismiss()
                    }
                }
        }
    }
}

struct BenefitBadge: View {
    let icon: String
    let title: String
    let backgroundColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                backgroundColor.opacity(0.9),
                                backgroundColor.opacity(0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 32, height: 32)
                    .shadow(color: backgroundColor.opacity(0.4), radius: 6, x: 0, y: 3)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
            }
            
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .lineSpacing(1)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    let previewSubscriptionManager = SubscriptionManager()
    let previewOnboardingState = OnboardingState()
    
    return PaywallView()
        .environmentObject(previewOnboardingState)
        .environmentObject(previewSubscriptionManager)
        .onAppear {
            // In preview, simulate having a product available
            Task {
                await previewSubscriptionManager.requestProducts()
            }
        }
        .overlay(alignment: .topLeading) {
            // Preview-only test button to simulate successful purchase
            VStack(spacing: 8) {
                Text("PREVIEW MODE")
                    .font(.caption2)
                    .foregroundColor(.yellow)
                
                Button("✅ Simulate Purchase") {
                    #if DEBUG
                    previewSubscriptionManager.grantTestSubscription()
                    // Simulate completing onboarding
                    UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                    #endif
                }
                .font(.caption)
                .padding(4)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(4)
                
                Button("❌ Reset") {
                    #if DEBUG
                    previewSubscriptionManager.revokeTestSubscription()
                    UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
                    #endif
                }
                .font(.caption)
                .padding(4)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(4)
            }
            .padding()
        }
} 
