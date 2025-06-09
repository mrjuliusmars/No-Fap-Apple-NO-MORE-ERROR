import SwiftUI

// MARK: - OnboardingFlow Enum
enum OnboardingFlow: Hashable {
    case welcome
    case quiz(Int)
    case userInfo
    case calculating
    case analysisResult
    case symptoms(Int)
    case educational(Int)
    case goals
    case planReady
    case paywall
}

// MARK: - OnboardingState Class
class OnboardingState: ObservableObject {
    @Published var path = NavigationPath()
    @Published var name: String = ""
    @Published var age: String = ""
    @Published var quizAnswers: [Int: Int] = [:]
    @Published var selectedGoals: Set<String> = []
    @Published var selectedSymptoms: Set<String> = []
    
    func navigateTo(_ destination: OnboardingFlow) {
        path.append(destination)
    }
    
    func clearPath() {
        path = NavigationPath()
    }
    
    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    // Helper method to get quiz score
    var quizScore: Int {
        // Calculate score based on quiz answers
        // This is a simplified scoring system
        let totalQuestions = quizAnswers.count
        let totalScore = quizAnswers.values.reduce(0, +)
        
        if totalQuestions > 0 {
            return min(100, (totalScore * 100) / (totalQuestions * 4)) // Assuming 4 options per question
        }
        
        return 73 // Default score used in the UI
    }
} 