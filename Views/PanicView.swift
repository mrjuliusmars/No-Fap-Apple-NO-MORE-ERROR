import SwiftUI

struct PanicView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showBreathingGuide = false
    @State private var showCheckIn = false
    @State private var buttonScale: CGFloat = 1.0
    
    // Sample data - In real app, these would come from your data model
    let currentStreak = 5
    let totalPoints = 1250
    let dailyGoalProgress = 0.7
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 24) {
                header
                ScrollView { mainContent }
                quickActions
            }
        }
        .sheet(isPresented: $showBreathingGuide) {
            BreathingGuideView()
        }
        .sheet(isPresented: $showCheckIn) {
            CheckInView(streak: currentStreak, points: totalPoints)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
    
    private var header: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            Spacer()
            Text("Emergency Help")
                .font(.title2.bold())
                .foregroundColor(.white)
            Spacer()
            Color.clear.frame(width: 28) // Balance layout
        }
        .padding()
    }
    
    private var mainContent: some View {
        VStack(spacing: 32) {
            motivationalMessage
            emergencyActions
        }
    }
    
    private var motivationalMessage: some View {
        VStack(spacing: 16) {
            Text("Stay Strong!")
                .font(.title.bold())
            Text("This urge is temporary.\nYou are stronger than you think.")
                .font(.headline)
                .opacity(0.8)
                .multilineTextAlignment(.center)
        }
        .foregroundColor(.white)
        .padding(.top, 32)
    }
    
    private var emergencyActions: some View {
        VStack(spacing: 20) {
            EmergencyActionButton(
                title: "Breathing Exercise",
                icon: "lungs.fill",
                description: "Calm your mind with guided breathing",
                action: { showBreathingGuide = true }
            )
            
            EmergencyActionButton(
                title: "Take a Cold Shower",
                icon: "shower.fill",
                description: "Reset your body and mind",
                action: {}
            )
            
            EmergencyActionButton(
                title: "Go for a Walk",
                icon: "figure.walk",
                description: "Change your environment",
                action: {}
            )
            
            EmergencyActionButton(
                title: "Call Someone",
                icon: "phone.fill",
                description: "Reach out to a friend or family",
                action: {}
            )
        }
        .padding(.horizontal)
    }
    
    private var quickActions: some View {
        VStack(spacing: 12) {
            Button {
                showCheckIn = true
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Daily Check-in")
                            .font(.headline)
                        Text("🔥 \(currentStreak) day streak")
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 3)
                            .frame(width: 44, height: 44)
                        
                        Circle()
                            .trim(from: 0, to: dailyGoalProgress)
                            .stroke(
                                LinearGradient(
                                    colors: [.purple, .blue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                style: StrokeStyle(lineWidth: 3, lineCap: .round)
                            )
                            .frame(width: 44, height: 44)
                            .rotationEffect(.degrees(-90))
                        
                        Image(systemName: "star.fill")
                            .font(.system(size: 16, weight: .bold))
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        colors: [.purple.opacity(0.3), .blue.opacity(0.3)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
            }
            .buttonStyle(ScaleButtonStyle())
            .foregroundColor(.white)
            
            HStack {
                Label("\(totalPoints) XP", systemImage: "bolt.fill")
                    .font(.footnote.bold())
                    .foregroundColor(.yellow)
                
                Spacer()
                
                Text("Next reward at 1500 XP")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.horizontal)
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct EmergencyActionButton: View {
    let title: String
    let icon: String
    let description: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    Text(description)
                        .font(.subheadline)
                        .opacity(0.7)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .opacity(0.3)
            }
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)
        }
        .foregroundColor(.white)
    }
}

struct BreathingGuideView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var breathingPhase = 0
    @State private var breathingText = "Breathe In"
    @State private var progress: CGFloat = 0
    
    let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 32) {
            header
            Spacer()
            breathingCircle
            Spacer()
            Text("Focus on your breathing")
                .font(.headline)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .onReceive(timer) { _ in updateBreathingPhase() }
    }
    
    private var header: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark").font(.title2)
            }
            Spacer()
            Text("Breathing Exercise").font(.title2.bold())
            Spacer()
        }
        .foregroundColor(.white)
        .padding()
    }
    
    private var breathingCircle: some View {
        Circle()
            .stroke(Color.white.opacity(0.2), lineWidth: 4)
            .frame(width: 200, height: 200)
            .overlay(
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
            )
            .overlay(
                Text(breathingText)
                    .font(.title.bold())
                    .foregroundColor(.white)
            )
    }
    
    private func updateBreathingPhase() {
        withAnimation(.easeInOut(duration: 4)) {
            breathingPhase = (breathingPhase + 1) % 3
            
            switch breathingPhase {
            case 0:
                breathingText = "Breathe In"
                progress = 1.0
            case 1:
                breathingText = "Hold"
                progress = 1.0
            case 2:
                breathingText = "Breathe Out"
                progress = 0.0
            default:
                break
            }
        }
    }
}

struct CheckInView: View {
    @Environment(\.dismiss) private var dismiss
    let streak: Int
    let points: Int
    @State private var selectedMood: Mood?
    @State private var showConfetti = false
    @State private var isCompleting = false
    
    enum Mood: String, CaseIterable {
        case great = "😄"
        case good = "🙂"
        case okay = "😐"
        case challenging = "😣"
        case difficult = "😫"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Streak and Points
                    VStack(spacing: 16) {
                        Text("Current Streak")
                            .font(.title2.bold())
                        
                        HStack(spacing: 20) {
                            VStack {
                                Text("\(streak)")
                                    .font(.system(size: 44, weight: .bold))
                                Text("DAYS")
                                    .font(.caption.bold())
                            }
                            
                            VStack {
                                Text("\(points)")
                                    .font(.system(size: 44, weight: .bold))
                                Text("POINTS")
                                    .font(.caption.bold())
                            }
                        }
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.purple, .blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    }
                    .padding(.top)
                    
                    // Mood Selection
                    VStack(spacing: 16) {
                        Text("How are you feeling today?")
                            .font(.headline)
                        
                        HStack(spacing: 20) {
                            ForEach(Mood.allCases, id: \.self) { mood in
                                Button(action: { selectedMood = mood }) {
                                    Text(mood.rawValue)
                                        .font(.system(size: 32))
                                        .padding()
                                        .background(
                                            Circle()
                                                .fill(selectedMood == mood ? Color.blue.opacity(0.2) : Color.clear)
                                        )
                                }
                            }
                        }
                    }
                    .padding()
                    
                    // Achievements
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Today's Achievements")
                            .font(.headline)
                        
                        AchievementRow(
                            icon: "🎯",
                            title: "Daily Check-in",
                            points: "+50 XP",
                            isCompleted: true
                        )
                        
                        AchievementRow(
                            icon: "🔥",
                            title: "5-Day Streak",
                            points: "+100 XP",
                            isCompleted: true
                        )
                        
                        AchievementRow(
                            icon: "🧘‍♂️",
                            title: "Complete Breathing Exercise",
                            points: "+30 XP",
                            isCompleted: false
                        )
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button(action: {
                        isCompleting = true
                        showConfetti = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            dismiss()
                        }
                    }) {
                        HStack {
                            if isCompleting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .padding(.trailing, 8)
                            }
                            Text(isCompleting ? "Completing..." : "Complete Check-in")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [.purple, .blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    .disabled(isCompleting)
                }
                .padding(.bottom, 20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

struct AchievementRow: View {
    let icon: String
    let title: String
    let points: String
    let isCompleted: Bool
    
    var body: some View {
        HStack {
            Text(icon)
                .font(.title2)
            
            Text(title)
                .font(.subheadline)
            
            Spacer()
            
            if isCompleted {
                Text(points)
                    .font(.subheadline.bold())
                    .foregroundColor(.green)
            } else {
                Text("Incomplete")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
    }
}

#Preview {
    PanicView()
        .preferredColorScheme(.dark)
} 