import SwiftUI

struct AuraBallDebugView: View {
    @State private var selectedDays: Int = 0
    @State private var showColorInfo = false
    
    // Clean, minimalist milestone colors
    private let milestoneColors: [(days: Int, color: Color, name: String)] = [
        (0, Color.gray, "Starting Point"),
        (1, Color.cyan, "Initiate"),
        (3, Color.orange, "Aware"),
        (7, Color.purple, "Contender"),
        (14, Color.yellow, "Disciplined"),
        (30, Color.green, "Rewired"),
        (45, Color.red, "Transformed"),
        (60, Color.blue, "Master"),
        (90, Color.pink, "Enlightened"),
        (180, Color.indigo, "Sage"),
        (365, Color.mint, "Transcendent")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.spacing24) {
                    // Current Selection
                    VStack(spacing: Theme.spacing16) {
                        Text("Current Streak: \(selectedDays) days")
                            .font(Theme.titleFont)
                            .foregroundColor(Theme.textPrimary)
                        
                        // Clean Minimalist Orb
                        ZStack {
                            // Outer aura
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            currentColor.opacity(0.4),
                                            currentColor.opacity(0.2),
                                            currentColor.opacity(0.1),
                                            Color.clear
                                        ],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 85
                                    )
                                )
                                .frame(width: 130, height: 130)
                            
                            // Core
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            Color.white,
                                            currentColor.opacity(0.8),
                                            currentColor.opacity(0.6),
                                            Color.clear
                                        ],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 55
                                    )
                                )
                                .frame(width: 120, height: 120)
                            
                            // Subtle glow
                            Circle()
                                .stroke(currentColor.opacity(0.3), lineWidth: 1)
                                .frame(width: 140, height: 140)
                        }
                        .padding(.vertical, Theme.spacing24)
                    }
                    .padding()
                    .background(Theme.surfaceSecondary)
                    .cornerRadius(Theme.cornerRadiusLarge)
                    
                    // Milestone Selector
                    VStack(alignment: .leading, spacing: Theme.spacing16) {
                        Text("Test Milestones")
                            .font(Theme.titleFont)
                            .foregroundColor(Theme.textPrimary)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: Theme.spacing16) {
                            ForEach(milestoneColors, id: \.days) { milestone in
                                Button {
                                    withAnimation(.spring()) {
                                        selectedDays = milestone.days
                                    }
                                } label: {
                                    HStack {
                                        Circle()
                                            .fill(milestone.color)
                                            .frame(width: 24, height: 24)
                                        
                                        VStack(alignment: .leading) {
                                            Text("\(milestone.days) days")
                                                .font(Theme.bodyFont)
                                                .foregroundColor(Theme.textPrimary)
                                            
                                            Text(milestone.name)
                                                .font(Theme.captionFont)
                                                .foregroundColor(Theme.textSecondary)
                                        }
                                        
                                        Spacer()
                                        
                                        if selectedDays == milestone.days {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(milestone.color)
                                        }
                                    }
                                    .padding()
                                    .background(Theme.surfaceTertiary)
                                    .cornerRadius(Theme.cornerRadiusMedium)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Theme.surfaceSecondary)
                    .cornerRadius(Theme.cornerRadiusLarge)
                    
                    // Color Info
                    if showColorInfo {
                        VStack(alignment: .leading, spacing: Theme.spacing16) {
                            Text("Color Information")
                                .font(Theme.titleFont)
                                .foregroundColor(Theme.textPrimary)
                            
                            if let components = getColorComponents(currentColor) {
                                VStack(alignment: .leading, spacing: Theme.spacing8) {
                                    Text("RGB: \(Int(components.r * 255)), \(Int(components.g * 255)), \(Int(components.b * 255))")
                                        .font(Theme.bodyFont)
                                        .foregroundColor(Theme.textSecondary)
                                    
                                    Text("Hex: #\(String(format: "%02X%02X%02X", Int(components.r * 255), Int(components.g * 255), Int(components.b * 255)))")
                                        .font(Theme.bodyFont)
                                        .foregroundColor(Theme.textSecondary)
                                }
                            }
                        }
                        .padding()
                        .background(Theme.surfaceSecondary)
                        .cornerRadius(Theme.cornerRadiusLarge)
                    }
                }
                .padding()
            }
            .background(Theme.backgroundGradient)
            .navigationTitle("Aura Ball Colors")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            showColorInfo.toggle()
                        }
                    } label: {
                        Image(systemName: showColorInfo ? "info.circle.fill" : "info.circle")
                            .foregroundColor(Theme.primaryBlue)
                    }
                }
            }
        }
    }
    
    private var currentColor: Color {
        milestoneColors.first { $0.days >= selectedDays }?.color ?? .gray
    }
    
    private func getColorComponents(_ color: Color) -> (r: Double, g: Double, b: Double, a: Double)? {
        guard let cgColor = color.cgColor else { return nil }
        guard let components = cgColor.components else { return nil }
        
        if components.count >= 3 {
            return (
                r: Double(components[0]),
                g: Double(components[1]),
                b: Double(components[2]),
                a: components.count > 3 ? Double(components[3]) : 1.0
            )
        }
        return nil
    }
}

#Preview {
    AuraBallDebugView()
        .preferredColorScheme(.dark)
} 