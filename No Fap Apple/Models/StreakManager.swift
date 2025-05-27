import Foundation
import SwiftUI

@MainActor
class StreakManager: ObservableObject {
    @Published var currentStreak: Int = 0
    @Published var bestStreak: Int = 0
    
    private let currentStreakKey = "currentStreak"
    private let bestStreakKey = "bestStreak"
    private let lastCheckDateKey = "lastCheckDate"
    
    init() {
        loadStreakData()
        checkAndUpdateStreak()
    }
    
    private func loadStreakData() {
        currentStreak = UserDefaults.standard.integer(forKey: currentStreakKey)
        bestStreak = UserDefaults.standard.integer(forKey: bestStreakKey)
    }
    
    private func saveStreakData() {
        UserDefaults.standard.set(currentStreak, forKey: currentStreakKey)
        UserDefaults.standard.set(bestStreak, forKey: bestStreakKey)
        UserDefaults.standard.set(Date(), forKey: lastCheckDateKey)
    }
    
    private func checkAndUpdateStreak() {
        let now = Date()
        let calendar = Calendar.current
        
        if let lastCheckDate = UserDefaults.standard.object(forKey: lastCheckDateKey) as? Date {
            let daysSinceLastCheck = calendar.dateComponents([.day], from: lastCheckDate, to: now).day ?? 0
            
            if daysSinceLastCheck >= 1 {
                // Increment streak for each day passed
                currentStreak += daysSinceLastCheck
                
                // Update best streak if current is better
                if currentStreak > bestStreak {
                    bestStreak = currentStreak
                }
                
                saveStreakData()
            }
        } else {
            // First time opening the app
            saveStreakData()
        }
    }
    
    func resetStreak() {
        currentStreak = 0
        saveStreakData()
    }
    
    func manualIncrement() {
        currentStreak += 1
        if currentStreak > bestStreak {
            bestStreak = currentStreak
        }
        saveStreakData()
    }
} 