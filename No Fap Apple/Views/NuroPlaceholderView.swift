import SwiftUI

struct UnfapPlaceholderView: View {
    let emoji: String
    let color: Color
    var microAnimation: MicroAnimation = .none
    var animate: Bool = false
    
    enum MicroAnimation {
        case none, sitUp, throwTissues, smile, wave
    }
    
    @State private var scale: CGFloat = 1.0
    @State private var yOffset: CGFloat = 0.0
    @State private var rotation: Double = 0.0
    @State private var isSmiling: Bool = false
    @State private var isWaving: Bool = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.2))
                .frame(width: 220, height: 220)
            Text(emoji)
                .font(.system(size: 100))
                .scaleEffect(scale)
                .offset(y: yOffset)
                .rotationEffect(.degrees(rotation))
                .animation(.spring(response: 0.7, dampingFraction: 0.6), value: scale)
                .animation(.easeInOut(duration: 0.5), value: yOffset)
                .animation(.easeInOut(duration: 0.5), value: rotation)
        }
        .onAppear {
            // Arrival pulse
            withAnimation(.easeOut(duration: 0.7)) {
                scale = 1.12
            }
            withAnimation(.easeInOut(duration: 0.7).delay(0.7)) {
                scale = 1.0
            }
            // Micro-animation
            if animate {
                switch microAnimation {
                case .sitUp:
                    withAnimation(.easeInOut(duration: 0.6).delay(0.8)) {
                        yOffset = -20
                    }
                    withAnimation(.easeInOut(duration: 0.6).delay(1.4)) {
                        yOffset = 0
                    }
                case .throwTissues:
                    withAnimation(.easeInOut(duration: 0.5).delay(0.8)) {
                        rotation = -20
                    }
                    withAnimation(.easeInOut(duration: 0.5).delay(1.2)) {
                        rotation = 0
                    }
                case .smile:
                    withAnimation(.easeInOut(duration: 0.5).delay(0.8)) {
                        scale = 1.15
                    }
                    withAnimation(.easeInOut(duration: 0.5).delay(1.2)) {
                        scale = 1.0
                    }
                case .wave:
                    withAnimation(.easeInOut(duration: 0.3).delay(0.8)) {
                        rotation = 20
                    }
                    withAnimation(.easeInOut(duration: 0.3).delay(1.1)) {
                        rotation = -20
                    }
                    withAnimation(.easeInOut(duration: 0.3).delay(1.4)) {
                        rotation = 0
                    }
                case .none:
                    break
                }
            }
        }
    }
} 