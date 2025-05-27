import SwiftUI

struct ChecklistView: View {
    @Environment(\.dismiss) var dismiss
    @State private var completedTasks: Set<Int> = []
    @State private var hasAnimated = false
    @State private var cardScale: CGFloat = 0.8
    @State private var cardOpacity: Double = 0
    @State private var headerOffset: CGFloat = -50
    @State private var tasksOffset: CGFloat = 30
    @State private var buttonScale: CGFloat = 0.8
    @State private var progressValue: Double = 0
    @State private var confettiTrigger = false
    @State private var pulseScale: CGFloat = 1.0
    
    // Daily tasks for recovery
    let dailyTasks = [
        // External Triggers to Eliminate
        DailyTask(
            id: 0,
            title: "Delete TikTok App",
            description: "Remove apps with frequent sexual content",
            icon: "trash.fill",
            points: 35,
            category: .digital
        ),
        DailyTask(
            id: 1,
            title: "Unfollow Suggestive Accounts",
            description: "Remove sexually suggestive social media follows",
            icon: "person.fill.xmark",
            points: 30,
            category: .digital
        ),
        DailyTask(
            id: 2,
            title: "Clean Instagram Algorithm",
            description: "Mark suggestive content as 'not interested'",
            icon: "eye.slash.fill",
            points: 25,
            category: .digital
        ),
        DailyTask(
            id: 3,
            title: "Install Site Blocker",
            description: "Block pornographic websites completely",
            icon: "shield.fill",
            points: 40,
            category: .digital
        ),
        DailyTask(
            id: 4,
            title: "Remove Saved Content",
            description: "Delete all adult content from devices",
            icon: "folder.fill.badge.minus",
            points: 35,
            category: .digital
        ),
        DailyTask(
            id: 5,
            title: "No Late Night Browsing",
            description: "Avoid internet browsing alone after 10pm",
            icon: "moon.fill",
            points: 25,
            category: .digital
        ),
        DailyTask(
            id: 6,
            title: "Remove Devices from Bedroom",
            description: "Keep phones/tablets out of bedroom at night",
            icon: "bed.double.fill",
            points: 30,
            category: .physical
        ),
        DailyTask(
            id: 7,
            title: "Disable Incognito Mode",
            description: "Remove private browsing capability",
            icon: "eyeglasses",
            points: 25,
            category: .digital
        ),
        // Internal Behaviors to Build
        DailyTask(
            id: 8,
            title: "Morning Meditation",
            description: "10 minutes mindfulness to build self-awareness",
            icon: "brain.head.profile",
            points: 25,
            category: .mindfulness
        ),
        DailyTask(
            id: 9,
            title: "Exercise Session",
            description: "30+ minutes to release natural endorphins",
            icon: "figure.run.circle.fill",
            points: 30,
            category: .physical
        ),
        DailyTask(
            id: 10,
            title: "Urge Surfing Journal",
            description: "Track triggers and emotional states",
            icon: "book.closed.fill",
            points: 25,
            category: .emotional
        ),
        DailyTask(
            id: 11,
            title: "Social Connection",
            description: "Real conversation to combat isolation",
            icon: "person.2.fill",
            points: 25,
            category: .social
        ),
        DailyTask(
            id: 12,
            title: "Productive Activity",
            description: "Engage in meaningful work or hobby",
            icon: "hammer.fill",
            points: 20,
            category: .growth
        ),
        DailyTask(
            id: 13,
            title: "Cold Shower/Exposure",
            description: "Build mental resilience and discipline",
            icon: "drop.fill",
            points: 30,
            category: .physical
        ),
        DailyTask(
            id: 14,
            title: "Sleep Hygiene",
            description: "8+ hours quality sleep for emotional regulation",
            icon: "moon.zzz.fill",
            points: 25,
            category: .physical
        ),
        DailyTask(
            id: 15,
            title: "Stress Management",
            description: "Practice breathing exercises or yoga",
            icon: "leaf.fill",
            points: 20,
            category: .mindfulness
        )
    ]
    
    private var totalPoints: Int {
        completedTasks.reduce(0) { total, taskId in
            total + (dailyTasks.first { $0.id == taskId }?.points ?? 0)
        }
    }
    
    private var maxPoints: Int {
        dailyTasks.reduce(0) { $0 + $1.points }
    }
    
    private var completionPercentage: Double {
        guard !dailyTasks.isEmpty else { return 0 }
        return Double(completedTasks.count) / Double(dailyTasks.count)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                LinearGradient(
                    colors: [
                        Color(red: 0.04, green: 0.04, blue: 0.14),
                        Color(red: 0.1, green: 0.1, blue: 0.23),
                        Color(red: 0.16, green: 0.1, blue: 0.23)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Content
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 16) {
                        HStack {
                            Button(action: { dismiss() }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(Theme.textPrimary.opacity(0.6))
                            }
                            
                            Spacer()
                            
                            Text("Relapse Prevention")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.textPrimary)
                            
                            Spacer()
                            
                            // Points indicator
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .font(.caption)
                                    .foregroundColor(.yellow)
                                Text("\(totalPoints)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Theme.textPrimary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.yellow.opacity(0.15))
                            )
                        }
                        .padding(.horizontal)
                        
                        // Progress Section
                        VStack(spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Today's Progress")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(Theme.textPrimary.opacity(0.7))
                                    
                                    Text("\(completedTasks.count)/\(dailyTasks.count) completed")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(Theme.textPrimary)
                                }
                                
                                Spacer()
                                
                                // Circular progress
                                ZStack {
                                    Circle()
                                        .stroke(Color.white.opacity(0.1), lineWidth: 6)
                                        .frame(width: 60, height: 60)
                                    
                                    Circle()
                                        .trim(from: 0, to: progressValue)
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    Color(red: 1.0, green: 0.95, blue: 0.8),
                                                    Color(red: 1.0, green: 0.85, blue: 0.4),
                                                    Color(red: 0.9, green: 0.7, blue: 0.2)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                                        )
                                        .frame(width: 60, height: 60)
                                        .rotationEffect(.degrees(-90))
                                        .scaleEffect(pulseScale)
                                    
                                    Text("\(Int(completionPercentage * 100))%")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(Theme.textPrimary)
                                }
                            }
                            
                            // Achievement indicator
                            if completedTasks.count == dailyTasks.count {
                                HStack(spacing: 8) {
                                    Image(systemName: "crown.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(.yellow)
                                    
                                    Text("Perfect Day! All tasks completed!")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.yellow)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.yellow.opacity(0.15))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                                        )
                                )
                                .scaleEffect(hasAnimated ? 1.0 : 0.8)
                                .opacity(hasAnimated ? 1.0 : 0.0)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    Color(red: 1.0, green: 0.85, blue: 0.4).opacity(0.3),
                                                    Color.clear
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                )
                        )
                        .padding(.horizontal)
                        .offset(y: headerOffset)
                        .opacity(cardOpacity)
                    }
                    
                    // Tasks List
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            // External Triggers Section
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "xmark.shield.fill")
                                        .font(.title3)
                                        .foregroundColor(.red.opacity(0.8))
                                    Text("External Triggers to Eliminate")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(Theme.textPrimary)
                                }
                                .padding(.horizontal)
                                
                                ForEach(Array(dailyTasks.filter { $0.id <= 7 }.enumerated()), id: \.element.id) { index, task in
                                    TaskCard(
                                        task: task,
                                        isCompleted: completedTasks.contains(task.id),
                                        onToggle: {
                                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                                if completedTasks.contains(task.id) {
                                                    completedTasks.remove(task.id)
                                                } else {
                                                    completedTasks.insert(task.id)
                                                    
                                                    // Trigger confetti if all tasks completed
                                                    if completedTasks.count == dailyTasks.count {
                                                        confettiTrigger.toggle()
                                                    }
                                                }
                                                updateProgress()
                                            }
                                        }
                                    )
                                    .offset(y: tasksOffset)
                                    .opacity(cardOpacity)
                                    .animation(
                                        .spring(response: 0.8, dampingFraction: 0.8)
                                        .delay(Double(index) * 0.1),
                                        value: hasAnimated
                                    )
                                }
                            }
                            
                            // Internal Behaviors Section
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "heart.fill")
                                        .font(.title3)
                                        .foregroundColor(.green.opacity(0.8))
                                    Text("Internal Behaviors to Build")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(Theme.textPrimary)
                                }
                                .padding(.horizontal)
                                .padding(.top, 8)
                                
                                ForEach(Array(dailyTasks.filter { $0.id >= 8 }.enumerated()), id: \.element.id) { index, task in
                                    TaskCard(
                                        task: task,
                                        isCompleted: completedTasks.contains(task.id),
                                        onToggle: {
                                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                                if completedTasks.contains(task.id) {
                                                    completedTasks.remove(task.id)
                                                } else {
                                                    completedTasks.insert(task.id)
                                                    
                                                    // Trigger confetti if all tasks completed
                                                    if completedTasks.count == dailyTasks.count {
                                                        confettiTrigger.toggle()
                                                    }
                                                }
                                                updateProgress()
                                            }
                                        }
                                    )
                                    .offset(y: tasksOffset)
                                    .opacity(cardOpacity)
                                    .animation(
                                        .spring(response: 0.8, dampingFraction: 0.8)
                                        .delay(Double(index + 8) * 0.1),
                                        value: hasAnimated
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                    
                    Spacer()
                }
                
                // Bottom Action Button
                VStack {
                    Spacer()
                    
                    Button(action: {
                        // Complete check-in action
                        dismiss()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title3)
                            
                            Text("Complete Check-in")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 1.0, green: 0.95, blue: 0.8),
                                    Color(red: 1.0, green: 0.85, blue: 0.4),
                                    Color(red: 0.9, green: 0.7, blue: 0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.23))
                        .cornerRadius(28)
                        .shadow(color: Color.yellow.opacity(0.4), radius: 15, x: 0, y: 8)
                    }
                    .scaleEffect(buttonScale)
                    .opacity(cardOpacity)
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            if !hasAnimated {
                animateEntrance()
                updateProgress()
            }
        }
        .onChange(of: completedTasks) {
            updateProgress()
        }
    }
    
    private func animateEntrance() {
        hasAnimated = true
        
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
            cardScale = 1.0
            cardOpacity = 1.0
            headerOffset = 0
            tasksOffset = 0
            buttonScale = 1.0
        }
    }
    
    private func updateProgress() {
        withAnimation(.easeInOut(duration: 0.8)) {
            progressValue = completionPercentage
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatCount(3, autoreverses: true)) {
            pulseScale = completionPercentage > 0 ? 1.1 : 1.0
        }
    }
}

struct TaskCard: View {
    let task: DailyTask
    let isCompleted: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            taskCardContent
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isCompleted ? 0.98 : 1.0)
        .opacity(isCompleted ? 0.8 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isCompleted)
    }
    
    private var taskCardContent: some View {
        HStack(spacing: 16) {
            taskIcon
            taskContent
            Spacer()
        }
        .padding(20)
        .background(taskBackground)
    }
    
    private var taskIcon: some View {
        ZStack {
            Circle()
                .fill(isCompleted ? completedGradient : uncompletedGradient)
                .frame(width: 50, height: 50)
            
            if isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.23))
            } else {
                Image(systemName: task.icon)
                    .font(.system(size: 20))
                    .foregroundColor(task.category.color)
            }
        }
    }
    
    private var taskContent: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(task.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                    .strikethrough(isCompleted)
                
                Spacer()
                
                pointsBadge
            }
            
            Text(task.description)
                .font(.system(size: 14))
                .foregroundColor(Theme.textPrimary.opacity(isCompleted ? 0.5 : 0.7))
                .multilineTextAlignment(.leading)
            
            categoryBadge
        }
    }
    
    private var pointsBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.caption2)
                .foregroundColor(.yellow)
            Text("\(task.points)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.yellow)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.yellow.opacity(0.15))
        )
    }
    
    private var categoryBadge: some View {
        Text(task.category.rawValue.capitalized)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(task.category.color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(task.category.color.opacity(0.15))
            )
    }
    
    private var completedGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 1.0, green: 0.95, blue: 0.8),
                Color(red: 1.0, green: 0.85, blue: 0.4)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var uncompletedGradient: LinearGradient {
        LinearGradient(
            colors: [Color.white.opacity(0.1)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var taskBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(isCompleted ? Color.green.opacity(0.1) : Color.white.opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isCompleted ? Color.green.opacity(0.3) : Color.white.opacity(0.1),
                        lineWidth: 1
                    )
            )
    }
}

struct DailyTask {
    let id: Int
    let title: String
    let description: String
    let icon: String
    let points: Int
    let category: TaskCategory
}

enum TaskCategory: String, CaseIterable {
    case mindfulness = "mindfulness"
    case physical = "physical"
    case emotional = "emotional"
    case social = "social"
    case growth = "growth"
    case digital = "digital"
    
    var color: Color {
        switch self {
        case .mindfulness: return .purple
        case .physical: return .blue
        case .emotional: return .pink
        case .social: return .green
        case .growth: return .orange
        case .digital: return .red
        }
    }
}

#Preview {
    ChecklistView()
} 