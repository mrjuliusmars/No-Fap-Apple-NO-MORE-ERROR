import SwiftUI

struct AnalysisResultView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    @Environment(\.dismiss) private var dismiss
    @State private var isVisible = false
    @State private var progressAnimation: CGFloat = 0
    @State private var scoreCountUp: Int = 0
    @State private var averageCountUp: Int = 0
    @State private var particlesAnimating = false
    
    var body: some View {
        GeometryReader { geometry in
        ZStack {
                // Premium gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.18, green: 0.15, blue: 0.28),
                        Color(red: 0.12, green: 0.08, blue: 0.22),
                        Color(red: 0.06, green: 0.04, blue: 0.16),
                        Color(red: 0.02, green: 0.01, blue: 0.08)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            
                // Enhanced floating particles
                ForEach(0..<20, id: \.self) { index in
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.white.opacity(0.1),
                                    Color.cyan.opacity(0.05),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 4
                            )
                        )
                        .frame(width: CGFloat.random(in: 2...6))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .animation(
                            .easeInOut(duration: Double.random(in: 12...20))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...8)),
                            value: particlesAnimating
                        )
                        .opacity(particlesAnimating ? Double.random(in: 0.3...0.8) : 0.1)
                        .blur(radius: 2)
                }
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Text("NO FAP")
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .tracking(1)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.clear)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.6).delay(0.1), value: isVisible)
                    
                    // All content in one VStack - no ScrollView
                    VStack(spacing: 16) {
                        // Compact Success Section
                        VStack(spacing: 12) {
                            // Smaller success icon
                            ZStack {
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [
                                                Color.green.opacity(0.5),
                                                Color.green.opacity(0.2),
                                                Color.clear
                                            ],
                                            center: .center,
                                            startRadius: 0,
                                            endRadius: 35
                                        )
                                    )
                                    .frame(width: 70, height: 70)
                                    .blur(radius: 8)
                                
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 50, weight: .bold))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [
                                                Color.green,
                                                Color.green.opacity(0.9)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: .green.opacity(0.4), radius: 8, x: 0, y: 0)
                            }
                            .opacity(isVisible ? 1.0 : 0.0)
                            .scaleEffect(isVisible ? 1.0 : 0.3)
                            .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.3), value: isVisible)
                            
                            VStack(spacing: 8) {
                                Text("Analysis Complete")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .shadow(color: .white.opacity(0.3), radius: 6, x: 0, y: 0)
                        
                                Text("Your assessment results")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.6).delay(0.5), value: isVisible)
                        }
                        .padding(.top, 8)
                        
                        // Compact Progress and Scores Combined
                        VStack(spacing: 16) {
                            Text("Dependency: \(scoreCountUp)%")
                                .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            
                            // Very compact circular progress
                            ZStack {
                                Circle()
                                    .stroke(Color.white.opacity(0.1), lineWidth: 8)
                                    .frame(width: 140, height: 140)
                                
                                Circle()
                                    .trim(from: 0, to: progressAnimation * 0.73)
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color.red, Color.orange],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                                    )
                                    .frame(width: 140, height: 140)
                                    .rotationEffect(.degrees(-90))
                                    .animation(.easeOut(duration: 2.0).delay(0.8), value: progressAnimation)
                                
                                VStack(spacing: 4) {
                                    Text("\(scoreCountUp)%")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text("High Risk")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.red.opacity(0.7))
                                        )
                                }
                            }
                            
                            // Difference statistic
                            HStack(spacing: 8) {
                                Text("58% higher dependence on porn")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.9))
                    
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(.orange)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.orange.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                                    )
                            )
                            
                            // Recovery chance cards
                            HStack(spacing: 12) {
                                // Without app card
                                VStack(spacing: 8) {
                                    Text("Recovery chance\nwithout app")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.8))
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                    
                                    Text("12%")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    // Red progress bar
                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            Rectangle()
                                                .fill(Color.white.opacity(0.2))
                                                .frame(height: 4)
                                                .cornerRadius(2)
                                            
                                            Rectangle()
                                                .fill(Color.red)
                                                .frame(width: geometry.size.width * 0.12, height: 4)
                                                .cornerRadius(2)
                                        }
                                    }
                                    .frame(height: 4)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.05))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                        )
                                )
                                
                                // With app card
                                VStack(spacing: 8) {
                                    Text("Recovery chance\nwith app")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                    
                                    Text("88%")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    // Green progress bar
                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            Rectangle()
                                                .fill(Color.white.opacity(0.2))
                                                .frame(height: 4)
                                                .cornerRadius(2)
                                            
                                            Rectangle()
                                                .fill(Color.green)
                                                .frame(width: geometry.size.width * 0.88, height: 4)
                                                .cornerRadius(2)
                                        }
                                    }
                                    .frame(height: 4)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.05))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                        )
                                )
                            }
                        }
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.6).delay(0.7), value: isVisible)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                    
                    // Fixed Button at Bottom
                    VStack {
                        Button("Check your symptoms") {
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            onboardingState.navigateTo(.symptoms(1))
                        }
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.white)
                        .cornerRadius(28)
                        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 8)
                        .padding(.horizontal, 24)
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 20)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : 30)
                        .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(1.6), value: isVisible)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            isVisible = true
            particlesAnimating = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                progressAnimation = 1.0
                animateCountUps()
            }
        }
    }
    
    private func animateCountUps() {
        let duration = 2.0
        let steps = 80
        let stepDuration = duration / Double(steps)
        
        for step in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepDuration * Double(step)) {
                scoreCountUp = Int(73.0 * Double(step) / Double(steps))
                averageCountUp = Int(15.0 * Double(step) / Double(steps))
            }
        }
    }
}

struct CompactScoreCard: View {
    let title: String
    let score: Int
    let color: Color
    let delay: Double
    @State private var isVisible = false
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
            
            Text("\(score)%")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14)
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
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    color.opacity(0.4),
                                    color.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
                .shadow(color: color.opacity(0.2), radius: 6, x: 0, y: 3)
        )
        .opacity(isVisible ? 1.0 : 0.0)
        .scaleEffect(isVisible ? 1.0 : 0.8)
        .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(delay), value: isVisible)
        .onAppear {
            isVisible = true
        }
    }
}

struct CompactInsightCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
    let delay: Double
    @State private var isVisible = false
    
    var body: some View {
        HStack(spacing: 14) {
            // Compact icon
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                iconColor.opacity(0.25),
                                iconColor.opacity(0.1)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 25
                        )
                    )
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(iconColor)
            }
            
            // Compact content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.85))
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16)
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
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.15),
                                    Color.white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
        )
        .opacity(isVisible ? 1.0 : 0.0)
        .offset(x: isVisible ? 0 : -30)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(delay), value: isVisible)
        .onAppear {
            isVisible = true
        }
    }
}

struct MiniInsightRow: View {
    let icon: String
    let color: Color
    let text: String
    let delay: Double
    @State private var isVisible = false
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(color)
                .frame(width: 20)
            
            Text(text)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.85))
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .opacity(isVisible ? 1.0 : 0.0)
        .offset(x: isVisible ? 0 : -20)
        .animation(.easeOut(duration: 0.5).delay(delay), value: isVisible)
        .onAppear {
            isVisible = true
        }
    }
}

#Preview {
    AnalysisResultView()
        .environmentObject(OnboardingState())
} 