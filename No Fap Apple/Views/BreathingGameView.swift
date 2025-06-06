import SwiftUI

struct BreathingGameView: View {
    enum GameState { case ready, inhaling, holding, exhaling, fail, celebrate }
    @State private var breathPhase: BreathPhase = .inhale
    @State private var breathScale: CGFloat = 1.0
    @State private var breathOpacity: Double = 0.8
    @State private var orbOffset: CGFloat = 80.0 // Start at bottom
    @State private var phaseProgress: CGFloat = 0.0
    @State private var cycleCount: Int = 0
    @State private var score: Int = 0
    @State private var combo: Int = 0
    @State private var showCelebration: Bool = false
    @State private var showPhaseText: Bool = true
    @State private var feedbackText: String? = nil
    @State private var gameState: GameState = .ready
    @State private var inhaleStart: Date? = nil
    @State private var holdTimer: Timer? = nil
    @State private var exhaleTimer: Timer? = nil
    let onDone: () -> Void
    
    private let inhaleDuration: Double = 4.0
    private let holdDuration: Double = 4.0
    private let exhaleDuration: Double = 4.0
    
    // MARK: - Phase Colors
    private var orbColor: Color {
        switch breathPhase {
        case .inhale: return Color.blue.opacity(0.7)
        case .hold: return Color.blue.opacity(0.7)
        case .exhale: return Color.cyan.opacity(0.7)
        }
    }
    private var orbGlow: Color {
        switch breathPhase {
        case .inhale: return Color.blue.opacity(0.4)
        case .hold: return Color.blue.opacity(0.4)
        case .exhale: return Color.cyan.opacity(0.4)
        }
    }
    private var orbGradient: LinearGradient {
        switch breathPhase {
        case .inhale:
            return LinearGradient(colors: [Color.blue, Color.cyan, Color.white], startPoint: .top, endPoint: .bottom)
        case .hold:
            return LinearGradient(colors: [Color.blue, Color.cyan, Color.white], startPoint: .top, endPoint: .bottom)
        case .exhale:
            return LinearGradient(colors: [Color.cyan, Color.teal, Color.white], startPoint: .top, endPoint: .bottom)
        }
    }
    
    var body: some View {
        ZStack {
            StarFieldView()
            Theme.backgroundGradient.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: { onDone() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white.opacity(0.85))
                            .shadow(radius: 8)
                            .background(
                                Circle().fill(Color.black.opacity(0.18))
                                    .frame(width: 44, height: 44)
                            )
                    }
                    .padding(.top, 18)
                    .padding(.trailing, 18)
                }
                Spacer(minLength: 0)
                Text("Breathing Game")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .padding(.bottom, 8)
                ZStack {
                    Circle()
                        .fill(orbGlow)
                        .frame(width: 260, height: 260)
                        .blur(radius: 32)
                        .opacity(0.7)
                        .offset(y: 10)
                    Circle()
                        .trim(from: 0, to: phaseProgress)
                        .stroke(orbGradient, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                        .frame(width: 240, height: 240)
                        .rotationEffect(.degrees(-90))
                        .opacity(0.7)
                        .animation(.linear(duration: inhaleDuration), value: phaseProgress)
                    Circle()
                        .fill(orbGradient)
                        .frame(width: 200, height: 200)
                        .scaleEffect(breathScale)
                        .opacity(breathOpacity)
                        .shadow(color: orbGlow, radius: 32, x: 0, y: 0)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.18), lineWidth: 2)
                        )
                        .offset(y: orbOffset)
                        .animation(.easeInOut(duration: 0.2), value: orbOffset)
                    if showPhaseText {
                        VStack(spacing: 10) {
                            Text(breathPhase.clearInstruction)
                                .font(.system(size: 30, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(color: orbGlow, radius: 8)
                                .transition(.scale.combined(with: .opacity))
                            Text(breathPhase.clearDescription)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white.opacity(0.92))
                                .multilineTextAlignment(.center)
                                .transition(.opacity)
                        }
                        .padding(.top, 120)
                    }
                    if let feedback = feedbackText {
                        Text(feedback)
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundColor(.yellow)
                            .shadow(radius: 8)
                            .transition(.scale.combined(with: .opacity))
                            .padding(.top, 60)
                    }
                }
                .frame(height: 300)
                .padding(.bottom, 16)
                HStack(spacing: 18) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 22))
                    Text("Score: \(score)")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                    if combo > 1 {
                        Text("Combo x\(combo)")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.green)
                            .transition(.scale)
                    }
                }
                .padding(.bottom, 8)
                if showCelebration {
                    Text("Perfect! 🎉")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.yellow)
                        .transition(.scale.combined(with: .opacity))
                        .padding(.bottom, 8)
                }
                if gameState == .fail {
                    Text("Try Again! Release only at the top.")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.red)
                        .padding(.bottom, 8)
                    Button("Restart") { resetGame() }
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(Capsule().fill(Color.red.opacity(0.7)))
                        .padding(.bottom, 8)
                }
                Spacer()
                if gameState == .ready || gameState == .inhaling {
                    Text("Tap and hold to inhale. Release at the top!")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.bottom, 24)
                }
            }
            if showCelebration {
                ConfettiView()
                    .transition(.opacity)
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if gameState == .ready {
                        startInhale()
                    }
                    if gameState == .inhaling {
                        updateInhale()
                    }
                }
                .onEnded { _ in
                    if gameState == .inhaling {
                        endInhale()
                    }
                }
        )
        .onAppear { resetGame() }
        .onDisappear { holdTimer?.invalidate(); exhaleTimer?.invalidate() }
    }
    
    private func startInhale() {
        gameState = .inhaling
        breathPhase = .inhale
        inhaleStart = Date()
        feedbackText = nil
        withAnimation(.easeInOut(duration: 0.2)) {
            orbOffset = 80
        }
        withAnimation(.easeInOut(duration: inhaleDuration)) {
            orbOffset = -80
        }
        withAnimation(.linear(duration: inhaleDuration)) {
            phaseProgress = 1.0
        }
    }
    private func updateInhale() {
        guard let start = inhaleStart else { return }
        let elapsed = min(Date().timeIntervalSince(start), inhaleDuration)
        let percent = elapsed / inhaleDuration
        orbOffset = 80 - (160 * percent)
        phaseProgress = percent
    }
    private func endInhale() {
        guard let start = inhaleStart else { return }
        let elapsed = Date().timeIntervalSince(start)
        if abs(elapsed - inhaleDuration) < 0.5 {
            // Perfect!
            score += 100 * (combo + 1)
            combo += 1
            cycleCount += 1
            feedbackText = "Perfect!"
            withAnimation(.spring()) { showCelebration = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation { showCelebration = false }
                feedbackText = nil
                startHold()
            }
        } else {
            // Fail
            gameState = .fail
            feedbackText = "Too early!"
            combo = 0
            withAnimation(.easeInOut) {
                orbOffset = 80
                phaseProgress = 0.0
            }
        }
    }
    private func startHold() {
        gameState = .holding
        breathPhase = .hold
        withAnimation(.easeInOut(duration: holdDuration)) {
            orbOffset = -80
            phaseProgress = 1.0
        }
        holdTimer?.invalidate()
        holdTimer = Timer.scheduledTimer(withTimeInterval: holdDuration, repeats: false) { _ in
            startExhale()
        }
    }
    private func startExhale() {
        gameState = .exhaling
        breathPhase = .exhale
        withAnimation(.easeInOut(duration: exhaleDuration)) {
            orbOffset = 80
            phaseProgress = 1.0
        }
        exhaleTimer?.invalidate()
        exhaleTimer = Timer.scheduledTimer(withTimeInterval: exhaleDuration, repeats: false) { _ in
            gameState = .ready
            breathPhase = .inhale
            orbOffset = 80
            phaseProgress = 0.0
        }
    }
    private func resetGame() {
        gameState = .ready
        breathPhase = .inhale
        orbOffset = 80
        phaseProgress = 0.0
        inhaleStart = nil
        holdTimer?.invalidate()
        exhaleTimer?.invalidate()
        feedbackText = nil
        combo = 0
    }
}

// MARK: - StarFieldView (background stars/particles)
struct StarFieldView: View {
    let starCount = 60
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<starCount, id: \.self) { i in
                    Circle()
                        .fill(Color.white.opacity(.random(in: 0.08...0.18)))
                        .frame(width: .random(in: 1.5...3.5), height: .random(in: 1.5...3.5))
                        .position(x: .random(in: 0...geo.size.width), y: .random(in: 0...geo.size.height))
                        .blur(radius: .random(in: 0...1.5))
                }
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - ConfettiView (simple confetti for celebration)
struct ConfettiView: View {
    let confettiCount = 24
    var body: some View {
        ZStack {
            ForEach(0..<confettiCount, id: \.self) { i in
                Circle()
                    .fill([Color.yellow, Color.pink, Color.cyan, Color.green, Color.orange, Color.white].randomElement()!)
                    .frame(width: .random(in: 6...14), height: .random(in: 6...14))
                    .position(x: .random(in: 0...UIScreen.main.bounds.width), y: .random(in: 0...UIScreen.main.bounds.height * 0.5))
                    .opacity(.random(in: 0.7...1.0))
                    .blur(radius: .random(in: 0...1.5))
            }
        }
        .allowsHitTesting(false)
    }
} 
