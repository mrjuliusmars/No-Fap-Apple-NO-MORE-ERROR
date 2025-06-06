import SwiftUI

struct ChecklistView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var externalCheckedItems: Set<Int> = []
    @State private var internalCheckedItems: Set<Int> = []
    
    let externalTriggers = [
        ChecklistItem(
            title: "Delete TikTok",
            description: "Remove app with frequent sexual content",
            priority: .high
        ),
        ChecklistItem(
            title: "Unfollow triggering accounts",
            description: "Women posting sexually suggestive content",
            priority: .high
        ),
        ChecklistItem(
            title: "Unfollow NSFW meme pages",
            description: "Block pages posting adult jokes/content",
            priority: .high
        ),
        ChecklistItem(
            title: "Retrain Instagram algorithm",
            description: "Press 'not interested' on tempting reels",
            priority: .high
        ),
        ChecklistItem(
            title: "Install website blocker",
            description: "Block pornographic websites completely",
            priority: .high
        ),
        ChecklistItem(
            title: "Disable incognito browsing",
            description: "Remove or restrict private browsing",
            priority: .high
        ),
        ChecklistItem(
            title: "Delete saved adult content",
            description: "Camera roll, downloads, bookmarks",
            priority: .high
        ),
        ChecklistItem(
            title: "Avoid late night browsing",
            description: "No internet alone after 10 PM",
            priority: .medium
        ),
        ChecklistItem(
            title: "Remove devices from bedroom",
            description: "No phones/tablets in bed at night",
            priority: .medium
        )
    ]
    
    let internalHabits = [
        ChecklistItem(
            title: "Start daily journaling",
            description: "Track urges, triggers, and mood daily",
            priority: .high
        ),
        ChecklistItem(
            title: "Write your 'Why I Quit' statement",
            description: "Clear written reminder of your motivation",
            priority: .high
        ),
        ChecklistItem(
            title: "Find accountability partner",
            description: "Friend, coach, or support group",
            priority: .high
        ),
        ChecklistItem(
            title: "Practice mindfulness meditation",
            description: "5-10 minutes daily during cravings",
            priority: .medium
        ),
        ChecklistItem(
            title: "Schedule regular workouts",
            description: "Physical activity 3-5x per week",
            priority: .high
        ),
        ChecklistItem(
            title: "Replace screen time with learning",
            description: "Books, podcasts, educational content",
            priority: .medium
        ),
        ChecklistItem(
            title: "Develop screen-free sleep routine",
            description: "No phones in bed, better sleep hygiene",
            priority: .medium
        ),
        ChecklistItem(
            title: "Practice gratitude journaling",
            description: "3 things you're grateful for daily",
            priority: .low
        ),
        ChecklistItem(
            title: "Create relapse reflection template",
            description: "Structured analysis for any slip-ups",
            priority: .medium
        ),
        ChecklistItem(
            title: "Keep trigger pattern log",
            description: "Analyze what leads to urges",
            priority: .medium
        ),
        ChecklistItem(
            title: "Replace morning screen time",
            description: "Cold showers, walks, exercise instead",
            priority: .medium
        ),
        ChecklistItem(
            title: "Set 7-day milestone rewards",
            description: "Celebrate progress with healthy rewards",
            priority: .low
        ),
        ChecklistItem(
            title: "Weekly progress review",
            description: "Reflect on wins and areas to improve",
            priority: .medium
        )
    ]
    
    private var externalProgress: Double {
        guard !externalTriggers.isEmpty else { return 0 }
        return Double(externalCheckedItems.count) / Double(externalTriggers.count)
    }
    
    private var internalProgress: Double {
        guard !internalHabits.isEmpty else { return 0 }
        return Double(internalCheckedItems.count) / Double(internalHabits.count)
    }
    
    private var overallProgress: Double {
        let totalItems = externalTriggers.count + internalHabits.count
        let completedItems = externalCheckedItems.count + internalCheckedItems.count
        guard totalItems > 0 else { return 0 }
        return Double(completedItems) / Double(totalItems)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Premium Header
                HStack {
                    Button("Close") {
                        dismiss()
                    }
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    VStack(spacing: 2) {
                        Text("Temptation Elimination")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("CHECKLIST")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.purple.opacity(0.8))
                            .tracking(1.2)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 2) {
                        Text("\(Int(overallProgress * 100))%")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.purple)
                        
                        Text("DONE")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white.opacity(0.6))
                            .tracking(0.8)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 32)
                
                // Premium Progress Overview
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Overall Progress")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Complete these steps to eliminate triggers and build resilience")
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.7))
                                .lineLimit(2)
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 4) {
                            Text("\(externalCheckedItems.count + internalCheckedItems.count)")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("/ \(externalTriggers.count + internalHabits.count)")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    
                    // Premium Progress Bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.08))
                                .frame(height: 12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.purple,
                                            Color.blue.opacity(0.8),
                                            Color.purple.opacity(0.8)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * overallProgress, height: 12)
                                .shadow(color: .purple.opacity(0.4), radius: 6, x: 0, y: 3)
                                .overlay(
                                    // Shimmer effect
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color.clear,
                                                    Color.white.opacity(0.3),
                                                    Color.clear
                                                ],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(width: geometry.size.width * overallProgress, height: 12)
                                )
                        }
                    }
                    .frame(height: 12)
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color.purple.opacity(0.3),
                                            Color.purple.opacity(0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                
                // Content
                ScrollView {
                    VStack(spacing: 32) {
                        // External Triggers Section
                        ChecklistSection(
                            title: "External Triggers to Eliminate",
                            subtitle: "Remove outside sources of temptation",
                            icon: "shield.fill",
                            items: externalTriggers,
                            checkedItems: $externalCheckedItems,
                            progress: externalProgress,
                            accentColor: .red
                        )
                        
                        // Internal Habits Section
                        ChecklistSection(
                            title: "Internal Habits to Build",
                            subtitle: "Develop resilience and healthy patterns",
                            icon: "brain.head.profile",
                            items: internalHabits,
                            checkedItems: $internalCheckedItems,
                            progress: internalProgress,
                            accentColor: .green
                        )
                        
                        // Premium Motivational Footer
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Color.yellow.opacity(0.2))
                                    .frame(width: 60, height: 60)
                                
                                Image(systemName: "star.fill")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.yellow)
                                    .shadow(color: .yellow.opacity(0.5), radius: 8, x: 0, y: 4)
                            }
                            
                            VStack(spacing: 8) {
                                Text("Every step makes you stronger")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                                Text("Small changes compound into massive transformation")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white.opacity(0.8))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                            }
                        }
                        .padding(.vertical, 32)
                        .padding(.horizontal, 24)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.purple.opacity(0.15),
                                            Color.purple.opacity(0.08)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    Color.purple.opacity(0.4),
                                                    Color.purple.opacity(0.2)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1.5
                                        )
                                )
                        )
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                    }
                }
            }
            .background(
                LinearGradient(
                    colors: [
                        Color.purple.opacity(0.3),
                        Color.purple.opacity(0.1),
                        Color.black
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
        }
        .navigationBarHidden(true)
    }
}

struct ChecklistSection: View {
    let title: String
    let subtitle: String
    let icon: String
    let items: [ChecklistItem]
    @Binding var checkedItems: Set<Int>
    let progress: Double
    let accentColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Compact Section Header
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(accentColor.opacity(0.15))
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(accentColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(subtitle)
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(accentColor)
                }
                
                // Compact Progress Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 4)
                        
                        RoundedRectangle(cornerRadius: 3)
                            .fill(accentColor)
                            .frame(width: geometry.size.width * progress, height: 4)
                    }
                }
                .frame(height: 4)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.04))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.purple.opacity(0.15), lineWidth: 1)
                    )
            )
            
            // Items List
            VStack(spacing: 12) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    ChecklistItemRow(
                        item: item,
                        isChecked: checkedItems.contains(index),
                        onToggle: {
                            if checkedItems.contains(index) {
                                checkedItems.remove(index)
                            } else {
                                checkedItems.insert(index)
                            }
                        }
                    )
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

struct ChecklistItemRow: View {
    let item: ChecklistItem
    let isChecked: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 16) {
                // Checkbox
                ZStack {
                    Circle()
                        .fill(isChecked ? Color.purple : Color.white.opacity(0.08))
                        .frame(width: 28, height: 28)
                        .overlay(
                            Circle()
                                .stroke(Color.purple.opacity(0.4), lineWidth: 1.5)
                        )
                    
                    if isChecked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                // Content
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(item.title)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(isChecked ? .white.opacity(0.7) : .white)
                            .strikethrough(isChecked)
                        
                        Spacer()
                    }
                    
                    Text(item.description)
                        .font(.system(size: 15))
                        .foregroundColor(isChecked ? .white.opacity(0.5) : .white.opacity(0.8))
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                }
                
                Spacer()
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(isChecked ? 0.04 : 0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.purple.opacity(isChecked ? 0.4 : 0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ChecklistItem {
    let title: String
    let description: String
    let priority: Priority
    
    enum Priority {
        case high, medium, low
    }
}

#Preview {
    ChecklistView()
        .preferredColorScheme(.dark)
} 
