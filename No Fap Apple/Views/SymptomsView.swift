import SwiftUI

struct SymptomsView: View {
    let categoryId: Int
    @EnvironmentObject var onboardingState: OnboardingState
    @State private var isShowingInfo = false
    @State private var isVisible = false
    @State private var particlesAnimating = false
    
    private var category: SymptomCategory {
        symptomCategories[categoryId - 1]
    }
    
    private var selectedCount: Int {
        category.symptoms.filter { onboardingState.selectedSymptoms.contains($0) }.count
    }
    
    private var percentageSelected: Double {
        Double(selectedCount) / Double(category.symptoms.count) * 100.0
    }
    
    private var categoryIcon: String {
        switch categoryId {
        case 1: return "brain.head.profile"
        case 2: return "figure.walk.motion"
        case 3: return "person.2.fill"
        default: return "questionmark.circle"
        }
    }
    
    private var categoryColor: Color {
        switch categoryId {
        case 1: return Color.cyan
        case 2: return Color.green
        case 3: return Color.orange
        default: return Color.blue
        }
    }
    
    private var categoryDescription: String {
        switch categoryId {
        case 1: return "Mental symptoms can affect your cognitive function, emotional well-being, and daily performance."
        case 2: return "Physical symptoms manifest in your body and can impact your health and daily activities."
        case 3: return "Social symptoms affect your relationships, emotional connections, and ability to interact with others."
        default: return ""
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
        ZStack {
                // Premium gradient background with enhanced depth
                LinearGradient(
                    colors: [
                        Color(red: 0.08, green: 0.15, blue: 0.28),   // Light navy top
                        Color(red: 0.06, green: 0.12, blue: 0.22),   // Slightly deeper navy
                        Color(red: 0.05, green: 0.1, blue: 0.2)      // Consistent light navy bottom
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            
                // Enhanced floating particles with premium glow
                ForEach(0..<15, id: \.self) { index in
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.white.opacity(0.08),
                                    Color.cyan.opacity(0.04),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 2
                            )
                        )
                        .frame(width: CGFloat.random(in: 2...4))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .animation(
                            .easeInOut(duration: Double.random(in: 10...20))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...8)),
                            value: particlesAnimating
                        )
                        .opacity(particlesAnimating ? Double.random(in: 0.3...0.8) : 0.1)
                        .blur(radius: 1)
                }
                
            VStack(spacing: 0) {
                    // Clean top branding
                    VStack(spacing: Theme.spacing8) {
                        HStack {
                            Text("UNFAP")
                                .font(.system(size: 24, weight: .black, design: .rounded))
                                .tracking(1)
                                .foregroundColor(.white)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.1), value: isVisible)
                            
                            Spacer()
                        }
                        .padding(.horizontal, Theme.spacing24)
                        .padding(.top, 15)
                        
                        // Enhanced progress indicators
                        HStack(spacing: Theme.spacing12) {
                            ForEach(1...3, id: \.self) { id in
                                Circle()
                                    .fill(
                                        id == categoryId ? 
                                        LinearGradient(
                                            colors: [Color.white, Color.white.opacity(0.9)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ) :
                                        LinearGradient(
                                            colors: [Color.white.opacity(0.3), Color.white.opacity(0.2)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 8, height: 8)
                                    .scaleEffect(id == categoryId ? 1.2 : 1.0)
                                    .shadow(
                                        color: id == categoryId ? Color.white.opacity(0.3) : .clear,
                                        radius: id == categoryId ? 6 : 0,
                                        x: 0,
                                        y: id == categoryId ? 3 : 0
                                    )
                                    .animation(.easeInOut(duration: 0.3), value: categoryId)
                            }
                        }
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.6).delay(0.3), value: isVisible)
                    }
                    
                    // Main content
                    VStack(spacing: Theme.spacing12) {
                        // Category header
                        VStack(spacing: Theme.spacing8) {
                            HStack(spacing: Theme.spacing16) {
                                // Category icon
                                ZStack {
                                    // Glow background
                                    Circle()
                                        .fill(categoryColor.opacity(0.25))
                                        .frame(width: 48, height: 48)
                                        .blur(radius: 8)
                                    
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [categoryColor, categoryColor.opacity(0.8)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 40, height: 40)
                                        .shadow(
                                            color: categoryColor.opacity(0.3),
                                            radius: 8,
                                            x: 0,
                                            y: 4
                                        )
                                    
                                    Image(systemName: categoryIcon)
                                        .font(.system(size: 24, weight: .semibold))
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                        }
                                .scaleEffect(isVisible ? 1.0 : 0.8)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: isVisible)
                                
                                VStack(alignment: .leading, spacing: Theme.spacing4) {
                                    Text(category.title)
                                        .font(.system(size: 22, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                                    
                                    Button(action: { 
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            isShowingInfo.toggle() 
                    }
                                    }) {
                                        HStack(spacing: Theme.spacing4) {
                                            Text("Learn more")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(categoryColor)
                                            
                                            Image(systemName: isShowingInfo ? "chevron.up" : "chevron.down")
                                                .font(.system(size: 12, weight: .semibold))
                                                .foregroundColor(categoryColor)
                                        }
                                    }
                                }
                                
                                Spacer()
                            }
                            .opacity(isVisible ? 1.0 : 0.0)
                            .offset(y: isVisible ? 0 : 20)
                            .animation(.easeOut(duration: 0.6).delay(0.7), value: isVisible)
                            
                            // Description
                            if isShowingInfo {
                                Text(categoryDescription)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white.opacity(0.7))
                                    .lineSpacing(4)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                        .padding(.horizontal, Theme.spacing24)
                        .padding(.top, Theme.spacing24)
                
                // Selection progress
                        VStack(spacing: Theme.spacing12) {
                    // Progress bar
                            GeometryReader { progressGeometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                        .fill(Color.white.opacity(0.2))
                                        .frame(height: 4)
                                        .cornerRadius(2)
                            
                            Rectangle()
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.white, Color.white.opacity(0.8)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(width: progressGeometry.size.width * CGFloat(percentageSelected) / 100, height: 4)
                                        .cornerRadius(2)
                                        .animation(.easeInOut(duration: 0.3), value: percentageSelected)
                        }
                    }
                            .frame(height: 4)
                    
                            // Progress text
                            Text("\(selectedCount) of \(category.symptoms.count) symptoms selected")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                }
                        .padding(.horizontal, Theme.spacing24)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.6).delay(0.9), value: isVisible)
                
                // Symptoms list
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: Theme.spacing16) {
                                ForEach(Array(category.symptoms.enumerated()), id: \.offset) { index, symptom in
                                    let isSelected = onboardingState.selectedSymptoms.contains(symptom)
                                    
                            Button(action: {
                                        // Haptic feedback
                                        let impact = UIImpactFeedbackGenerator(style: .medium)
                                        impact.impactOccurred()
                                        
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    if onboardingState.selectedSymptoms.contains(symptom) {
                                        onboardingState.selectedSymptoms.remove(symptom)
                                    } else {
                                        onboardingState.selectedSymptoms.insert(symptom)
                                    }
                                }
                            }) {
                                        PremiumSymptomCard(
                                            symptom: symptom,
                                            isSelected: isSelected,
                                            categoryColor: categoryColor
                                        )
                                    }
                                    .scaleEffect(isSelected ? 1.02 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: isSelected)
                                    .opacity(isVisible ? 1.0 : 0.0)
                                    .offset(y: isVisible ? 0 : 30)
                                    .animation(.easeOut(duration: 0.5).delay(1.1 + Double(index) * 0.05), value: isVisible)
                                }
                                
                                // Bottom spacing for navigation buttons
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(height: 120)
                            }
                            .padding(.horizontal, Theme.spacing24)
                            .padding(.top, Theme.spacing8)
                        }
                    }
                                    
                                    Spacer()
                                    
                    // Fixed bottom navigation
                    VStack(spacing: Theme.spacing16) {
                        HStack(spacing: Theme.spacing16) {
                            // Previous button
                            if categoryId > 1 {
                                Button(action: {
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                    onboardingState.navigateTo(.symptoms(categoryId - 1))
                                }) {
                                    HStack(spacing: Theme.spacing8) {
                                        Image(systemName: "chevron.left")
                                            .font(.system(size: 14, weight: .semibold))
                                        Text("Previous")
                                    }
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white.opacity(0.7))
                                    .frame(height: 48)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 24)
                                            .fill(Color.white.opacity(0.1))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 24)
                                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                                }
                            }
                            
                            // Next/Continue button
                            Button(action: {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                
                                if categoryId == symptomCategories.count {
                                    onboardingState.navigateTo(.educational(1))
                                } else {
                                    onboardingState.navigateTo(.symptoms(categoryId + 1))
                                }
                            }) {
                                HStack(spacing: Theme.spacing8) {
                                    Text(categoryId == symptomCategories.count ? "Continue" : "Next")
                                        .font(.system(size: 18, weight: .bold))
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.system(size: 16, weight: .bold))
                                }
                                .foregroundColor(.black)
                                .frame(height: 48)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color.white,
                                                    Color.white.opacity(0.95),
                                                    Color.white.opacity(0.9)
                                                ],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
                                )
                            }
                        }
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : 30)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.4), value: isVisible)
                    }
                    .padding(.horizontal, Theme.spacing24)
                    .padding(.bottom, geometry.safeAreaInsets.bottom + Theme.spacing16)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            isVisible = true
            particlesAnimating = true
        }
    }
}

struct PremiumSymptomCard: View {
    let symptom: String
    let isSelected: Bool
    let categoryColor: Color
    @State private var glowAnimation = false
    
    var body: some View {
        HStack(spacing: Theme.spacing12) {
            // Premium selection indicator
            ZStack {
                // Glow background for selected state
                if isSelected {
                    Circle()
                        .fill(categoryColor.opacity(glowAnimation ? 0.3 : 0.2))
                        .frame(width: 32, height: 32)
                        .blur(radius: 6)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: glowAnimation)
                }
                
                Circle()
                    .fill(
                        isSelected ? 
                        LinearGradient(
                            colors: [categoryColor, categoryColor.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.12),
                                Color.white.opacity(0.06)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle()
                            .stroke(
                                isSelected ? 
                                categoryColor.opacity(0.4) : 
                                Color.white.opacity(0.15),
                                lineWidth: isSelected ? 1.5 : 0.5
                            )
                    )
                    .shadow(
                        color: isSelected ? categoryColor.opacity(0.3) : .black.opacity(0.1),
                        radius: isSelected ? 6 : 3,
                        x: 0,
                        y: isSelected ? 3 : 2
                    )
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                }
            }
            
            // Premium symptom text
            Text(symptom)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .padding(.horizontal, Theme.spacing16)
        .padding(.vertical, Theme.spacing12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [
                            isSelected ? 
                            Color.white.opacity(0.08) : 
                            Color.white.opacity(0.04),
                            isSelected ? 
                            Color.white.opacity(0.04) : 
                            Color.white.opacity(0.02)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isSelected ? 
                            categoryColor.opacity(0.4) : 
                            Color.white.opacity(0.15),
                            lineWidth: isSelected ? 1.5 : 0.5
                        )
                )
                .shadow(
                    color: isSelected ? categoryColor.opacity(0.1) : .black.opacity(0.05),
                    radius: isSelected ? 8 : 4,
                    x: 0,
                    y: isSelected ? 4 : 2
                )
        )
        .onAppear {
            glowAnimation = true
        }
    }
}

#Preview {
    SymptomsView(categoryId: 1)
        .environmentObject(OnboardingState())
} 