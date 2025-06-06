import SwiftUI

enum Theme {
    // MARK: - Typography (DM Sans in increments of 4)
    static let displayFont = Font.custom("DM Sans", size: 48).weight(.bold)      // Welcome headlines
    static let titleLargeFont = Font.custom("DM Sans", size: 32).weight(.bold)   // Question titles
    static let titleFont = Font.custom("DM Sans", size: 28).weight(.semibold)    // Section titles
    static let headlineFont = Font.custom("DM Sans", size: 24).weight(.semibold) // Subheadings
    static let bodyLargeFont = Font.custom("DM Sans", size: 20).weight(.medium)  // Option text
    static let bodyFont = Font.custom("DM Sans", size: 16).weight(.regular)     // Body text
    static let captionFont = Font.custom("DM Sans", size: 12).weight(.medium)   // Small text
    
    // MARK: - Spacing (8pt grid system)
    static let spacing4: CGFloat = 4
    static let spacing8: CGFloat = 8
    static let spacing12: CGFloat = 12
    static let spacing16: CGFloat = 16
    static let spacing20: CGFloat = 20
    static let spacing24: CGFloat = 24
    static let spacing32: CGFloat = 32
    static let spacing40: CGFloat = 40
    static let spacing48: CGFloat = 48
    static let spacing56: CGFloat = 56
    static let spacing64: CGFloat = 64
    
    // MARK: - Layout Constants
    static let buttonHeight: CGFloat = 56
    static let optionHeight: CGFloat = 64
    static let cornerRadiusSmall: CGFloat = 12
    static let cornerRadiusMedium: CGFloat = 16
    static let cornerRadiusLarge: CGFloat = 24
    static let borderWidth: CGFloat = 1.5
    
    // MARK: - Premium Dark Navy Color Palette
    static let primaryNavy = Color(red: 0.05, green: 0.1, blue: 0.2)           // Deep navy primary
    static let primaryNavyDark = Color(red: 0.02, green: 0.05, blue: 0.12)     // Darker navy
    static let primaryBlue = Color(red: 0.1, green: 0.3, blue: 0.6)            // Muted blue for accents
    
    // Premium background colors
    static let surfacePrimary = Color(red: 0.01, green: 0.02, blue: 0.08)      // Very dark navy
    static let surfaceSecondary = Color(red: 0.02, green: 0.05, blue: 0.12)    // Dark navy cards
    static let surfaceTertiary = Color(red: 0.05, green: 0.1, blue: 0.2)       // Medium navy
    
    static let textPrimary = Color.white                                        // Pure white text
    static let textSecondary = Color.white.opacity(0.85)                       // Semi-transparent white
    static let textTertiary = Color.white.opacity(0.6)                         // Subtle white
    
    static let borderLight = Color.white.opacity(0.15)                         // Light borders
    static let borderMedium = Color.white.opacity(0.25)                        // Medium borders
    static let borderAccent = Color.white.opacity(0.4)                         // Accent borders
    
    static let successGreen = Color(red: 0.0, green: 0.8, blue: 0.4)          // Bright green
    static let warningAmber = Color(red: 1.0, green: 0.84, blue: 0.0)         // Golden yellow
    static let errorRed = Color(red: 0.9, green: 0.2, blue: 0.2)              // Error red
    
    // MARK: - Premium Gradient Definitions
    static let primaryGradient = LinearGradient(
        colors: [
            Color(red: 0.08, green: 0.15, blue: 0.28),   // Light navy top
            Color(red: 0.06, green: 0.12, blue: 0.22),   // Slightly deeper navy
            Color(red: 0.05, green: 0.1, blue: 0.2)      // Consistent light navy bottom
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.08, green: 0.15, blue: 0.28),   // Light navy top
            Color(red: 0.06, green: 0.12, blue: 0.22),   // Slightly deeper navy
            Color(red: 0.05, green: 0.1, blue: 0.2)      // Consistent light navy bottom
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.1),
            Color.white.opacity(0.05)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Shadow Styles
    static let shadowSmall = Shadow(
        color: Color.black.opacity(0.3),
        radius: 4,
        x: 0,
        y: 2
    )
    
    static let shadowMedium = Shadow(
        color: Color.black.opacity(0.25),
        radius: 12,
        x: 0,
        y: 6
    )
    
    static let shadowLarge = Shadow(
        color: Color.black.opacity(0.3),
        radius: 20,
        x: 0,
        y: 10
    )
}

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - Premium Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    @State private var isPressed = false
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: Theme.spacing12) {
            configuration.label
                .font(Theme.bodyLargeFont)
            
            Image(systemName: "arrow.right")
                .font(.system(size: 16, weight: .semibold))
        }
        .foregroundColor(.white)
        .frame(height: Theme.buttonHeight)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                .fill(Theme.primaryGradient)
        )
        .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
        .shadow(
            color: Theme.primaryBlue.opacity(0.3),
            radius: configuration.isPressed ? 4 : 8,
            x: 0,
            y: configuration.isPressed ? 2 : 4
        )
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.bodyFont)
            .foregroundColor(Theme.textSecondary)
            .frame(height: Theme.buttonHeight)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                    .fill(Theme.surfaceSecondary)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                            .stroke(Theme.borderLight, lineWidth: Theme.borderWidth)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct QuizOptionStyle: ButtonStyle {
    let number: Int
    let isSelected: Bool
    @State private var isPressed = false
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: Theme.spacing16) {
            // Option number circle
            ZStack {
            Circle()
                    .fill(isSelected ? Theme.successGreen : Theme.surfaceSecondary)
                    .frame(width: 32, height: 32)
                .overlay(
                        Circle()
                            .stroke(
                                isSelected ? Theme.successGreen : Theme.borderMedium,
                                lineWidth: Theme.borderWidth
                            )
                    )
                
                        if isSelected {
                            Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        } else {
                            Text("\(number)")
                        .font(Theme.captionFont)
                        .foregroundColor(Theme.textSecondary)
                        }
                    }
            
            // Option text
            configuration.label
                .font(Theme.bodyLargeFont)
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding(.horizontal, Theme.spacing20)
        .padding(.vertical, Theme.spacing16)
        .background(
            RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                .fill(isSelected ? Theme.surfaceTertiary : Theme.surfaceSecondary)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                        .stroke(
                            isSelected ? Theme.borderAccent : Theme.borderLight,
                            lineWidth: Theme.borderWidth
                        )
                )
        )
        .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct SymptomOptionStyle: ButtonStyle {
    let isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: Theme.spacing16) {
            // Checkbox
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(isSelected ? Theme.primaryBlue : Theme.surfaceSecondary)
                    .frame(width: 24, height: 24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(
                                isSelected ? Theme.primaryBlue : Theme.borderMedium,
                                lineWidth: Theme.borderWidth
                            )
                    )
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            // Symptom text
            configuration.label
                .font(Theme.bodyFont)
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding(.horizontal, Theme.spacing20)
        .padding(.vertical, Theme.spacing16)
        .background(
            RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                .fill(isSelected ? Theme.surfaceTertiary : Theme.surfaceSecondary)
            .overlay(
                    RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                        .stroke(
                            isSelected ? Theme.borderAccent : Theme.borderLight,
                            lineWidth: Theme.borderWidth
                        )
                )
            )
        .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - View Extensions

extension View {
    func primaryButton() -> some View {
        self.buttonStyle(PrimaryButtonStyle())
    }
    
    func secondaryButton() -> some View {
        self.buttonStyle(SecondaryButtonStyle())
    }
    
    func quizOption(number: Int, isSelected: Bool = false) -> some View {
        self.buttonStyle(QuizOptionStyle(number: number, isSelected: isSelected))
    }
    
    func symptomOption(isSelected: Bool = false) -> some View {
        self.buttonStyle(SymptomOptionStyle(isSelected: isSelected))
    }
    
    func premiumBackground() -> some View {
        self.background(Theme.backgroundGradient)
    }
    
    func cardBackground() -> some View {
        self.background(
            RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                .fill(Theme.surfaceSecondary)
                .shadow(
                    color: Color.black.opacity(0.04),
                    radius: 8,
                    x: 0,
                    y: 4
            )
        )
    }
    
    func premiumShadow(_ style: Shadow = Theme.shadowMedium) -> some View {
        self.shadow(color: style.color, radius: style.radius, x: style.x, y: style.y)
    }
} 