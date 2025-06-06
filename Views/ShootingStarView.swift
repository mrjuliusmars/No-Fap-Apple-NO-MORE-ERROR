import SwiftUI

struct StarsBackground: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Static stars
                ForEach(0..<100) { _ in
                    Circle()
                        .fill(Color.white)
                        .frame(width: CGFloat.random(in: 1...3),
                               height: CGFloat.random(in: 1...3))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .opacity(Double.random(in: 0.2...0.7))
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct ShootingStar: View {
    let startPoint: CGPoint
    let angle: Double
    let duration: Double
    let delay: Double
    let length: CGFloat
    
    @State private var opacity: Double = 0
    @State private var position: CGPoint
    
    init(startPoint: CGPoint, angle: Double, duration: Double = 1.0, delay: Double = 0, length: CGFloat = 50) {
        self.startPoint = startPoint
        self.angle = angle
        self.duration = duration
        self.delay = delay
        self.length = length
        self._position = State(initialValue: startPoint)
    }
    
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: length, y: 0))
        }
        .stroke(
            LinearGradient(
                colors: [.white.opacity(0), .white, .white.opacity(0)],
                startPoint: .leading,
                endPoint: .trailing
            ),
            lineWidth: 2
        )
        .rotationEffect(.degrees(angle))
        .position(position)
        .opacity(opacity)
        .onAppear {
            let distance: CGFloat = 500
            let endX = startPoint.x + distance * cos(angle * .pi / 180)
            let endY = startPoint.y + distance * sin(angle * .pi / 180)
            
            withAnimation(
                Animation
                    .easeOut(duration: duration)
                    .delay(delay)
                    .repeatForever(autoreverses: false)
            ) {
                position = CGPoint(x: endX, y: endY)
                opacity = 1
            }
            
            // Reset position after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + delay + duration) {
                position = startPoint
                opacity = 0
            }
        }
    }
}

struct AnimatedStarsBackground: View {
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var shootingStars: [UUID: (CGPoint, Double, Double, Double)] = [:]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Static stars
                ForEach(0..<100) { _ in
                    Circle()
                        .fill(Color.white)
                        .frame(width: CGFloat.random(in: 1...3),
                               height: CGFloat.random(in: 1...3))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .opacity(Double.random(in: 0.2...0.7))
                }
                
                // Shooting stars
                ForEach(Array(shootingStars.keys), id: \.self) { id in
                    if let (startPoint, angle, duration, delay) = shootingStars[id] {
                        ShootingStar(
                            startPoint: startPoint,
                            angle: angle,
                            duration: duration,
                            delay: delay
                        )
                    }
                }
            }
            .onReceive(timer) { _ in
                if Double.random(in: 0...1) < 0.1 { // 10% chance each 0.1s
                    addShootingStar(in: geometry)
                }
            }
        }
        .ignoresSafeArea()
    }
    
    private func addShootingStar(in geometry: GeometryProxy) {
        let id = UUID()
        let startX = CGFloat.random(in: -50...geometry.size.width)
        let startY = CGFloat.random(in: -50...200)
        let angle = Double.random(in: 15...45)
        let duration = Double.random(in: 0.8...1.2)
        let delay = Double.random(in: 0...0.5)
        
        shootingStars[id] = (CGPoint(x: startX, y: startY), angle, duration, delay)
        
        // Remove shooting star after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + duration + delay + 0.1) {
            shootingStars.removeValue(forKey: id)
        }
    }
} 