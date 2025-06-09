import SwiftUI

struct SplashView: View {
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0
    @State private var titleOffset: CGFloat = 20
    @State private var titleOpacity: Double = 0
    @State private var taglineOffset: CGFloat = 20
    @State private var taglineOpacity: Double = 0
    @State private var glowIntensity: Double = 0.3
    @State private var isVisible = false
    @State private var auraRotation: Double = 0
    @State private var auraScale: CGFloat = 1.0
    @State private var energyPulse: CGFloat = 1.0
    @State private var lifeforceScale: CGFloat = 1.0
    @State private var vitalityPulse: CGFloat = 1.0
    @State private var coreGlow: Double = 0.8
    @State private var outerEnergy: CGFloat = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Clean background - same as app
                Theme.backgroundGradient
                    .ignoresSafeArea()
                
                // Main content - centered group like screenshot
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 120)
                    
                    // Centered logo and text group
                    VStack(spacing: 40) {
                        // Animated CleanMinimalistOrb
                        ZStack {
                            CleanMinimalistOrb(
                                auraScale: auraScale,
                                lifeforceScale: lifeforceScale,
                                energyPulse: energyPulse,
                                vitalityPulse: vitalityPulse,
                                coreGlow: coreGlow,
                                outerEnergy: outerEnergy,
                                auraRotation: auraRotation,
                                streakDays: 1,
                                showProgressRing: false
                            )
                            .frame(width: 200, height: 200)
                            .opacity(logoOpacity)
                            .scaleEffect(logoScale)
                        }
                        
                        // Typography group
                        VStack(spacing: 8) {
                            // App Logo with fallback
                            Group {
                                if let _ = UIImage(named: "APP LOGO PNG") {
                                    Image("APP LOGO PNG")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 120, height: 120)
                                } else {
                                    // Fallback to text if image not found
                                    Text("UNFAP")
                                        .font(.system(size: 50, weight: .black, design: .rounded))
                                        .tracking(4)
                                        .foregroundColor(.white)
                                }
                            }
                            .offset(y: titleOffset)
                            .opacity(titleOpacity)
                            
                            // Tagline
                            Text("Reclaim Control.")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.9))
                                .tracking(1.2)
                                .offset(y: taglineOffset)
                                .opacity(taglineOpacity)
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            startCleanAnimations()
        }
    }
    
    private func startCleanAnimations() {
        // Logo entrance - smooth scale up
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.3)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        
        // Text group appears together shortly after logo
        withAnimation(.spring(response: 0.6, dampingFraction: 0.9).delay(0.8)) {
            titleOffset = 0
            titleOpacity = 1.0
            taglineOffset = 0
            taglineOpacity = 1.0
        }
        
        // Orb animations (copied from dashboard)
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true).delay(1.0)) {
            auraScale = 1.08
            energyPulse = 1.12
            vitalityPulse = 1.10
            lifeforceScale = 1.06
            outerEnergy = 1.04
        }
        withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true).delay(1.2)) {
            coreGlow = 1.0
        }
        withAnimation(.linear(duration: 18.0).repeatForever(autoreverses: false)) {
            auraRotation = 360
        }
    }
}

#Preview {
    SplashView()
} 

