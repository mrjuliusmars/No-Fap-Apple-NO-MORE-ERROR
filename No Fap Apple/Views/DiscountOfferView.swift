import SwiftUI

struct DiscountOfferView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Environment(\.dismiss) private var dismiss
    @State private var isVisible = false
    @State private var showErrorAlert = false
    @State private var timeRemaining = 300 // 5 minutes in seconds
    @State private var timer: Timer?
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    private var minutes: Int {
        timeRemaining / 60
    }
    
    private var seconds: Int {
        timeRemaining % 60
    }
    
    private var userName: String {
        let name = onboardingState.name.trimmingCharacters(in: .whitespacesAndNewlines)
        return name.isEmpty ? "Friend" : name.components(separatedBy: " ").first ?? name
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Premium gradient background with stars
                Theme.backgroundGradient
                    .ignoresSafeArea()
                
                // Floating particles/stars
                ForEach(0..<25, id: \.self) { index in
                    Circle()
                        .fill(Color.white.opacity(Double.random(in: 0.1...0.3)))
                        .frame(width: CGFloat.random(in: 1...4))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .animation(
                            .easeInOut(duration: Double.random(in: 10...20))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...8)),
                            value: isVisible
                        )
                        .opacity(isVisible ? 1.0 : 0.0)
                }
                
                // Close button
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white.opacity(0.8))
                                .frame(width: 40, height: 40)
                                .background(Color.black.opacity(0.3))
                                .clipShape(Circle())
                        }
                        .padding(.top, 20)
                        .padding(.trailing, 24)
                    }
                    Spacer()
                }
                
                VStack(spacing: 24) {
                    // Logo area with more top spacing
                    Text("Overkum")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.8).delay(0.1), value: isVisible)
                        .padding(.top, 40)
                    
                    VStack(spacing: 12) {
                        // Main headline
                        Text("ONE TIME OFFER")
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .tracking(1.5)
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.8).delay(0.2), value: isVisible)
                        
                        Text("You will never see this again")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.8).delay(0.3), value: isVisible)
                    }
                    
                    // 80% Discount Badge
                    VStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.7, green: 0.3, blue: 1.0),
                                        Color(red: 0.3, green: 0.5, blue: 1.0)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 200, height: 120)
                            .overlay(
                                VStack(spacing: 8) {
                                    Text("80%")
                                        .font(.system(size: 48, weight: .black, design: .rounded))
                                        .foregroundColor(.white)
                                    
                                    Text("DISCOUNT")
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .tracking(3)
                                }
                            )
                            .shadow(color: Color(red: 0.5, green: 0.3, blue: 1.0).opacity(0.6), radius: 20, x: 0, y: 10)
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 1.0).delay(0.4), value: isVisible)
                    }
                    
                    // Countdown Timer
                    VStack(spacing: 8) {
                        Text("This offer will expire in")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.8).delay(0.5), value: isVisible)
                        
                        Text("\(minutes):\(String(format: "%02d", seconds))")
                            .font(.system(size: 56, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.8).delay(0.6), value: isVisible)
                    }
                    
                    // Reduced spacer
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 20)
                    
                    // Pricing section
                    VStack(spacing: 20) {
                        VStack(spacing: 12) {
                            Text("LOWEST PRICE EVER")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .tracking(2)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .animation(.easeOut(duration: 0.8).delay(0.7), value: isVisible)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Yearly")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text("12mo • $19.99")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                
                                Spacer()
                                
                                Text("$1.67/mo")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                            )
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.8).delay(0.8), value: isVisible)
                        }
                        
                        // CTA Button
                        Button(action: {
                            Task {
                                print("🔥 Claim Discount Offer button pressed!")
                                
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                
                                await subscriptionManager.purchaseDiscountSubscription()
                                
                                if subscriptionManager.isSubscribed {
                                    hasCompletedOnboarding = true
                                    print("🔥 Discount purchase completed!")
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
                                Text("CLAIM YOUR OFFER NOW")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .tracking(1)
                            }
                        }
                        .frame(height: 64)
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.3, green: 0.5, blue: 1.0),
                                    Color(red: 0.7, green: 0.3, blue: 1.0)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 32))
                        .shadow(color: Color(red: 0.5, green: 0.3, blue: 1.0).opacity(0.6), radius: 20, x: 0, y: 10)
                        .disabled(subscriptionManager.isLoading)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.8).delay(0.9), value: isVisible)
                        
                        // Fine print
                        Text("Cancel anytime • Money back guarantee")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.8).delay(1.0), value: isVisible)
                            .padding(.bottom, 8)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom + 20, 30))
                }
                .padding(.horizontal, 24)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            isVisible = true
            startCountdownTimer()
        }
        .onDisappear {
            stopCountdownTimer()
        }
        .alert("Purchase Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("There was an error processing your purchase. Please try again.")
        }
    }
    
    private func startCountdownTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                // Timer expired - dismiss the view
                dismiss()
            }
        }
    }
    
    private func stopCountdownTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    let previewSubscriptionManager = SubscriptionManager()
    let previewOnboardingState = OnboardingState()
    
    return DiscountOfferView()
        .environmentObject(previewOnboardingState)
        .environmentObject(previewSubscriptionManager)
} 