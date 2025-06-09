import SwiftUI

struct EducationalSlideView: View {
    let slideNumber: Int
    @EnvironmentObject var onboardingState: OnboardingState
    @State private var isAnimating = false
    @State private var particlesAnimating = false
    @State private var brainPulse = false
    @State private var brainGlow = false
    
    private var currentSlide: EducationalSlide {
        educationalSlides[slideNumber - 1]
    }
    
    private var progress: CGFloat {
        CGFloat(slideNumber) / CGFloat(educationalSlides.count)
    }
    
    var body: some View {
        GeometryReader { geometry in
        ZStack {
                // Premium gradient background with enhanced depth
                LinearGradient(
                    colors: [
                        Color(red: 0.08, green: 0.15, blue: 0.28),   // Light navy top
                        Color(red: 0.06, green: 0.12, blue: 0.22),   // Slightly deeper navy
                        Color(red: 0.05, green: 0.1, blue: 0.2)      // Consistent light navy bottom
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
                            value: particlesAnimating
                        )
                        .opacity(particlesAnimating ? Double.random(in: 0.3...0.8) : 0.1)
                        .blur(radius: 1)
                }
                
                VStack(spacing: 0) {
                    // Clean top branding and progress
                    VStack(spacing: Theme.spacing8) {
                        HStack {
                            Text("UNFAP")
                                .font(.system(size: 24, weight: .black, design: .rounded))
                                .tracking(1)
                                .foregroundColor(.white)
                                .opacity(isAnimating ? 1.0 : 0.0)
                                .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.1), value: isAnimating)
                
                Spacer()
                        }
                        .padding(.horizontal, Theme.spacing24)
                        .padding(.top, 15)
                    }
                    
                    // Main content - no scroll, compact layout
                    VStack(spacing: Theme.spacing32) {
                        // Custom animated components for different slides
                        if slideNumber == 1 {
                            AnimatedBrainView()
                                .opacity(isAnimating ? 1 : 0)
                                .scaleEffect(isAnimating ? 1 : 0.5)
                                .animation(.easeOut(duration: 0.8).delay(0.5), value: isAnimating)
                        } else if slideNumber == 2 {
                            AnimatedHeartBreakView()
                                .opacity(isAnimating ? 1 : 0)
                                .scaleEffect(isAnimating ? 1 : 0.5)
                                .animation(.easeOut(duration: 0.8).delay(0.5), value: isAnimating)
                        } else if slideNumber == 3 {
                            AnimatedEnergyDrainView()
                        .opacity(isAnimating ? 1 : 0)
                        .scaleEffect(isAnimating ? 1 : 0.5)
                                .animation(.easeOut(duration: 0.8).delay(0.5), value: isAnimating)
                        }
                        
                        // Premium text content with enhanced typography
                        VStack(spacing: Theme.spacing20) {
                            Text(currentSlide.title)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                                .lineSpacing(2)
                                .opacity(isAnimating ? 1 : 0)
                                .offset(y: isAnimating ? 0 : 30)
                                .animation(.easeOut(duration: 0.6).delay(0.7), value: isAnimating)
                            
                            // Dots indicator below title
                            HStack(spacing: 8) {
                                ForEach(1...educationalSlides.count, id: \.self) { index in
                                    Circle()
                                        .fill(index == slideNumber ? Color.white : Color.white.opacity(0.3))
                                        .frame(width: 8, height: 8)
                                        .scaleEffect(index == slideNumber ? 1.2 : 1.0)
                                        .animation(.easeInOut(duration: 0.3), value: slideNumber)
                                }
                            }
                        .opacity(isAnimating ? 1 : 0)
                            .animation(.easeOut(duration: 0.6).delay(0.8), value: isAnimating)
                            
                            Text(currentSlide.content)
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                                .lineSpacing(4)
                        .opacity(isAnimating ? 1 : 0)
                                .offset(y: isAnimating ? 0 : 30)
                                .animation(.easeOut(duration: 0.6).delay(0.9), value: isAnimating)
                        }
                        .padding(.horizontal, Theme.spacing24)
                    }
                    .padding(.top, Theme.spacing32)
                    
                    Spacer()
                    
                    // Clean continue button
                    VStack(spacing: Theme.spacing16) {
                    Button(action: {
                            print("🔥 Educational slide \(slideNumber) button pressed")
                            print("🔥 Total slides: \(educationalSlides.count)")
                            
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            
                        if slideNumber == educationalSlides.count {
                                print("🔥 Navigating to goals")
                                onboardingState.navigateTo(.goals)
                        } else {
                                print("🔥 Navigating to educational slide \(slideNumber + 1)")
                            onboardingState.navigateTo(.educational(slideNumber + 1))
                        }
                    }) {
                            HStack(spacing: Theme.spacing8) {
                                Text(slideNumber == educationalSlides.count ? "Continue" : "Next")
                                    .font(.system(size: 17, weight: .semibold))
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 15, weight: .bold))
                            }
                            .foregroundColor(.black)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 5)
                        }
                        .opacity(isAnimating ? 1 : 0)
                        .offset(y: isAnimating ? 0 : 30)
                        .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(1.1), value: isAnimating)
                    }
                    .padding(.horizontal, Theme.spacing24)
                    .padding(.bottom, geometry.safeAreaInsets.bottom + Theme.spacing16)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            print("🎬 Educational slide \(slideNumber) appeared")
            // Reset animation states
            isAnimating = false
            particlesAnimating = false
            
            // Start animations with a small delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isAnimating = true
                particlesAnimating = true
            }
        }
    }
}

struct AnimatedBrainView: View {
    @State private var pulseScale: CGFloat = 1.0
    @State private var glowOpacity: Double = 0.3
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            // Glow effect background
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.pink.opacity(glowOpacity),
                            Color.red.opacity(glowOpacity * 0.5),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 80
                    )
                )
                .frame(width: 160, height: 160)
                .blur(radius: 10)
                .animation(
                    Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                    value: glowOpacity
                )
            
            // Brain icon with multiple animations
            Image(systemName: "brain.head.profile")
                .font(.system(size: 80, weight: .medium))
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.pink,
                            Color.red,
                            Color.orange
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .scaleEffect(pulseScale)
                .rotationEffect(.degrees(rotationAngle))
                .shadow(color: .pink.opacity(0.5), radius: 10, x: 0, y: 0)
                .animation(
                    Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                    value: pulseScale
                )
                .animation(
                    Animation.linear(duration: 8.0).repeatForever(autoreverses: false),
                    value: rotationAngle
                )
        }
        .onAppear {
            // Reset all animation states first
            resetAnimationStates()
            // Start animation after a brief delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                startBrainAnimation()
            }
        }
    }
    
    private func resetAnimationStates() {
        pulseScale = 1.0
        glowOpacity = 0.3
        rotationAngle = 0
    }
    
    private func startBrainAnimation() {
        // Start pulsing animation
        pulseScale = 1.2
        
        // Start glow animation
        glowOpacity = 0.8
        
        // Start rotation animation
        rotationAngle = 5
    }
}

struct AnimatedHeartBreakView: View {
    @State private var heartScale: CGFloat = 1.0
    @State private var glowIntensity: Double = 0.3
    @State private var crackOpacity: Double = 0.0
    @State private var isHeartBroken = false
    @State private var leftPieceOffset: CGFloat = 0
    @State private var rightPieceOffset: CGFloat = 0
    @State private var leftPieceRotation: Double = 0
    @State private var rightPieceRotation: Double = 0
    @State private var heartOpacity: Double = 1.0
    @State private var pulseEffect: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // Premium multi-layer glow background
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.red.opacity(glowIntensity * 0.6),
                            Color.pink.opacity(glowIntensity * 0.4),
                            Color.blue.opacity(glowIntensity * 0.2),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 120
                    )
                )
                .frame(width: 240, height: 240)
                .blur(radius: 20)
                .scaleEffect(pulseEffect)
                .animation(
                    Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                    value: glowIntensity
                )
                .animation(
                    Animation.easeInOut(duration: 1.8).repeatForever(autoreverses: true),
                    value: pulseEffect
                )
            
            // Secondary glow layer for depth
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.red.opacity(glowIntensity * 0.3),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 60
                    )
                )
                .frame(width: 120, height: 120)
                .blur(radius: 10)
                .animation(
                    Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(0.3),
                    value: glowIntensity
                )
            
            if !isHeartBroken {
                // Whole heart with premium effects
                ZStack {
                    // Shadow layer for depth
                    Image(systemName: "heart.fill")
                        .font(.system(size: 85, weight: .bold))
                        .foregroundColor(.black.opacity(0.3))
                        .offset(x: 2, y: 4)
                        .blur(radius: 6)
                        .scaleEffect(heartScale)
                    
                    // Main heart with premium gradient
                    Image(systemName: "heart.fill")
                        .font(.system(size: 80, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.red,
                                    Color.red.opacity(0.9),
                                    Color.pink.opacity(0.8),
                                    Color.red.opacity(0.7)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(heartScale)
                        .opacity(heartOpacity)
                        .shadow(color: .red.opacity(0.6), radius: 15, x: 0, y: 0)
                        .animation(
                            Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                            value: heartScale
                        )
                }
                
                // Crack that appears before breaking
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.black,
                                Color.gray.opacity(0.8),
                                Color.black
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 3, height: 70)
                    .opacity(crackOpacity)
                    .scaleEffect(heartScale)
                    .shadow(color: .black, radius: 4, x: 0, y: 0)
                    .animation(
                        Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                        value: heartScale
                    )
            } else {
                // Broken heart pieces with premium effects
                ZStack {
                    // Left half with shadow
                    ZStack {
                        // Shadow for left piece
                        Image(systemName: "heart.fill")
                            .font(.system(size: 85, weight: .bold))
                            .foregroundColor(.black.opacity(0.3))
                            .mask(
                                Rectangle()
                                    .frame(width: 42, height: 85)
                                    .offset(x: -21, y: 0)
                            )
                            .offset(x: leftPieceOffset + 2, y: leftPieceOffset * 0.3 + 4)
                            .rotationEffect(.degrees(leftPieceRotation))
                            .blur(radius: 6)
                        
                        // Main left piece
                        Image(systemName: "heart.fill")
                            .font(.system(size: 80, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.red,
                                        Color.red.opacity(0.9),
                                        Color.pink.opacity(0.8)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .mask(
                                Rectangle()
                                    .frame(width: 40, height: 80)
                                    .offset(x: -20, y: 0)
                            )
                            .offset(x: leftPieceOffset, y: leftPieceOffset * 0.3)
                            .rotationEffect(.degrees(leftPieceRotation))
                            .opacity(heartOpacity)
                            .shadow(color: .red.opacity(0.6), radius: 12, x: 0, y: 0)
                    }
                    
                    // Right half with shadow
                    ZStack {
                        // Shadow for right piece
                        Image(systemName: "heart.fill")
                            .font(.system(size: 85, weight: .bold))
                            .foregroundColor(.black.opacity(0.3))
                            .mask(
                                Rectangle()
                                    .frame(width: 42, height: 85)
                                    .offset(x: 21, y: 0)
                            )
                            .offset(x: rightPieceOffset + 2, y: rightPieceOffset * 0.3 + 4)
                            .rotationEffect(.degrees(rightPieceRotation))
                            .blur(radius: 6)
                        
                        // Main right piece
                        Image(systemName: "heart.fill")
                            .font(.system(size: 80, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.red,
                                        Color.red.opacity(0.9),
                                        Color.pink.opacity(0.8)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .mask(
                                Rectangle()
                                    .frame(width: 40, height: 80)
                                    .offset(x: 20, y: 0)
                            )
                            .offset(x: rightPieceOffset, y: rightPieceOffset * 0.3)
                            .rotationEffect(.degrees(rightPieceRotation))
                            .opacity(heartOpacity)
                            .shadow(color: .red.opacity(0.6), radius: 12, x: 0, y: 0)
                    }
                }
            }
            
            // Premium lightning crack effect
            Image(systemName: "bolt.fill")
                .font(.system(size: 70, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color.yellow,
                            Color.orange,
                            Color.red
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .opacity(crackOpacity * 0.7)
                .rotationEffect(.degrees(90))
                .blur(radius: 1)
                .shadow(color: .yellow.opacity(0.6), radius: 8, x: 0, y: 0)
                .animation(
                    Animation.easeIn(duration: 0.3).delay(2.0),
                    value: crackOpacity
                )
        }
        .onAppear {
            // Reset animation states first
            resetAnimationStates()
            // Start animation after a brief delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                startHeartAnimation()
            }
        }
    }
    
    private func resetAnimationStates() {
        heartScale = 1.0
        glowIntensity = 0.3
        crackOpacity = 0.0
        isHeartBroken = false
        leftPieceOffset = 0
        rightPieceOffset = 0
        leftPieceRotation = 0
        rightPieceRotation = 0
        heartOpacity = 1.0
        pulseEffect = 1.0
    }
    
    private func startHeartAnimation() {
        // Initial premium throbbing
        withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
            heartScale = 1.15
            pulseEffect = 1.08
        }
        
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            glowIntensity = 0.8
        }
        
        // Show crack developing
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeIn(duration: 0.5)) {
                crackOpacity = 1.0
            }
        }
        
        // Heart breaks open with premium spring animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0.3)) {
                isHeartBroken = true
                leftPieceOffset = -35
                rightPieceOffset = 35
                leftPieceRotation = -20
                rightPieceRotation = 20
            }
        }
        
        // Pieces continue to drift apart
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            withAnimation(.easeOut(duration: 2.0)) {
                leftPieceOffset = -50
                rightPieceOffset = 50
                leftPieceRotation = -30
                rightPieceRotation = 30
                heartOpacity = 0.7
            }
        }
        
        // Final gentle fade
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            withAnimation(.easeOut(duration: 2.0)) {
                heartOpacity = 0.4
                glowIntensity = 0.3
            }
        }
    }
}

struct AnimatedEnergyDrainView: View {
    @State private var clockRotation: Double = 0
    @State private var timeNumbers: [Int] = [12, 3, 6, 9]
    @State private var numbersOpacity: Double = 1.0
    @State private var clockGlow: Double = 0.3
    @State private var clockScale: CGFloat = 1.0
    @State private var hourHandRotation: Double = 0
    @State private var minuteHandRotation: Double = 0
    @State private var secondHandRotation: Double = 0
    
    var body: some View {
        ZStack {
            BackgroundGlowView(clockGlow: clockGlow)
            ClockFaceView(clockScale: clockScale, numbersOpacity: numbersOpacity, timeNumbers: timeNumbers)
            ClockHandsView(
                hourHandRotation: hourHandRotation,
                minuteHandRotation: minuteHandRotation,
                secondHandRotation: secondHandRotation
            )
        }
        .onAppear {
            // Reset all animation states first
            resetAnimationStates()
            // Start animation after a brief delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                startAnimations()
            }
        }
    }
    
    private func resetAnimationStates() {
        clockRotation = 0
        numbersOpacity = 1.0
        clockGlow = 0.3
        clockScale = 1.0
        hourHandRotation = 0
        minuteHandRotation = 0
        secondHandRotation = 0
    }
    
    private func startAnimations() {
        // Clock pulsing effect
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            clockScale = 1.1
        }
        
        // Glow intensity
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            clockGlow = 0.8
        }
        
        // Hour hand - very slow, smooth continuous rotation
        withAnimation(.linear(duration: 20.0).repeatForever(autoreverses: false)) {
            hourHandRotation = 360
        }
        
        // Minute hand - medium speed, smooth continuous rotation
        withAnimation(.linear(duration: 12.0).repeatForever(autoreverses: false)) {
            minuteHandRotation = 360
        }
        
        // Second hand - fast smooth continuous spinning
        withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
            secondHandRotation = 360
        }
        
        // Numbers fading away over time
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut(duration: 4.0)) {
                numbersOpacity = 0.1
            }
        }
    }
}

struct BackgroundGlowView: View {
    let clockGlow: Double
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(clockGlow * 0.6),
                        Color.blue.opacity(clockGlow * 0.4),
                        Color.clear
                    ]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 100
                )
            )
            .frame(width: 200, height: 200)
            .blur(radius: 20)
            .animation(
                Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                value: clockGlow
            )
    }
}

struct ClockFaceView: View {
    let clockScale: CGFloat
    let numbersOpacity: Double
    let timeNumbers: [Int]
    
    var body: some View {
        ZStack {
            // Main clock face
            Circle()
                .stroke(Color.white.opacity(0.8), lineWidth: 4)
                .frame(width: 160, height: 160)
                .scaleEffect(clockScale)
                .shadow(color: .white.opacity(0.3), radius: 10, x: 0, y: 0)
                .animation(
                    Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                    value: clockScale
                )
            
            // Hour markers
            HourMarkersView(numbersOpacity: numbersOpacity)
            
            // Clock numbers
            ClockNumbersView(timeNumbers: timeNumbers, numbersOpacity: numbersOpacity)
        }
    }
}

struct HourMarkersView: View {
    let numbersOpacity: Double
    
    var body: some View {
        ForEach(0..<12, id: \.self) { hour in
            Rectangle()
                .fill(Color.white.opacity(0.6))
                .frame(width: hour % 3 == 0 ? 3 : 1.5, height: hour % 3 == 0 ? 15 : 8)
                .offset(y: -70)
                .rotationEffect(.degrees(Double(hour) * 30))
                .opacity(numbersOpacity)
        }
    }
}

struct ClockNumbersView: View {
    let timeNumbers: [Int]
    let numbersOpacity: Double
    
    var body: some View {
        ForEach(Array(timeNumbers.enumerated()), id: \.offset) { index, number in
            Text("\(number)")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .opacity(numbersOpacity)
                .offset(
                    x: cos(Double(index) * .pi / 2 - .pi / 2) * 55,
                    y: sin(Double(index) * .pi / 2 - .pi / 2) * 55
                )
                .animation(
                    Animation.easeOut(duration: 2.0).delay(Double(index) * 0.3),
                    value: numbersOpacity
                )
        }
    }
}

struct ClockHandsView: View {
    let hourHandRotation: Double
    let minuteHandRotation: Double
    let secondHandRotation: Double
    
    var body: some View {
        ZStack {
            // Hour hand
            Rectangle()
                .fill(Color.white.opacity(0.9))
                .frame(width: 4, height: 35)
                .offset(y: -17.5)
                .rotationEffect(.degrees(hourHandRotation))
            
            // Minute hand
            Rectangle()
                .fill(Color.white.opacity(0.9))
                .frame(width: 3, height: 50)
                .offset(y: -25)
                .rotationEffect(.degrees(minuteHandRotation))
            
            // Second hand (red, thin, fast)
            Rectangle()
                .fill(Color.red.opacity(0.8))
                .frame(width: 1, height: 60)
                .offset(y: -30)
                .rotationEffect(.degrees(secondHandRotation))
            
            // Center dot
            Circle()
                .fill(Color.white)
                .frame(width: 8, height: 8)
                .shadow(color: .white.opacity(0.5), radius: 3, x: 0, y: 0)
        }
    }
}

#Preview {
    NavigationStack(path: .constant(NavigationPath())) {
        EducationalSlideView(slideNumber: 1)
            .environmentObject(OnboardingState())
    }
} 
