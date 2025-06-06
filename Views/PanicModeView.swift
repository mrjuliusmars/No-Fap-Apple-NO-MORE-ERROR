import SwiftUI
import AVFoundation

struct PanicModeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isVisible = false
    @State private var currentMessageIndex = 0
    @State private var messageTimer: Timer?
    @State private var cameraManager = CameraManager()
    
    private let motivationalMessages = [
        "This moment doesn't define you.",
        "Remember why you started.",
        "You're stronger than this urge.",
        "Breathe. Let it pass.",
        "Your future self will thank you.",
        "This feeling is temporary.",
        "You have the power to choose.",
        "Stay strong. You've got this."
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Camera View
                CameraPreview(cameraManager: cameraManager)
                    .ignoresSafeArea()
                
                // Semi-transparent overlay
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.7),
                        Color.black.opacity(0.5),
                        Color.black.opacity(0.3),
                        Color.black.opacity(0.5),
                        Color.black.opacity(0.7)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Motivational Content
                    VStack(spacing: 32) {
                        // Emergency Icon
                        ZStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            Color.red.opacity(0.3),
                                            Color.red.opacity(0.1),
                                            Color.clear
                                        ],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 50
                                    )
                                )
                                .frame(width: 100, height: 100)
                                .blur(radius: 8)
                            
                            Image(systemName: "shield.fill")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                        }
                        .opacity(isVisible ? 1.0 : 0.0)
                        .scaleEffect(isVisible ? 1.0 : 0.3)
                        .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2), value: isVisible)
                        
                        // Motivational Message
                        VStack(spacing: 16) {
                            Text("STAY STRONG")
                                .font(.custom("DM Sans", size: 24))
                                .fontWeight(.black)
                                .tracking(2)
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                            
                            Text(motivationalMessages[currentMessageIndex])
                                .font(.custom("DM Sans", size: 20))
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                                .padding(.horizontal, 32)
                        }
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.5), value: currentMessageIndex)
                        .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.4), value: isVisible)
                        
                        // Breathing Guide
                        VStack(spacing: 12) {
                            Text("Take a deep breath")
                                .font(.custom("DM Sans", size: 16))
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.8))
                                .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                            
                            ZStack {
                                Circle()
                                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                                    .frame(width: 60, height: 60)
                                
                                Circle()
                                    .fill(Color.cyan.opacity(0.6))
                                    .frame(width: 40, height: 40)
                                    .scaleEffect(isVisible ? 1.2 : 0.8)
                                    .animation(
                                        .easeInOut(duration: 4.0)
                                        .repeatForever(autoreverses: true),
                                        value: isVisible
                                    )
                            }
                        }
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.6), value: isVisible)
                    }
                    
                    Spacer()
                    
                    // Back to Safety Button
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        dismiss()
                    }) {
                        Text("Back to Safety")
                            .font(.custom("DM Sans", size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 6)
                            )
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 32)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .offset(y: isVisible ? 0 : 50)
                    .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.8), value: isVisible)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            isVisible = true
            cameraManager.startSession()
            startMessageRotation()
        }
        .onDisappear {
            cameraManager.stopSession()
            messageTimer?.invalidate()
        }
    }
    
    private func startMessageRotation() {
        messageTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentMessageIndex = (currentMessageIndex + 1) % motivationalMessages.count
            }
        }
    }
}

// Camera Manager
class CameraManager: ObservableObject {
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    func startSession() {
        checkCameraPermission()
    }
    
    func stopSession() {
        captureSession?.stopRunning()
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.setupCamera()
                    }
                }
            }
        default:
            break
        }
    }
    
    private func setupCamera() {
        captureSession = AVCaptureSession()
        
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: frontCamera) else {
            return
        }
        
        captureSession?.addInput(input)
        captureSession?.startRunning()
    }
    
    func getPreviewLayer() -> AVCaptureVideoPreviewLayer? {
        guard let captureSession = captureSession else { return nil }
        
        if videoPreviewLayer == nil {
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = .resizeAspectFill
        }
        
        return videoPreviewLayer
    }
}

// Camera Preview UIViewRepresentable
struct CameraPreview: UIViewRepresentable {
    let cameraManager: CameraManager
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        if let previewLayer = cameraManager.getPreviewLayer() {
            previewLayer.frame = view.bounds
            view.layer.addSublayer(previewLayer)
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let previewLayer = cameraManager.getPreviewLayer() {
            previewLayer.frame = uiView.bounds
        }
    }
}

#Preview {
    PanicModeView()
} 