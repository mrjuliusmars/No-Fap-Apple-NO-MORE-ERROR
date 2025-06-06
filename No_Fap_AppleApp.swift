//
//  No_Fap_AppleApp.swift
//  No Fap Apple
//
//  Created by Marshall Hodge on 5/27/25.
//

import SwiftUI

@main
struct No_Fap_AppleApp: App {
    @StateObject private var onboardingState = OnboardingState()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $onboardingState.path) {
                WelcomeView()
                    .navigationDestination(for: OnboardingFlow.self) { flow in
                        switch flow {
                        case .welcome:
                            WelcomeView()
                        case .quizIntro:
                            QuizIntroView()
                        case .quiz(let questionNumber):
                            QuizQuestionView(questionNumber: questionNumber)
                        case .userInfo:
                            UserInfoView()
                        case .calculating:
                            CalculatingView()
                        case .symptoms(let categoryId):
                            SymptomsView(categoryId: categoryId)
                        case .educational:
                            EducationalView()
                        case .motivation:
                            Text("Motivation Cards")
                                .foregroundColor(Theme.textColor)
                        case .goals:
                            Text("Goal Setting")
                                .foregroundColor(Theme.textColor)
                        case .analysis:
                            Text("Analysis")
                                .foregroundColor(Theme.textColor)
                        case .paywall:
                            Text("Premium Features")
                                .foregroundColor(Theme.textColor)
                        case .dashboard:
                            DashboardView()
                        case .panic:
                            PanicView()
                        case .exercise:
                            ExerciseView()
                        }
                    }
            }
            .environmentObject(onboardingState)
            .preferredColorScheme(.dark)
        }
    }
}
