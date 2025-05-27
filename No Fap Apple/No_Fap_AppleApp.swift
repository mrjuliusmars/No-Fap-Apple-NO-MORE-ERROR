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
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if hasCompletedOnboarding {
                    HomeView()
                        .environmentObject(onboardingState)
                } else {
            WelcomeView()
                .environmentObject(onboardingState)
                        .navigationBarHidden(true)
                }
            }
        }
    }
}
