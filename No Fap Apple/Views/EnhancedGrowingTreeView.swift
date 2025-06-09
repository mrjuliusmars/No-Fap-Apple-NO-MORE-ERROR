import SwiftUI

struct EnhancedGrowingTreeView: View {
    let streakDays: Int
    @State private var leafSway: Double = 0
    @State private var sunPosition: CGFloat = 0
    @State private var cloudOffset: CGFloat = 0

    // Tree growth parameters
    private var treeHeight: CGFloat {
        let minH: CGFloat = 100
        let maxH: CGFloat = 320
        let progress = min(Double(streakDays) / 90.0, 1.0)
        return minH + CGFloat(progress) * (maxH - minH)
    }
    private var leafCount: Int {
        return max(3, Int(3 + Double(streakDays) * 0.2))
    }
    private var sunY: CGFloat {
        // Sun rises as streak grows
        let minY: CGFloat = 120
        let maxY: CGFloat = 40
        let progress = min(Double(streakDays) / 90.0, 1.0)
        return minY - CGFloat(progress) * (minY - maxY)
    }

    var body: some View {
        ZStack {
            // Background: sky, sun, clouds, hills
            LinearGradient(colors: [Color.orange, Color.yellow, Color.green.opacity(0.5)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            SunView(y: sunY)
            CloudsView(offset: cloudOffset)
            ParallaxHillsView(streakDays: streakDays)

            // Tree
            VStack {
                Spacer()
                ZStack {
                    TreeTrunkView(height: treeHeight)
                    ForEach(0..<leafCount, id: \.self) { i in
                        AnimatedLeafView(index: i, count: leafCount, sway: leafSway, treeHeight: treeHeight)
                    }
                    if streakDays % 30 == 0 && streakDays > 0 {
                        SparkleView()
                    }
                }
                .frame(height: 400)
                .padding(.bottom, 40)
                Spacer()
                GlassCard {
                    VStack {
                        Text("Your life tree grows with your streak!")
                            .font(.title2.bold())
                        Text("Day \(streakDays) • Keep going, you're thriving 🌱")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                leafSway = 18
            }
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                cloudOffset = 200
            }
        }
    }
}

// MARK: - SunView
struct SunView: View {
    var y: CGFloat
    var body: some View {
        Circle()
            .fill(LinearGradient(colors: [Color.yellow, Color.orange.opacity(0.7)], startPoint: .top, endPoint: .bottom))
            .frame(width: 120, height: 120)
            .blur(radius: 8)
            .offset(y: y - 80)
            .shadow(color: .yellow.opacity(0.3), radius: 40, x: 0, y: 0)
    }
}

// MARK: - CloudsView
struct CloudsView: View {
    var offset: CGFloat
    var body: some View {
        HStack(spacing: 60) {
            CloudShape().fill(Color.white.opacity(0.7)).frame(width: 80, height: 40)
            CloudShape().fill(Color.white.opacity(0.5)).frame(width: 60, height: 30)
        }
        .offset(x: offset - 100, y: -120)
        .animation(.linear(duration: 20).repeatForever(autoreverses: false), value: offset)
    }
}

struct CloudShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: CGRect(x: rect.minX, y: rect.midY-10, width: rect.width*0.6, height: rect.height*0.6))
        path.addEllipse(in: CGRect(x: rect.midX-10, y: rect.midY-20, width: rect.width*0.5, height: rect.height*0.5))
        path.addEllipse(in: CGRect(x: rect.midX+10, y: rect.midY, width: rect.width*0.4, height: rect.height*0.4))
        return path
    }
}

// MARK: - ParallaxHillsView
struct ParallaxHillsView: View {
    let streakDays: Int
    var body: some View {
        ZStack {
            HillShape(offset: 0.2).fill(Color.green.opacity(0.25)).offset(y: 120)
            HillShape(offset: 0.5).fill(Color.green.opacity(0.35)).offset(y: 160)
            HillShape(offset: 0.8).fill(Color.green.opacity(0.45)).offset(y: 200)
        }
    }
}

struct HillShape: Shape {
    var offset: CGFloat
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let height = rect.height * (0.3 + 0.2 * offset)
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addCurve(to: CGPoint(x: rect.maxX, y: rect.maxY),
                      control1: CGPoint(x: rect.width * 0.3, y: rect.maxY - height),
                      control2: CGPoint(x: rect.width * 0.7, y: rect.maxY - height * 0.8))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - TreeTrunkView
struct TreeTrunkView: View {
    let height: CGFloat
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(LinearGradient(colors: [Color.brown, Color.brown.opacity(0.7)], startPoint: .top, endPoint: .bottom))
            .frame(width: 24, height: height)
            .shadow(color: .brown.opacity(0.3), radius: 8, x: 0, y: 8)
    }
}

// MARK: - AnimatedLeafView
struct AnimatedLeafView: View {
    let index: Int
    let count: Int
    let sway: Double
    let treeHeight: CGFloat
    var body: some View {
        let angle: Double = {
            let denom = Double(max(count-1,1))
            return Double(index) / denom * Double.pi
        }()
        let radius = treeHeight/2 + 28
        let x = cos(angle) * radius
        let y = -sin(angle) * radius
        let leafColor = Color.green.opacity(0.7 + 0.3 * Double(index % 3) / 2)
        let rotation = sway * sin(angle)
        Ellipse()
            .fill(leafColor)
            .frame(width: 38, height: 22)
            .offset(x: x, y: y)
            .rotationEffect(.degrees(rotation))
            .shadow(color: .green.opacity(0.18), radius: 4, x: 0, y: 2)
    }
}

// MARK: - SparkleView
struct SparkleView: View {
    @State private var sparkle = false
    var body: some View {
        ZStack {
            ForEach(0..<12, id: \.self) { i in
                Circle()
                    .fill(Color.yellow.opacity(0.7))
                    .frame(width: sparkle ? 8 : 2, height: sparkle ? 8 : 2)
                    .offset(x: CGFloat(cos(Double(i)/12*2*Double.pi))*60, y: CGFloat(sin(Double(i)/12*2*Double.pi))*60)
                    .opacity(sparkle ? 1 : 0.3)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                sparkle.toggle()
            }
        }
    }
}

// MARK: - GlassCard
struct GlassCard<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        content
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(24)
            .shadow(radius: 12)
            .padding(.horizontal, 24)
    }
} 