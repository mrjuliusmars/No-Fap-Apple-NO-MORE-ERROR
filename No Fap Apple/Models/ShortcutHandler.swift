import SwiftUI
import UIKit

@MainActor
class ShortcutHandler: ObservableObject {
    @Published var shouldShowFreeTrial = false
    @Published var shouldShowFeedback = false
    
    static let shared = ShortcutHandler()
    
    private init() {}
    
    func handleShortcut(_ shortcutType: String) {
        print("📱 Handling shortcut: \(shortcutType)")
        
        switch shortcutType {
        case "com.nuro.FreeTrial":
            // User tapped "Try for Free" from app deletion context menu
            shouldShowFreeTrial = true
            print("🎁 Free trial shortcut activated from app icon")
            
        case "com.nuro.Feedback":
            // User wants to provide feedback
            print("💬 Feedback shortcut activated")
            
        default:
            print("❓ Unknown shortcut type: \(shortcutType)")
        }
    }
    
    func resetFlags() {
        shouldShowFreeTrial = false
        shouldShowFeedback = false
    }
} 