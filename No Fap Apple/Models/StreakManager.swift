import SwiftUI
import Foundation

// MARK: - StreakManager Class
class StreakManager: ObservableObject {
    @Published var currentStreak: Int = 0
    @Published var longestStreak: Int = 0
    @Published var lastCheckDate: Date?
    @Published var streakStartDate: Date?
    
    private let userDefaults = UserDefaults.standard
    private let streakStartDateKey = "streakStartDateKey"
    private let currentStreakKey = "currentStreakKey"
    private let longestStreakKey = "longestStreakKey"
    private let lastCheckDateKey = "lastCheckDateKey"
    private let streakManagerInitializedKey = "streakManagerInitialized"
    
    init() {
        loadStreakData()
        checkStreakStatus()
    }
    
    // MARK: - Public Methods
    
    func resetStreak() {
        currentStreak = 0
        streakStartDate = Date()
        lastCheckDate = Date()
        saveStreakData()
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
    
    func updateStreak() {
        let now = Date()
        
        if let lastCheck = lastCheckDate {
            let calendar = Calendar.current
            let daysSinceLastCheck = calendar.dateComponents([.day], from: lastCheck, to: now).day ?? 0
            
            if daysSinceLastCheck >= 1 {
                // It's a new day, increment streak
                currentStreak += daysSinceLastCheck
                lastCheckDate = now
                
                // Update longest streak if current exceeds it
                if currentStreak > longestStreak {
                    longestStreak = currentStreak
                }
                
                saveStreakData()
            }
        } else {
            // First time checking, start streak
            currentStreak = 1
            lastCheckDate = now
            streakStartDate = now
            longestStreak = max(longestStreak, 1)
            saveStreakData()
        }
    }
    
    func checkStreakStatus() {
        guard let lastCheck = lastCheckDate else {
            // No previous check, this is fine
            return
        }
        
        let now = Date()
        let calendar = Calendar.current
        let daysSinceLastCheck = calendar.dateComponents([.day], from: lastCheck, to: now).day ?? 0
        
        // If more than 1 day has passed without checking in, reset streak
        if daysSinceLastCheck > 1 {
            currentStreak = 0
            streakStartDate = nil
            saveStreakData()
        }
    }
    
    var streakDays: Int {
        return currentStreak
    }
    
    var streakWeeks: Int {
        return currentStreak / 7
    }
    
    var streakMonths: Int {
        return currentStreak / 30
    }
    
    var streakDescription: String {
        if currentStreak == 0 {
            return "Start your journey today!"
        } else if currentStreak == 1 {
            return "1 day strong!"
        } else if currentStreak < 7 {
            return "\(currentStreak) days strong!"
        } else if currentStreak < 30 {
            let weeks = currentStreak / 7
            let days = currentStreak % 7
            if days == 0 {
                return "\(weeks) week\(weeks == 1 ? "" : "s") strong!"
            } else {
                return "\(weeks) week\(weeks == 1 ? "" : "s"), \(days) day\(days == 1 ? "" : "s") strong!"
            }
        } else {
            let months = currentStreak / 30
            let remainingDays = currentStreak % 30
            if remainingDays == 0 {
                return "\(months) month\(months == 1 ? "" : "s") strong!"
            } else {
                return "\(months) month\(months == 1 ? "" : "s"), \(remainingDays) day\(remainingDays == 1 ? "" : "s") strong!"
            }
        }
    }
    
    var streakPercentage: Double {
        // Calculate streak as percentage towards 90 days (common recovery milestone)
        let goalDays = 90.0
        return min(Double(currentStreak) / goalDays, 1.0)
    }
    
    // MARK: - Private Methods
    
    private func loadStreakData() {
        currentStreak = userDefaults.integer(forKey: currentStreakKey)
        longestStreak = userDefaults.integer(forKey: longestStreakKey)
        
        if let startDateData = userDefaults.object(forKey: streakStartDateKey) as? Date {
            streakStartDate = startDateData
        }
        
        if let lastCheckDateData = userDefaults.object(forKey: lastCheckDateKey) as? Date {
            lastCheckDate = lastCheckDateData
        }
        
        // Mark as initialized
        userDefaults.set(true, forKey: streakManagerInitializedKey)
    }
    
    private func saveStreakData() {
        userDefaults.set(currentStreak, forKey: currentStreakKey)
        userDefaults.set(longestStreak, forKey: longestStreakKey)
        
        if let startDate = streakStartDate {
            userDefaults.set(startDate, forKey: streakStartDateKey)
        }
        
        if let lastCheck = lastCheckDate {
            userDefaults.set(lastCheck, forKey: lastCheckDateKey)
        }
    }
    
    // MARK: - Debug Methods
    
    func resetAllData() {
        currentStreak = 0
        longestStreak = 0
        streakStartDate = nil
        lastCheckDate = nil
        
        userDefaults.removeObject(forKey: currentStreakKey)
        userDefaults.removeObject(forKey: longestStreakKey)
        userDefaults.removeObject(forKey: streakStartDateKey)
        userDefaults.removeObject(forKey: lastCheckDateKey)
        userDefaults.removeObject(forKey: streakManagerInitializedKey)
    }
} 