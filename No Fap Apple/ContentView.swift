//
//  ContentView.swift
//  No Fap Apple
//
//  Created by Marshall Hodge on 5/27/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var onboardingState = OnboardingState()
    
    var body: some View {
        NavigationStack(path: $onboardingState.path) {
            WelcomeView()
                .environmentObject(onboardingState)
                .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    ContentView()
}
