import SwiftUI

enum OnboardingFlow: Hashable {
    case welcome
    case quizIntro
    case quiz(Int) // Question number
    case userInfo
    case calculating
    case analysisResult // New case for analysis result
    case symptoms(Int) // Symptom category number
    case educational(Int) // Slide number
    case educational // Simple educational without number
    case goals
    case planReady
    case paywall
    case dashboard
    case panic
}

@MainActor
class OnboardingState: ObservableObject {
    @Published var path = NavigationPath()
    @Published var quizAnswers: [Int: Int] = [:] // Question number: Answer index
    @Published var selectedSymptoms: Set<String> = []
    @Published var selectedGoals: Set<String> = []
    @Published var name: String = ""
    @Published var age: String = ""
    
    func navigateTo(_ destination: OnboardingFlow) {
        print("🚀 Navigating to: \(destination)")
        print("📍 Current path count: \(path.count)")
        path.append(destination)
        print("📍 New path count: \(path.count)")
    }
    
    func navigateBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func clearPath() {
        path = NavigationPath()
    }
} 