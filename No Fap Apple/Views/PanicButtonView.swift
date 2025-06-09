import SwiftUI
import AVKit

struct PanicButtonView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedTechnique: String?
    @State private var showEmergencyContacts = false
    @State private var showMotivationalMessage = false
    @State private var messageOpacity = 0.0

    @State private var showGoonCam = false
    @State private var breathPhase: BreathPhase = .inhale
    @State private var breathScale: CGFloat = 1.0
    @State private var breathOpacity: Double = 1.0
    
    // Animation states for energy ball
    @State private var lifeforceScale: CGFloat = 1.0
    @State private var energyPulse: CGFloat = 1.0
    @State private var coreGlow: Double = 0.8
    @State private var outerEnergy: CGFloat = 1.0
    
    @State private var showMoveVideo = false
    
    let techniques = [
        ("💪", "Move"),
        ("📷", "Goon Cam")
    ]
    
    let messages = [
        "You are stronger than this urge.",
        "This feeling will pass.",
        "Your future self thanks you.",
        "Every time you resist, you get stronger.",
        "You've got this!"
    ]
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient.ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer(minLength: 32)
                // Energy Ball
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.yellow.opacity(0.3 * coreGlow),
                                    Color.orange.opacity(0.25 * coreGlow),
                                    Color.red.opacity(0.1 * coreGlow),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 85
                            )
                        )
                        .frame(width: 110, height: 110)
                        .scaleEffect(outerEnergy * 1.05)
                        .opacity(0.6)
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.white.opacity(0.4 * coreGlow),
                                    Color.yellow.opacity(0.6 * coreGlow),
                                    Color.orange.opacity(0.4 * coreGlow),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 55
                            )
                        )
                        .frame(width: 120, height: 120)
                        .scaleEffect(energyPulse * 1.08)
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.white.opacity(0.95),
                                    Color(red: 1.0, green: 0.95, blue: 0.8).opacity(coreGlow),
                                    Color(red: 1.0, green: 0.85, blue: 0.4).opacity(coreGlow)
                                ],
                                center: UnitPoint(x: 0.3, y: 0.3),
                                startRadius: 5,
                                endRadius: 50
                            )
                        )
                        .frame(width: 80, height: 80)
                        .scaleEffect(lifeforceScale)
                        .shadow(color: Color.yellow.opacity(0.5 * coreGlow), radius: 18, x: 0, y: 0)
                }
                .padding(.bottom, 12)
                
                // Header
                Text("Panic Support")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.bottom, 2)
                Text("Take a breath. Choose one action.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.bottom, 24)
                
                // Techniques
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 18) {
                    ForEach(techniques, id: \.0) { emoji, title in
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTechnique = title
                                if title == "Goon Cam" {
                                    showGoonCam = true
                                } else if title == "Move" {
                                    showMoveVideo = true
                                }
                            }
                        }) {
                            VStack(spacing: 6) {
                                Text(emoji)
                                    .font(.system(size: 32))
                                Text(title)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.white.opacity(selectedTechnique == title ? 0.18 : 0.08))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(selectedTechnique == title ? Theme.primaryNavy.opacity(0.5) : Color.clear, lineWidth: 2)
                                    )
                            )
                        }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 18)
                
                // Motivational Message
                if showMotivationalMessage {
                    Text(messages.randomElement() ?? messages[0])
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .opacity(messageOpacity)
                        .transition(.opacity)
                        .padding(.bottom, 8)
                }
                
                // Close Button
                Button(action: { dismiss() }) {
                    Text("I'm OK now")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color.white.opacity(0.08))
                        )
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 32)
                Spacer(minLength: 0)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation { showMotivationalMessage = true }
            }
            startAnimations()
        }

        .fullScreenCover(isPresented: $showGoonCam) {
            GoonCamView(onDone: { showGoonCam = false })
        }
        .fullScreenCover(isPresented: $showMoveVideo) {
            if let url = Bundle.main.url(forResource: "Avatar IV Video (2)", withExtension: "mp4") {
                let player = AVPlayer(url: url)
                VideoPlayer(player: player)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        player.play()
                    }
            } else {
                Text("Video not found")
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
            lifeforceScale = 1.12
        }
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            energyPulse = 1.15
        }
        withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
            outerEnergy = 1.25
        }
        withAnimation(.easeInOut(duration: 2.8).repeatForever(autoreverses: true)) {
            coreGlow = 1.2
        }
    }
}

enum BreathPhase {
    case inhale, hold, exhale
    var instruction: String {
        switch self {
        case .inhale: return "Breathe In"
        case .hold: return "Hold"
        case .exhale: return "Breathe Out"
        }
    }
    var description: String {
        switch self {
        case .inhale: return "Inhale deeply"
        case .hold: return "Hold briefly"
        case .exhale: return "Exhale slowly"
        }
    }
    var clearInstruction: String {
        switch self {
        case .inhale: return "Inhale through your nose"
        case .hold: return "Hold your breath"
        case .exhale: return "Exhale through your mouth"
        }
    }
    var clearDescription: String {
        switch self {
        case .inhale: return "Fill your lungs for 4 seconds."
        case .hold: return "Keep your lungs full for 4 seconds."
        case .exhale: return "Release all the air for 4 seconds."
        }
    }
}

#Preview {
    PanicButtonView()
} 