import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    @StateObject private var storeManager = StoreKitManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var isVisible = false
    @State private var showErrorAlert = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
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
                        // Top spacing
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: geometry.safeAreaInsets.top + 20)
                        
                        VStack(spacing: 24) {
                            // Hero section
                            VStack(spacing: 16) {
                                Text("\(userName), we've made you\na custom plan.")
                                    .font(.system(size: 26, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(3)
                                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                                    .opacity(isVisible ? 1.0 : 0.0)
                                    .offset(y: isVisible ? 0 : 30)
                                    .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2), value: isVisible)
                                
                                VStack(spacing: 12) {
                                    Text("You will quit porn by:")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.white.opacity(0.8))
                                        .opacity(isVisible ? 1.0 : 0.0)
                                        .animation(.easeOut(duration: 0.6).delay(0.4), value: isVisible)
                                    
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
                                        .offset(y: isVisible ? 0 : 20)
                                        .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.6), value: isVisible)
                                }
                            }
                            .padding(.horizontal, 24)
                            
                            // Elegant divider
                            HStack {
                                Rectangle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(height: 1)
                                    .frame(width: 40)
                                
                                Circle()
                                    .fill(Color.white.opacity(0.4))
                                    .frame(width: 4, height: 4)
                                
                                Rectangle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(height: 1)
                                    .frame(width: 40)
                            }
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.6).delay(0.8), value: isVisible)
                            
                            // Brand section
                            VStack(spacing: 12) {
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
                                                .scaleEffect(isVisible ? 1.0 : 0.0)
                                                .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(1.0 + Double(index) * 0.1), value: isVisible)
                                        }
                                    }
                                    
                                    Image(systemName: "laurel.trailing")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                .opacity(isVisible ? 1.0 : 0.0)
                                .animation(.easeOut(duration: 0.6).delay(1.0), value: isVisible)
                                
                                VStack(spacing: 8) {
                                    Text("Become the best of\nyourself with No Fap")
                                        .font(.system(size: 22, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(3)
                                        .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
                                        .opacity(isVisible ? 1.0 : 0.0)
                                        .offset(y: isVisible ? 0 : 20)
                                        .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(1.2), value: isVisible)
                                    
                                    Text("Stronger. Healthier. Happier.")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.white.opacity(0.8))
                                        .opacity(isVisible ? 1.0 : 0.0)
                                        .animation(.easeOut(duration: 0.6).delay(1.4), value: isVisible)
                                }
                            }
                            .padding(.horizontal, 24)
                            
                            // Benefits grid
                            VStack(spacing: 12) {
                                // First row - 3 benefits
                                HStack(spacing: 12) {
                                    BenefitBadge(
                                        icon: "figure.strengthtraining.functional",
                                        title: "Increased\nTestosterone",
                                        backgroundColor: Color.blue
                                    )
                                    .opacity(isVisible ? 1.0 : 0.0)
                                    .offset(y: isVisible ? 0 : 30)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.6), value: isVisible)
                                    
                                    BenefitBadge(
                                        icon: "bolt.fill",
                                        title: "Increased\nEnergy",
                                        backgroundColor: Color.green
                                    )
                                    .opacity(isVisible ? 1.0 : 0.0)
                                    .offset(y: isVisible ? 0 : 30)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.7), value: isVisible)
                                    
                                    BenefitBadge(
                                        icon: "sparkles",
                                        title: "Increased\nConfidence",
                                        backgroundColor: Color.yellow
                                    )
                                    .opacity(isVisible ? 1.0 : 0.0)
                                    .offset(y: isVisible ? 0 : 30)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.8), value: isVisible)
                                }
                                
                                // Second row - 2 benefits centered
                                HStack(spacing: 16) {
                                    Spacer()
                                    BenefitBadge(
                                        icon: "chart.line.uptrend.xyaxis",
                                        title: "Increased\nMotivation",
                                        backgroundColor: Color.purple
                                    )
                                    .opacity(isVisible ? 1.0 : 0.0)
                                    .offset(y: isVisible ? 0 : 30)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.9), value: isVisible)
                                    
                                    BenefitBadge(
                                        icon: "person.2.fill",
                                        title: "Improved\nRelationships",
                                        backgroundColor: Color.orange
                                    )
                                    .opacity(isVisible ? 1.0 : 0.0)
                                    .offset(y: isVisible ? 0 : 30)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(2.0), value: isVisible)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        
                        // Bottom spacing for fixed CTA
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 40)
                    }
                }
                
                // Fixed bottom CTA
                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Button(action: {
                            Task {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                
                                if let product = storeManager.yearlyProduct {
                                    await storeManager.purchase(product)
                                }
                                
                                // Complete onboarding
                                hasCompletedOnboarding = true
                            }
                        }) {
                            if storeManager.isLoading {
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
                        .disabled(storeManager.isLoading)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : 50)
                        .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(2.6), value: isVisible)
                        
                        // Skip button
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            hasCompletedOnboarding = true
                        }) {
                            Text("Continue without premium")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.6).delay(2.8), value: isVisible)
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
        .alert("Purchase Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("There was an error processing your purchase. Please try again.")
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
    PaywallView()
        .environmentObject(OnboardingState())
} 