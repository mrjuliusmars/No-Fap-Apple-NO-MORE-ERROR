import SwiftUI
import Foundation

@MainActor
class DeletionIntentDetector: ObservableObject {
    @Published var shouldShowFreeTrialOffer = false
    
    private var appBackgroundTime: Date?
    private var quickExitCount = 0
    private var lastSessionDuration: TimeInterval = 0
    private var sessionStartTime: Date?
    
    // UserDefaults keys
    private let quickExitCountKey = "quickExitCount"
    private let lastOfferShownKey = "lastFreeTrialOfferShown"
    
    init() {
        setupAppLifecycleMonitoring()
        loadStoredData()
    }
    
    private func setupAppLifecycleMonitoring() {
        // Monitor app backgrounding
        NotificationCenter.default.addObserver(
            forName: UIApplication.willResignActiveNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.handleAppBackground()
        }
        
        // Monitor app foregrounding
        NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.handleAppForeground()
        }
    }
    
    private func handleAppBackground() {
        appBackgroundTime = Date()
        
        // Calculate session duration
        if let sessionStart = sessionStartTime {
            lastSessionDuration = Date().timeIntervalSince(sessionStart)
            
            // If session was very short (less than 10 seconds), increment quick exit count
            if lastSessionDuration < 10 {
                quickExitCount += 1
                UserDefaults.standard.set(quickExitCount, forKey: quickExitCountKey)
                
                print("🚨 Quick exit detected. Count: \(quickExitCount)")
                
                // If user has had 3+ quick exits and hasn't seen offer recently
                if quickExitCount >= 3 && !hasSeenOfferRecently() {
                    scheduleOfferCheck()
                }
            }
        }
    }
    
    private func handleAppForeground() {
        sessionStartTime = Date()
        
        // Check if user was away for a while (potential deletion attempt)
        if let backgroundTime = appBackgroundTime {
            let awayDuration = Date().timeIntervalSince(backgroundTime)
            
            // If they were away for 30+ seconds (enough time to try to delete)
            if awayDuration > 30 && awayDuration < 300 { // But not too long (5 min max)
                print("🚨 User returned after potential deletion attempt")
                
                if !hasSeenOfferRecently() {
                    scheduleOfferCheck()
                }
            }
        }
        
        appBackgroundTime = nil
    }
    
    private func scheduleOfferCheck() {
        // Add a small delay to let the app settle
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.shouldShowFreeTrialOffer = true
            self.markOfferShown()
        }
    }
    
    private func hasSeenOfferRecently() -> Bool {
        guard let lastShown = UserDefaults.standard.object(forKey: lastOfferShownKey) as? Date else {
            return false
        }
        
        // Don't show offer more than once per day
        return Date().timeIntervalSince(lastShown) < 24 * 60 * 60
    }
    
    private func markOfferShown() {
        UserDefaults.standard.set(Date(), forKey: lastOfferShownKey)
    }
    
    private func loadStoredData() {
        quickExitCount = UserDefaults.standard.integer(forKey: quickExitCountKey)
    }
    
    func resetDetection() {
        quickExitCount = 0
        UserDefaults.standard.removeObject(forKey: quickExitCountKey)
        UserDefaults.standard.removeObject(forKey: lastOfferShownKey)
        shouldShowFreeTrialOffer = false
    }
    
    // Manual trigger for testing
    func triggerFreeTrialOffer() {
        shouldShowFreeTrialOffer = true
    }
} 
