import SwiftUI

struct GrowingTreeView: View {
    let streakDays: Int
    @State private var leafSwing: Double = 0
    @State private var lightShift: Double = 0
    @State private var windOffset: CGFloat = 0
    
    // Tree growth parameters
    private var treeHeight: CGFloat {
        // Grows from 80 to 260 points over 90 days
        let minH: CGFloat = 80
        let maxH: CGFloat = 260
        let progress = Double(streakDays) / 90.0
        let clampedProgress = min(progress, 1.0)
        let height = minH + CGFloat(clampedProgress) * (maxH - minH)
        return height
    }
    private var leafCount: Int {
        // 2 leaves at start, up to 18 at 90 days
        let base = 2.0
        let growth = Double(streakDays) * 0.18
        let count = Int(base + growth)
        return max(2, count)
    }
    
    var body: some View {
        ZStack {
            // Background gradient with shifting light
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.green.opacity(0.18 + 0.12 * lightShift),
                    Color.blue.opacity(0.18 + 0.12 * (1-lightShift))
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                ZStack {
                    // Tree trunk
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.brown)
                        .frame(width: 18, height: treeHeight)
                        .offset(y: treeHeight/2)
                        .shadow(color: .brown.opacity(0.3), radius: 8, x: 0, y: 8)
                    // Tree leaves (animated)
                    ForEach(0..<leafCount, id: \.self) { i in
                        let angle: Double = {
                            let denom = Double(max(leafCount-1,1))
                            return Double(i) / denom * Double.pi
                        }()
                        let radius = treeHeight/2 + 18
                        let x = cos(angle) * radius
                        let y = -sin(angle) * radius
                        let leafOpacity = 0.7 + 0.3 * Double.random(in: 0...1)
                        let rotation = leafSwing * sin(angle)
                        Circle()
                            .fill(Color.green.opacity(leafOpacity))
                            .frame(width: 28, height: 18)
                            .offset(x: x + windOffset, y: y)
                            .rotationEffect(.degrees(rotation))
                            .shadow(color: .green.opacity(0.18), radius: 4, x: 0, y: 2)
                    }
                }
                .frame(height: 320)
                .padding(.bottom, 40)
                Spacer()
                Text("Day \(streakDays)")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .padding(.bottom, 32)
            }
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                leafSwing = 18
            }
            withAnimation(Animation.easeInOut(duration: 6.0).repeatForever(autoreverses: true)) {
                lightShift = 1
            }
            withAnimation(Animation.easeInOut(duration: 3.5).repeatForever(autoreverses: true)) {
                windOffset = 12
            }
        }
    }
} 