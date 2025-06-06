import SwiftUI

struct UserInfoView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    @FocusState private var focusedField: Field?
    @Environment(\.dismiss) private var dismiss
    @State private var isVisible = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var hasInteractedWithName = false
    @State private var hasInteractedWithAge = false
    
    private enum Field {
        case name, age
    }
    
    private var isFormValid: Bool {
        !onboardingState.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && 
        !onboardingState.age.isEmpty &&
        Int(onboardingState.age) != nil &&
        (Int(onboardingState.age) ?? 0) >= 13 &&
        (Int(onboardingState.age) ?? 0) <= 99
    }
    
    private var isNameValid: Bool {
        if !hasInteractedWithName { return true }
        return !onboardingState.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var isAgeValid: Bool {
        if !hasInteractedWithAge || onboardingState.age.isEmpty { return true }
        if let age = Int(onboardingState.age) {
            return age >= 13 && age <= 99
        }
        return false
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Dark gradient background matching the reference image
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
                
                // Subtle floating particles
                ForEach(0..<8, id: \.self) { index in
                    Circle()
                        .fill(Color.white.opacity(0.02))
                        .frame(width: CGFloat.random(in: 1...3))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .opacity(isVisible ? 0.08 : 0.01)
                        .animation(
                            .easeInOut(duration: 8.0)
                            .repeatForever(autoreverses: true),
                            value: isVisible
                        )
                }
                
                VStack(spacing: 0) {
                    // Main content - adjusted positioning to move text up
                    VStack(spacing: 0) {
                        // Title section - positioned higher
                        VStack(spacing: Theme.spacing12) {
                            Text("Finally")
                                .font(.system(size: 42, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .animation(.easeOut(duration: 0.8), value: isVisible)
                            
                            Text("A little more about you")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .animation(.easeOut(duration: 0.8), value: isVisible)
                        }
                        .padding(.top, geometry.safeAreaInsets.top + 50)
                        
                        // Form fields - positioned directly under subtitle
                        VStack(spacing: Theme.spacing20) {
                            // Name field
                            ZStack(alignment: .leading) {
                                HStack(spacing: Theme.spacing16) {
                                    // Input field area
                                    ZStack(alignment: .leading) {
                                        if onboardingState.name.isEmpty {
                                            Text("Name")
                                                .font(.system(size: 18, weight: .medium))
                                                .foregroundColor(.white.opacity(0.6))
                                        }
                                        
                                        TextField("", text: $onboardingState.name)
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundColor(.white)
                                            .textFieldStyle(PlainTextFieldStyle())
                            .focused($focusedField, equals: .name)
                            .submitLabel(.next)
                                            .textInputAutocapitalization(.words)
                                            .autocorrectionDisabled()
                            .onSubmit {
                                focusedField = .age
                            }
                                            .onChange(of: onboardingState.name) {
                                                hasInteractedWithName = true
                                            }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.horizontal, Theme.spacing20)
                                .padding(.vertical, Theme.spacing16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.015))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.white.opacity(0.05), lineWidth: 1)
                                        )
                                )
                            }
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.8), value: isVisible)
                            
                            // Age field
                            ZStack(alignment: .leading) {
                                HStack(spacing: Theme.spacing16) {
                                    // Input field area
                                    ZStack(alignment: .leading) {
                                        if onboardingState.age.isEmpty {
                                            Text("Age")
                                                .font(.system(size: 18, weight: .medium))
                                                .foregroundColor(.white.opacity(0.6))
                                        }
                                        
                                        TextField("", text: $onboardingState.age)
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundColor(.white)
                                            .textFieldStyle(PlainTextFieldStyle())
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .age)
                            .submitLabel(.done)
                            .onSubmit {
                                focusedField = nil
                            }
                                            .onChange(of: onboardingState.age) {
                                                hasInteractedWithAge = true
                                                // Filter non-numeric characters
                                                let filtered = onboardingState.age.filter { "0123456789".contains($0) }
                                                if filtered != onboardingState.age {
                                                    onboardingState.age = filtered
                                                }
                                            }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.horizontal, Theme.spacing20)
                                .padding(.vertical, Theme.spacing16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.015))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.white.opacity(0.05), lineWidth: 1)
                                        )
                                )
                            }
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.8), value: isVisible)
                            
                            // Complete Quiz button - positioned directly under Age field
                            Button(action: {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                
                                focusedField = nil // Dismiss keyboard first
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            onboardingState.navigateTo(.calculating)
                        }
                            }) {
                                Text("Complete Quiz")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, Theme.spacing16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(Color.white.opacity(isFormValid ? 0.9 : 0.5))
                                    )
                            }
                            .disabled(!isFormValid)
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.8), value: isVisible)
                        }
                        .padding(.horizontal, Theme.spacing24)
                        .padding(.top, Theme.spacing32)
                    
                    Spacer()
                }
                    
                    // Bottom safe area spacing
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: geometry.safeAreaInsets.bottom)
                    }
                }
            }
        .navigationBarHidden(true)
        .onAppear {
            // Immediate, smooth fade-in - no jarring delays
            withAnimation(.easeOut(duration: 0.8)) {
                isVisible = true
            }
            
            // Add subtle haptic feedback for better user experience
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            
            // Start with name field focused after animations settle
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                focusedField = .name
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                withAnimation(.easeInOut(duration: 0.3)) {
                    keyboardHeight = keyboardFrame.cgRectValue.height
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                keyboardHeight = 0
            }
        }
    }
}

#Preview {
    NavigationStack {
    UserInfoView()
        .environmentObject(OnboardingState())
    }
} 