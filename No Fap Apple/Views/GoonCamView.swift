import SwiftUI
import AVFoundation

struct GoonCamView: View {
    let onDone: () -> Void
    let messages = [
        "Remember why you started.",
        "You are stronger than this urge.",
        "Stay focused on your goals.",
        "This moment will pass.",
        "You are in control.",
        "Every day is a new chance to win.",
        "Progress, not perfection.",
        "You are not alone in this journey.",
        "Small steps add up to big changes.",
        "Your future self will thank you.",
        "Discomfort is temporary, pride is forever.",
        "You are building real strength right now.",
        "Breathe. Reset. Refocus.",
        "You are more than your urges.",
        "Keep your head up, champion.",
        "You are breaking the cycle.",
        "Stay patient and trust the process.",
        "You are making yourself proud.",
        "This is your comeback story."
    ]
    @State private var currentIndex: Int = 0
    @State private var revealedText: String = ""
    @State private var showMessage: Bool = false
    @State private var animateOut: Bool = false
    @State private var typingTimer: Timer? = nil
    var body: some View {
        ZStack {
            CameraView()
                .ignoresSafeArea()
            VStack {
                HStack {
                    Text("GOON CAM")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(Theme.primaryNavy)
                        .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 2)
                        .padding(.leading, 20)
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
                    .padding(.trailing, 18)
                }
                .padding(.top, 40)
                Spacer()
                ZStack {
                    if showMessage {
                        Text(revealedText)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineSpacing(8)
                            .padding(.vertical, 28)
                            .padding(.horizontal, 32)
                            .background(
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .fill(Color.black.opacity(0.35))
                                    .blur(radius: 0.5)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.7), radius: 16, x: 0, y: 4)
                            .opacity(animateOut ? 0 : 1)
                            .offset(x: animateOut ? -UIScreen.main.bounds.width : 0)
                            .animation(.easeInOut(duration: 0.4), value: animateOut)
                    }
                }
                Spacer()
            }
        }
        .onAppear {
            startTypewriter()
        }
        .onDisappear {
            typingTimer?.invalidate()
        }
    }
    
    private func startTypewriter() {
        revealedText = ""
        showMessage = true
        animateOut = false
        let message = messages[currentIndex]
        var charIndex = 0
        typingTimer?.invalidate()
        typingTimer = Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { timer in
            if charIndex < message.count {
                let index = message.index(message.startIndex, offsetBy: charIndex + 1)
                revealedText = String(message[..<index])
                // Haptic feedback per character
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                charIndex += 1
            } else {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    withAnimation {
                        animateOut = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        currentIndex = (currentIndex + 1) % messages.count
                        revealedText = ""
                        animateOut = false
                        startTypewriter()
                    }
                }
            }
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CameraViewController {
        let vc = CameraViewController()
        return vc
    }
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}

class CameraViewController: UIViewController {
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCamera()
    }
    private func setupCamera() {
        captureSession.beginConfiguration()
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: device),
              captureSession.canAddInput(input) else {
            return
        }
        captureSession.addInput(input)
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
        self.previewLayer = previewLayer
        captureSession.commitConfiguration()
        captureSession.startRunning()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
} 