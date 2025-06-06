import SwiftUI
import AVFoundation

#if canImport(LiveKit)
import LiveKit
#endif

struct TalkToNuroView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var nuroManager = NuroAvatarManager()
    @State private var hasPermissions = false
    @State private var messageText = ""
    @State private var isKeyboardVisible = false
    @State private var hasAutoStarted = false
    @State private var showLoadingAnimation = false
    @State private var isVisible = false
    @State private var glowOpacity = 0.8
    @State private var progress = 0.0
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color.black,
                    Color(red: 0.05, green: 0.05, blue: 0.15),
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if !hasPermissions {
                permissionsView
            } else if !ApiConfig.isValid {
                configurationView
            } else {
                mainInterface
            }
        }
        .onAppear {
            checkPermissions()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            isKeyboardVisible = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            isKeyboardVisible = false
        }
        .onChange(of: hasPermissions) { permissions in
            if permissions && !hasAutoStarted && ApiConfig.isValid {
                hasAutoStarted = true
                showLoadingAnimation = true
                Task {
                    try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second for loading animation
                    await nuroManager.startSession()
                }
            }
        }
    }
    
    // MARK: - Main Interface
    private var mainInterface: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            // Main content area
            ZStack {
                if showLoadingAnimation && !nuroManager.isSessionActive {
                    loadingScreen
                        .transition(.opacity.combined(with: .scale))
                } else {
                    avatarInterface
                        .transition(.opacity.combined(with: .scale))
                }
            }
            .animation(.easeInOut(duration: 0.6), value: showLoadingAnimation)
            .animation(.easeInOut(duration: 0.6), value: nuroManager.isSessionActive)
            
            // Bottom controls
            if nuroManager.isSessionActive {
                bottomControls
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: nuroManager.isSessionActive)
            }
        }
    }
    
    // MARK: - Header
    private var headerView: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    Task {
                        nuroManager.endSession()
                    }
                    dismiss()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Close")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(20)
                }
                
                Spacer()
                
                // Connection status
                HStack(spacing: 8) {
                    Circle()
                        .fill(connectionColor)
                        .frame(width: 8, height: 8)
                        .shadow(color: connectionColor, radius: 3)
                    
                    Text(nuroManager.connectionStatus.displayText)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.black.opacity(0.3))
                .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            
            // Title
            Text("Talk to Nuro")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.top, 16)
        }
        .padding(.bottom, 20)
    }
    
    // MARK: - Loading Screen
    private var loadingScreen: some View {
        ZStack {
            // Background gradient to match main interface
            LinearGradient(
                colors: [
                    Color.black,
                    Color(red: 0.05, green: 0.05, blue: 0.15),
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(.all)
            
            GeometryReader { geometry in
                
                // Floating particles for atmosphere
                ForEach(0..<8, id: \.self) { index in
                    Circle()
                        .fill(Color.white.opacity(0.02))
                        .frame(width: CGFloat.random(in: 1...3))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .animation(
                            .easeInOut(duration: Double.random(in: 8...15))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...5)),
                            value: showLoadingAnimation
                        )
                        .opacity(showLoadingAnimation ? 0.1 : 0.02)
                }
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Main loading content
                    VStack(spacing: Theme.spacing48) {
                        // Splash-style Aura ball with progress
                        ZStack {
                            // Main energy ball matching SplashView
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            Color.white.opacity(1.0),
                                            Color.blue.opacity(0.8),
                                            Color.purple.opacity(0.6),
                                            Color.cyan.opacity(0.7),
                                            Color.clear
                                        ],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 80
                                    )
                                )
                                .frame(width: 160, height: 160)
                                .scaleEffect(isVisible ? 1.1 : 1.0)
                                .overlay(
                                    // Rotating shimmer effect like SplashView
                                    Circle()
                                        .stroke(
                                            AngularGradient(
                                                colors: [
                                                    Color.clear,
                                                    Color.white.opacity(0.8),
                                                    Color.clear,
                                                    Color.blue.opacity(0.6),
                                                    Color.clear,
                                                    Color.white.opacity(0.4),
                                                    Color.clear
                                                ],
                                                center: .center
                                            ),
                                            lineWidth: 4
                                        )
                                        .frame(width: 150, height: 150)
                                        .rotationEffect(.degrees(showLoadingAnimation ? 360 : 0))
                                        .opacity(0.8)
                                )
                                .shadow(color: Color.blue, radius: 30, x: 0, y: 0)
                                .shadow(color: Color.purple.opacity(0.8), radius: 20, x: 0, y: 0)
                                .shadow(color: Color.white.opacity(0.3), radius: 40, x: 0, y: 0)
                                .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 8)
                                .animation(
                                    .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                                    value: isVisible
                                )
                            
                            // Progress circle overlay
                            Circle()
                                .stroke(Color.white.opacity(0.2), lineWidth: 6)
                                .frame(width: 180, height: 180)
                            
                            Circle()
                                .trim(from: 0, to: progress)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color.white,
                                            Color.blue,
                                            Color.purple,
                                            Color.cyan
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                                )
                                .frame(width: 180, height: 180)
                                .rotationEffect(.degrees(-90))
                                .animation(.easeInOut(duration: 0.3), value: progress)
                                .shadow(color: Color.white.opacity(0.5), radius: 8)
                            
                            // Central Nuro avatar
                            ZStack {
                                // Professional Nuro logo/icon
                                ZStack {
                                    // Outer ring
                                    Circle()
                                        .stroke(Color.white.opacity(0.9), lineWidth: 3)
                                        .frame(width: 50, height: 50)
                                    
                                    // Inner pulsing core
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 16, height: 16)
                                        .scaleEffect(showLoadingAnimation ? 1.4 : 1.0)
                                        .opacity(showLoadingAnimation ? 0.7 : 1.0)
                                        .animation(
                                            .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                                            value: showLoadingAnimation
                                        )
                                    
                                    // Orbiting elements
                                    ForEach(0..<3, id: \.self) { index in
                                        Circle()
                                            .fill(Color.white.opacity(0.8))
                                            .frame(width: 4, height: 4)
                                            .offset(y: -22)
                                            .rotationEffect(.degrees(Double(index * 120) + (showLoadingAnimation ? 360 : 0)))
                                            .animation(
                                                .linear(duration: 4.0).repeatForever(autoreverses: false),
                                                value: showLoadingAnimation
                                            )
                                    }
                                }
                                .shadow(color: Color.white.opacity(0.5), radius: 8)
                            }
                            
                            // Progress percentage positioned below the aura ball
                            VStack {
                                Spacer()
                                Text("\(Int(progress * 100))%")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .shadow(color: Color.blue.opacity(0.6), radius: 8)
                                    .padding(.top, 100)
                            }
                        }
                        .scaleEffect(isVisible ? 1.0 : 0.8)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: isVisible)
                        
                        // Loading text content
                        VStack(spacing: Theme.spacing16) {
                            Text("Awakening Nuro")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .animation(.easeOut(duration: 0.6).delay(0.4), value: isVisible)
                            
                            Text("Initializing AI avatar system and establishing secure connection")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .animation(.easeOut(duration: 0.6).delay(0.6), value: isVisible)
                        }
                        .padding(.horizontal, Theme.spacing32)
                    }
                    
                    Spacer()
                    
                                         // Bottom safe area spacing
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: geometry.safeAreaInsets.bottom + Theme.spacing32)
                }
            }
        }
        .onAppear {
            isVisible = true
            glowOpacity = 0.8
            startNuroLoading()
            
            // Start continuous rotation animation like SplashView
            withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                showLoadingAnimation = true
            }
        }
    }
    
    // MARK: - Avatar Interface
    private var avatarInterface: some View {
        VStack(spacing: 0) {
            // Video area
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.black.opacity(0.6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.blue.opacity(0.5), Color.purple.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                
                if let videoTrack = nuroManager.remoteVideoTrack {
                    // Video feed
                    LiveKitVideoView(track: videoTrack)
                        .cornerRadius(24)
                        .overlay(
                            // Status indicator overlay
                            VStack {
                                Spacer()
                                HStack {
                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(nuroManager.isAvatarSpeaking ? Color.green : Color.blue)
                                            .frame(width: 8, height: 8)
                                            .shadow(color: nuroManager.isAvatarSpeaking ? .green : .blue, radius: 4)
                                        
                                        Text(nuroManager.isAvatarSpeaking ? "Speaking" : "Listening")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(.white)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.black.opacity(0.7))
                                    .cornerRadius(16)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                .padding(.bottom, 16)
                            }
                        )
                } else {
                    // Connecting state - matching the loading screen design
                    VStack(spacing: 24) {
                        ZStack {
                            // Professional Nuro connecting icon
                            Circle()
                                .fill(Color.blue.opacity(0.2))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Circle()
                                        .stroke(Color.blue, lineWidth: 3)
                                        .scaleEffect(1.2)
                                        .opacity(0.6)
                                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: false), value: UUID())
                                )
                            
                            // Professional Nuro logo/icon matching loading screen
                            ZStack {
                                // Outer ring
                                Circle()
                                    .stroke(Color.white.opacity(0.9), lineWidth: 2)
                                    .frame(width: 35, height: 35)
                                
                                // Inner pulsing core
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 10, height: 10)
                                    .scaleEffect(1.2)
                                    .opacity(0.8)
                                    .animation(
                                        .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                                        value: UUID()
                                    )
                                
                                // Orbiting elements
                                ForEach(0..<3, id: \.self) { index in
                                    Circle()
                                        .fill(Color.white.opacity(0.7))
                                        .frame(width: 3, height: 3)
                                        .offset(y: -15)
                                        .rotationEffect(.degrees(Double(index * 120)))
                                        .animation(
                                            .linear(duration: 3.0).repeatForever(autoreverses: false),
                                            value: UUID()
                                        )
                                }
                            }
                            .shadow(color: Color.white.opacity(0.3), radius: 5)
                        }
                        
                        VStack(spacing: 8) {
                            Text("Connecting to Nuro...")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("Please wait while we establish connection")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                }
            }
            .frame(height: UIScreen.main.bounds.height * 0.55) // 55% of screen height
            .padding(.horizontal, 20)
            
            // Chat area
            if nuroManager.isSessionActive {
                chatArea
                    .padding(.top, 20)
            }
        }
    }
    
    // MARK: - Chat Area
    private var chatArea: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                TextField("Type your message...", text: $messageText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(
                            LinearGradient(
                                colors: [Color.blue, Color.blue.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(22)
                        .shadow(color: .blue.opacity(0.3), radius: 4)
                }
                .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .opacity(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1.0)
            }
            .padding(.horizontal, 20)
            
            if !nuroManager.lastMessage.isEmpty {
                HStack {
                    Text("💬 \(nuroManager.lastMessage)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    // MARK: - Bottom Controls
    private var bottomControls: some View {
        HStack(spacing: 20) {
            // Microphone
            Button(action: {
                nuroManager.toggleMute()
            }) {
                ZStack {
                    Circle()
                        .fill(nuroManager.isMuted ? Color.red.opacity(0.8) : Color.green.opacity(0.8))
                        .frame(width: 60, height: 60)
                        .shadow(color: nuroManager.isMuted ? .red.opacity(0.4) : .green.opacity(0.4), radius: 8)
                    
                    Image(systemName: nuroManager.isMuted ? "mic.slash.fill" : "mic.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .scaleEffect(nuroManager.isMuted ? 0.9 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: nuroManager.isMuted)
            
            Spacer()
            
            // End session
            Button(action: {
                Task {
                    nuroManager.endSession()
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "phone.down.fill")
                        .font(.system(size: 16, weight: .semibold))
                    Text("End Session")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.red.opacity(0.8))
                .cornerRadius(24)
                .shadow(color: .red.opacity(0.3), radius: 6)
            }
            
            Spacer()
            
            // Camera
            Button(action: {
                nuroManager.toggleCamera()
            }) {
                ZStack {
                    Circle()
                        .fill(nuroManager.isCameraOn ? Color.blue.opacity(0.8) : Color.gray.opacity(0.8))
                        .frame(width: 60, height: 60)
                        .shadow(color: nuroManager.isCameraOn ? .blue.opacity(0.4) : .gray.opacity(0.4), radius: 8)
                    
                    Image(systemName: nuroManager.isCameraOn ? "video.fill" : "video.slash.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .scaleEffect(nuroManager.isCameraOn ? 1.0 : 0.9)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: nuroManager.isCameraOn)
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 20)
    }
    
    private var connectionColor: Color {
        switch nuroManager.connectionStatus {
        case .connected: return .green
        case .connecting: return .yellow
        case .error: return .red
        case .disconnected: return .gray
        }
    }
    
    // MARK: - Permission Views (keeping existing implementation)
    private var permissionsView: some View {
        VStack(spacing: 24) {
            Image(systemName: "person.wave.2.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue.opacity(0.8))
            
            VStack(spacing: 16) {
                Text("Camera & Microphone Access")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Text("To talk with Nuro, we need access to your camera and microphone for real-time conversation.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Button("Grant Permissions") {
                requestPermissions()
            }
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(28)
            .padding(.horizontal, 40)
        }
    }
    
    private var configurationView: some View {
        VStack(spacing: 24) {
            Image(systemName: "gear.badge.questionmark")
                .font(.system(size: 80))
                .foregroundColor(.orange.opacity(0.8))
            
            VStack(spacing: 16) {
                Text("Configuration Required")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Please configure your HeyGen credentials in ApiConfig.swift to enable Nuro.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                if let error = ApiConfig.configurationError {
                    Text(error)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.red.opacity(0.8))
                        .padding(.horizontal, 32)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
    
    // MARK: - Methods
    private func checkPermissions() {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        let microphoneStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        hasPermissions = (cameraStatus == .authorized) && (microphoneStatus == .authorized)
    }
    
    private func requestPermissions() {
        AVCaptureDevice.requestAccess(for: .video) { videoGranted in
            AVCaptureDevice.requestAccess(for: .audio) { audioGranted in
                DispatchQueue.main.async {
                    self.hasPermissions = videoGranted && audioGranted
                }
            }
        }
    }
    
    private func sendMessage() {
        let message = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !message.isEmpty else { return }
        
        Task {
            await nuroManager.sendMessage(message)
        }
        
        messageText = ""
    }
    
    private func startNuroLoading() {
        // Multiple haptic generators for variety
        let lightGenerator = UIImpactFeedbackGenerator(style: .light)
        let mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
        let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
        let selectionGenerator = UISelectionFeedbackGenerator()
        
        // Prepare all generators
        lightGenerator.prepare()
        mediumGenerator.prepare()
        heavyGenerator.prepare()
        selectionGenerator.prepare()
        
        let totalDuration: Double = 3.5 // 3.5 seconds for Nuro loading
        let stepDuration: Double = 0.07 // Smooth haptic timing
        let totalSteps = Int(totalDuration / stepDuration)
        let progressPerStep = 1.0 / Double(totalSteps)
        
        func updateProgress(step: Int) {
            if step < totalSteps {
                let currentProgress = Double(step) * progressPerStep
                
                withAnimation(.easeInOut(duration: stepDuration)) {
                    progress += progressPerStep
                }
                
                // Enhanced haptic patterns for Nuro awakening
                
                // Subtle base rhythm - every other step
                if step % 2 == 0 {
                    lightGenerator.impactOccurred(intensity: 0.2)
                }
                
                // Medium haptics at 15% intervals for milestones
                if step % (totalSteps / 7) == 0 {
                    mediumGenerator.impactOccurred(intensity: 0.5)
                }
                
                // Selection feedback for major progress points
                if step % (totalSteps / 10) == 0 {
                    selectionGenerator.selectionChanged()
                }
                
                // Special Nuro awakening patterns
                switch Int(currentProgress * 100) {
                case 20:
                    // Nuro stirring - gentle pulse
                    lightGenerator.impactOccurred(intensity: 0.6)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        lightGenerator.impactOccurred(intensity: 0.4)
                    }
                    
                case 40:
                    // Systems coming online - double tap
                    mediumGenerator.impactOccurred(intensity: 0.7)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        mediumGenerator.impactOccurred(intensity: 0.5)
                    }
                    
                case 60:
                    // Neural networks activating - triple pulse
                    heavyGenerator.impactOccurred(intensity: 0.6)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        mediumGenerator.impactOccurred(intensity: 0.5)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        lightGenerator.impactOccurred(intensity: 0.4)
                    }
                    
                case 80:
                    // Consciousness emerging - ascending pattern
                    lightGenerator.impactOccurred(intensity: 0.4)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.07) {
                        mediumGenerator.impactOccurred(intensity: 0.6)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.14) {
                        heavyGenerator.impactOccurred(intensity: 0.8)
                    }
                    
                case 95...99:
                    // Final awakening - rapid gentle pulses
                    if step % 2 == 0 {
                        lightGenerator.impactOccurred(intensity: 0.5)
                    }
                    
                default:
                    break
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + stepDuration) {
                    updateProgress(step: step + 1)
                }
            } else {
                // Ensure we reach exactly 100%
                withAnimation(.easeInOut(duration: 0.3)) {
                    progress = 1.0
                }
                
                // Epic Nuro awakening sequence - powerful crescendo
                heavyGenerator.impactOccurred(intensity: 1.0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    mediumGenerator.impactOccurred(intensity: 0.8)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    lightGenerator.impactOccurred(intensity: 0.6)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    selectionGenerator.selectionChanged()
                }
                
                // Hide loading animation and show Nuro interface
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        showLoadingAnimation = false
                    }
                }
            }
        }
        
        // Start the progress updates with a slight delay for dramatic effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            updateProgress(step: 0)
        }
    }
}

#Preview {
    TalkToNuroView()
} 
