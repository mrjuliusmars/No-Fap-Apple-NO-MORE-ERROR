import SwiftUI

struct MainAppFlowView: View {
    @StateObject private var subscriptionManager = SubscriptionManager()
    @StateObject private var onboardingState = OnboardingState()
    @EnvironmentObject var shortcutHandler: ShortcutHandler
    @State private var hasCompletedOnboarding = false
    
    var body: some View {
        Group {
            if subscriptionManager.isSubscribed {
                // ✅ SUBSCRIBED USERS → Full Dashboard Access
                DashboardView()
                    .environmentObject(subscriptionManager)
                    
            } else if hasCompletedOnboarding {
                // 🔒 COMPLETED ONBOARDING BUT NOT SUBSCRIBED → Paywall Only
                PaywallGateView(subscriptionManager: subscriptionManager)
                
            } else {
                // 🆕 NEW USERS → Onboarding Flow
                OnboardingFlowView(
                    subscriptionManager: subscriptionManager,
                    onboardingState: onboardingState,
                    onOnboardingComplete: {
                        hasCompletedOnboarding = true
                        saveOnboardingStatus()
                    }
                )
            }
        }
        .animation(.easeInOut(duration: 0.5), value: subscriptionManager.isSubscribed)
        .animation(.easeInOut(duration: 0.5), value: hasCompletedOnboarding)
        .onAppear {
            loadOnboardingStatus()
        }
        .sheet(isPresented: $shortcutHandler.shouldShowFreeTrial) {
            FreeTrialOfferView()
                .environmentObject(onboardingState)
                .environmentObject(subscriptionManager)
                .onDisappear {
                    shortcutHandler.resetFlags()
                }
        }
        #if DEBUG
        .overlay(alignment: .bottomTrailing) {
            DebugControls(
                subscriptionManager: subscriptionManager,
                hasCompletedOnboarding: $hasCompletedOnboarding
            )
        }
        .overlay(alignment: .bottomLeading) {
            // Temporary reset button for easy testing
            Button("🔄 New User") {
                // Reset everything to simulate new user
                subscriptionManager.resetSubscription()
                hasCompletedOnboarding = false
                UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
                UserDefaults.standard.removeObject(forKey: "firstDashboardEntry")
                UserDefaults.standard.removeObject(forKey: "streakStartDateKey")
                UserDefaults.standard.removeObject(forKey: "streakManagerInitialized")
                UserDefaults.standard.removeObject(forKey: "75SoftChallengeActive")
                UserDefaults.standard.removeObject(forKey: "75SoftStartDate")
                UserDefaults.standard.removeObject(forKey: "75SoftCurrentDay")
                UserDefaults.standard.removeObject(forKey: "75SoftLastCheckDate")
                onboardingState.clearPath()
            }
            .font(.caption)
            .padding(8)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding()
        }
        #endif
    }
    
    private func loadOnboardingStatus() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }
    
    private func saveOnboardingStatus() {
        UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
    }
}

// MARK: - Onboarding Flow (Leads to Paywall)
struct OnboardingFlowView: View {
    @ObservedObject var subscriptionManager: SubscriptionManager
    @ObservedObject var onboardingState: OnboardingState
    let onOnboardingComplete: () -> Void
    
    var body: some View {
        NavigationStack(path: $onboardingState.path) {
            WelcomeView()
                .navigationDestination(for: OnboardingFlow.self) { destination in
                    switch destination {
                    case .welcome:
                        WelcomeView()
                        
                    case .quiz(let questionNumber):
                        QuizQuestionView(questionNumber: questionNumber)
                        
                    case .userInfo:
                        UserInfoView()
                        
                    case .calculating:
                        CalculatingView()
                        
                    case .analysisResult:
                        AnalysisResultView()
                        
                    case .symptoms(let categoryNumber):
                        SymptomsView(categoryId: categoryNumber)
                        
                    case .educational(let slideNumber):
                        EducationalSlideView(slideNumber: slideNumber)
                        
                    case .goals:
                        GoalsView()
                        
                    case .planReady:
                        PlanReadyView()
                        
                    case .paywall:
                        PaywallView()
                            .environmentObject(onboardingState)
                    }
                }
        }
        .environmentObject(onboardingState)
        .environmentObject(subscriptionManager)
    }
    
    private var hasCompletedOnboarding: Bool {
        UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }
}

// MARK: - Paywall Gate (Blocks Dashboard Access)
struct PaywallGateView: View {
    @ObservedObject var subscriptionManager: SubscriptionManager
    
    var body: some View {
        PaywallView()
            .environmentObject(OnboardingState()) // Provide a default onboarding state for the paywall
            .environmentObject(subscriptionManager) // Provide subscription manager
            .interactiveDismissDisabled() // Prevent dismissing paywall
    }
}

// MARK: - Debug Controls
#if DEBUG
struct DebugControls: View {
    @ObservedObject var subscriptionManager: SubscriptionManager
    @Binding var hasCompletedOnboarding: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Text("DEBUG")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Button("Reset All") {
                subscriptionManager.resetSubscription()
                hasCompletedOnboarding = false
                UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
                UserDefaults.standard.removeObject(forKey: "firstDashboardEntry")
                UserDefaults.standard.removeObject(forKey: "streakStartDateKey")
                UserDefaults.standard.removeObject(forKey: "streakManagerInitialized")
                UserDefaults.standard.removeObject(forKey: "75SoftChallengeActive")
                UserDefaults.standard.removeObject(forKey: "75SoftStartDate")
                UserDefaults.standard.removeObject(forKey: "75SoftCurrentDay")
                UserDefaults.standard.removeObject(forKey: "75SoftLastCheckDate")
            }
            .debugButtonStyle(.red)
            
            Button(subscriptionManager.isSubscribed ? "Revoke Sub" : "Grant Sub") {
                if subscriptionManager.isSubscribed {
                    subscriptionManager.revokeTestSubscription()
                } else {
                    subscriptionManager.grantTestSubscription()
                }
            }
            .debugButtonStyle(subscriptionManager.isSubscribed ? .orange : .green)
            
            Button(hasCompletedOnboarding ? "Reset Onboarding" : "Complete Onboarding") {
                hasCompletedOnboarding.toggle()
                UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
            }
            .debugButtonStyle(.blue)
            
            // Status indicators
            VStack(spacing: 2) {
                Text("Sub: \(subscriptionManager.isSubscribed ? "✅" : "❌")")
                    .font(.caption2)
                    .foregroundColor(.white)
                Text("Onb: \(hasCompletedOnboarding ? "✅" : "❌")")
                    .font(.caption2)
                    .foregroundColor(.white)
            }
        }
        .padding(8)
        .background(Color.black.opacity(0.7))
        .cornerRadius(8)
        .padding()
    }
}

extension View {
    func debugButtonStyle(_ color: Color) -> some View {
        self
            .font(.caption)
            .padding(6)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(4)
    }
}
#endif

#Preview {
    MainAppFlowView()
} 