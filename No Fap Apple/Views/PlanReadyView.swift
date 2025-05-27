import SwiftUI

struct PlanReadyView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    @State private var isVisible = false
    @State private var showContent = false
    @State private var showFeatures = false
    @State private var showButton = false
    @State private var particlesAnimating = false
    @State private var pulseAnimation = false
    @State private var rotationAngle: Double = 0
    @State private var glowIntensity: Double = 0.2
    @State private var successScale: CGFloat = 0.8
    @State private var orbitalRotation: Double = 0
    @State private var shimmerOffset: CGFloat = -200
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Premium gradient background with enhanced depth
                LinearGradient(
                    colors: [
                        Color(red: 0.18, green: 0.15, blue: 0.28),   // Richer purple top
                        Color(red: 0.12, green: 0.08, blue: 0.22),   // Deep purple middle
                        Color(red: 0.06, green: 0.04, blue: 0.16),   // Very dark purple
                        Color(red: 0.02, green: 0.01, blue: 0.08)    // Almost black bottom
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Enhanced floating particles with premium glow
                ForEach(0..<15, id: \.self) { index in
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.white.opacity(0.08),
                                    Color.cyan.opacity(0.04),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 2
                            )
                        )
                        .frame(width: CGFloat.random(in: 2...4))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .animation(
                            .easeInOut(duration: Double.random(in: 10...20))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...8)),
                            value: isVisible
                        )
                        .opacity(isVisible ? Double.random(in: 0.3...0.8) : 0.1)
                        .blur(radius: 1)
                }
                
                VStack(spacing: 0) {
                    // Clean top branding
                    VStack(spacing: Theme.spacing8) {
                        HStack {
                            Text("NO FAP")
                                .font(.system(size: 32, weight: .black, design: .rounded))
                                .tracking(2)
                                .foregroundColor(.white)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.1), value: isVisible)
                            
                            Spacer()
                        }
                        .padding(.horizontal, Theme.spacing24)
                        .padding(.top, 15)
                    }
                    
                    Spacer()
                    
                    // Premium main content with enhanced effects
                    VStack(spacing: Theme.spacing20) {
                        // Enhanced success animation with orbital elements - smaller
                        ZStack {
                            // Multi-layered glow background - reduced size
                            ForEach(0..<3, id: \.self) { layer in
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            gradient: Gradient(colors: [
                                                Color.green.opacity(glowIntensity * 0.4 / Double(layer + 1)),
                                                Color.cyan.opacity(glowIntensity * 0.3 / Double(layer + 1)),
                                                Color.purple.opacity(glowIntensity * 0.2 / Double(layer + 1)),
                                                Color.clear
                                            ]),
                                            center: .center,
                                            startRadius: 0,
                                            endRadius: CGFloat(80 + layer * 25)
                                        )
                                    )
                                    .frame(width: CGFloat(140 + layer * 40), height: CGFloat(140 + layer * 40))
                                    .blur(radius: CGFloat(10 + layer * 3))
                                    .scaleEffect(pulseAnimation ? 1.1 : 0.9)
                                    .animation(
                                        .easeInOut(duration: 4.0 + Double(layer))
                                        .repeatForever(autoreverses: true)
                                        .delay(Double(layer) * 0.5),
                                        value: pulseAnimation
                                    )
                            }
                            
                            // Orbital elements rotating around success icon - smaller orbit
                            ForEach(0..<6, id: \.self) { index in
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.cyan.opacity(0.6), Color.purple.opacity(0.4)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 3, height: 3)
                                    .offset(x: 45)
                                    .rotationEffect(.degrees(orbitalRotation + Double(index * 60)))
                                    .blur(radius: 0.5)
                                    .opacity(showContent ? 0.8 : 0)
                                    .animation(.easeOut(duration: 1.0).delay(1.0), value: showContent)
                            }
                            
                            // Premium success icon with enhanced styling - smaller
                            ZStack {
                                // Shimmer effect background
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.green,
                                                Color.green.opacity(0.8),
                                                Color.cyan.opacity(0.6)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 65, height: 65)
                                    .overlay(
                                        // Shimmer overlay
                                        Rectangle()
                                            .fill(
                                                LinearGradient(
                                                    colors: [
                                                        Color.clear,
                                                        Color.white.opacity(0.3),
                                                        Color.clear
                                                    ],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .rotationEffect(.degrees(45))
                                            .offset(x: shimmerOffset)
                                            .clipped()
                                    )
                                    .clipShape(Circle())
                                    .shadow(color: .green.opacity(0.5), radius: 20, x: 0, y: 8)
                                    .shadow(color: .cyan.opacity(0.3), radius: 12, x: 0, y: 6)
                                    .scaleEffect(successScale)
                                    .opacity(showContent ? 1 : 0)
                                    .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.3), value: showContent)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: successScale)
                                
                                Image(systemName: "checkmark")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                                    .scaleEffect(successScale)
                                    .opacity(showContent ? 1 : 0)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.5), value: showContent)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: successScale)
                            }
                        }
                        
                        // Premium text content with enhanced typography - more compact
                        VStack(spacing: Theme.spacing12) {
                            Text("Your Plan is Ready!")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color.white,
                                            Color.white.opacity(0.95)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
                                .multilineTextAlignment(.center)
                                .opacity(showContent ? 1 : 0)
                                .offset(y: showContent ? 0 : 25)
                                .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.7), value: showContent)
                            
                            Text("We've crafted a personalized journey designed specifically for your transformation")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white.opacity(0.85))
                                .multilineTextAlignment(.center)
                                .lineSpacing(3)
                                .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 1)
                                .opacity(showContent ? 1 : 0)
                                .offset(y: showContent ? 0 : 15)
                                .animation(.easeOut(duration: 1.0).delay(0.9), value: showContent)
                        }
                        .padding(.horizontal, Theme.spacing24)
                        
                        // Premium feature highlights with enhanced cards - more compact
                        VStack(spacing: Theme.spacing12) {
                            CompactPremiumFeatureCard(
                                icon: "target",
                                title: "Personalized Goals",
                                description: "Tailored to your needs",
                                color: .blue,
                                delay: 1.1
                            )
                            
                            CompactPremiumFeatureCard(
                                icon: "chart.line.uptrend.xyaxis",
                                title: "Progress Tracking",
                                description: "Monitor your journey",
                                color: .purple,
                                delay: 1.3
                            )
                            
                            CompactPremiumFeatureCard(
                                icon: "heart.fill",
                                title: "Daily Support",
                                description: "Continuous guidance",
                                color: .cyan,
                                delay: 1.5
                            )
                        }
                        .padding(.horizontal, Theme.spacing20)
                        .opacity(showFeatures ? 1 : 0)
                        .offset(y: showFeatures ? 0 : 30)
                        .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(1.1), value: showFeatures)
                    }
                    
                    Spacer()
                    
                    // Premium continue button with enhanced styling - more compact
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        
                        withAnimation(.easeInOut(duration: 0.3)) {
                            onboardingState.navigateTo(.paywall)
                        }
                    }) {
                        HStack(spacing: 10) {
                            Text("Continue to Your Plan")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.white)
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 5)
                    }
                    .padding(.horizontal, Theme.spacing20)
                    .padding(.bottom, geometry.safeAreaInsets.bottom + Theme.spacing16)
                    .opacity(showButton ? 1 : 0)
                    .offset(y: showButton ? 0 : 25)
                    .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(1.7), value: showButton)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Initial setup
        isVisible = true
        
        // Staggered content animations
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            showContent = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            showFeatures = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
            showButton = true
        }
        
        // Continuous premium animations
        withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
            glowIntensity = 0.8
            pulseAnimation = true
        }
        
        // Orbital rotation
        withAnimation(.linear(duration: 20.0).repeatForever(autoreverses: false)) {
            orbitalRotation = 360
        }
        
        // Shimmer effect
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: false).delay(1.0)) {
            shimmerOffset = 200
        }
        
        // Success icon bounce effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                successScale = 1.15
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    successScale = 1.0
                }
            }
        }
    }
}

struct CompactPremiumFeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    let delay: Double
    @State private var isVisible = false
    @State private var glowAnimation = false
    
    var body: some View {
        HStack(spacing: Theme.spacing12) {
            // Premium icon container with enhanced styling - smaller
            ZStack {
                // Glow background
                Circle()
                    .fill(color.opacity(glowAnimation ? 0.25 : 0.15))
                    .frame(width: 38, height: 38)
                    .blur(radius: 6)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: glowAnimation)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                color.opacity(0.2),
                                color.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 36, height: 36)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [color.opacity(0.4), color.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: color.opacity(0.3), radius: 6, x: 0, y: 3)
                
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(color)
                    .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
            }
            
            // Premium content with enhanced typography - compact
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                
                Text(description)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding(.horizontal, Theme.spacing16)
        .padding(.vertical, Theme.spacing12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.08),
                            Color.white.opacity(0.04)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.15), Color.white.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
        )
        .opacity(isVisible ? 1 : 0)
        .offset(x: isVisible ? 0 : -25)
        .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(delay), value: isVisible)
        .onAppear {
            isVisible = true
            glowAnimation = true
        }
    }
}

#Preview {
    NavigationStack {
        PlanReadyView()
            .environmentObject(OnboardingState())
    }
} 