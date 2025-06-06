import SwiftUI

struct SplashView: View {
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0
    @State private var contentOffset: CGFloat = 30
    @State private var contentOpacity: Double = 0
    @State private var buttonScale: CGFloat = 0.9
    @State private var showWelcome = false
    @State private var glowIntensity: Double = 0.3
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Clean background
                LinearGradient(
                    colors: [
                        Color(red: 0.08, green: 0.15, blue: 0.28),   // Light navy top
                        Color(red: 0.06, green: 0.12, blue: 0.22),   // Slightly deeper navy
                        Color(red: 0.05, green: 0.1, blue: 0.2)      // Consistent light navy bottom
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Clean logo section
                    VStack(spacing: 48) {
                        // Simple golden circle with subtle glow
                        ZStack {
                            // Subtle glow
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            Color.yellow.opacity(glowIntensity * 0.6),
                                            Color.clear
                                        ],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 80
                                    )
                                )
                                .frame(width: 160, height: 160)
                            
                            // Main circle
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 1.0, green: 0.95, blue: 0.8),
                                            Color(red: 1.0, green: 0.85, blue: 0.4),
                                            Color(red: 0.9, green: 0.7, blue: 0.2)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                                .shadow(color: Color.yellow.opacity(0.4), radius: 20, x: 0, y: 8)
                            
                            // Clean icon
                            Image(systemName: "crown.fill")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.23))
                        }
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                        
                        // Clean typography
                        VStack(spacing: 16) {
                            Text("Overkum")
                                .font(.system(size: 32, weight: .black, design: .rounded))
                                .tracking(2)
                                .foregroundColor(.white)
                            
                            Text("Break free. Stay strong.")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.7))
                                .tracking(0.5)
                        }
                        .offset(y: contentOffset)
                        .opacity(contentOpacity)
                    }
                    
                    Spacer()
                    
                    // Clean call-to-action
                    VStack(spacing: 24) {
                        Text("Your journey to freedom starts here")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color.white.opacity(0.6))
                            .offset(y: contentOffset)
                            .opacity(contentOpacity)
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                showWelcome = true
                            }
                        }) {
                            HStack(spacing: 12) {
                                Text("Get Started")
                                    .font(.system(size: 17, weight: .semibold))
                                
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 1.0, green: 0.95, blue: 0.8),
                                        Color(red: 1.0, green: 0.85, blue: 0.4)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.23))
                            .cornerRadius(27)
                            .shadow(color: Color.yellow.opacity(0.3), radius: 15, x: 0, y: 8)
                        }
                        .scaleEffect(buttonScale)
                        .opacity(contentOpacity)
                        .padding(.horizontal, 48)
                        .padding(.bottom, 80)
                    }
                }
            }
        }
        .onAppear {
            startCleanAnimations()
        }
        .fullScreenCover(isPresented: $showWelcome) {
            WelcomeView()
        }
    }
    
    private func startCleanAnimations() {
        // Logo entrance
        withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.2)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        
        // Content entrance
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.6)) {
            contentOffset = 0
            contentOpacity = 1.0
            buttonScale = 1.0
        }
        
        // Subtle glow pulse
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true).delay(1.0)) {
            glowIntensity = 0.8
        }
    }
}

#Preview {
    SplashView()
} 
