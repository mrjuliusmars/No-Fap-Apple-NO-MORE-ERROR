import SwiftUI

enum Theme {
    static let padding4: CGFloat = 4
    static let padding8: CGFloat = 8
    static let padding12: CGFloat = 12
    static let padding16: CGFloat = 16
    static let padding24: CGFloat = 24
    static let padding32: CGFloat = 32
    static let padding48: CGFloat = 48
    
    // Spacing aliases for compatibility
    static let spacing16: CGFloat = 16
    static let spacing32: CGFloat = 32
    static let spacing48: CGFloat = 48
    
    static let cornerRadius: CGFloat = 24 // More rounded corners
    static let buttonHeight: CGFloat = 56
    
    static let primaryColor = Color.white // White for primary elements
    static let backgroundColor = Color(red: 0.1, green: 0.05, blue: 0.2) // Dark purple base
    static let gradientStart = Color(red: 0.4, green: 0.2, blue: 0.6) // Purple gradient start
    static let gradientEnd = Color(red: 0.1, green: 0.05, blue: 0.2) // Purple gradient end
    static let secondaryBackgroundColor = Color(white: 1.0).opacity(0.1) // Subtle white overlay
    static let textColor = Color.white
    
    // Compatibility aliases for DashboardView
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.8)
    
    // Background gradient for compatibility
    static let backgroundGradient = LinearGradient(
        colors: [
            Color.black,
            Color(red: 0.05, green: 0.05, blue: 0.15),
            Color(red: 0.02, green: 0.02, blue: 0.08),
            Color.black
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Updated fonts
    static let logoFont = Font.system(size: 42, weight: .black, design: .rounded)
    static let welcomeFont = Font.system(size: 48, weight: .bold, design: .default)
    static let titleFont = Font.system(.largeTitle, design: .rounded, weight: .bold)
    static let questionTitleFont = Font.system(.title, design: .rounded, weight: .bold)
    static let headlineFont = Font.system(.title2, design: .rounded, weight: .semibold)
    static let bodyFont = Font.system(.body, design: .rounded)
    
    // Quiz specific
    static let optionNumberSize: CGFloat = 36
    static let optionHeight: CGFloat = 72
}

struct QuizOptionStyle: ButtonStyle {
    let number: Int
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: Theme.padding16) {
            // Circular number
            Circle()
                .fill(Theme.primaryColor)
                .frame(width: Theme.optionNumberSize, height: Theme.optionNumberSize)
                .overlay(
                    Text("\(number)")
                        .font(.system(.body, design: .rounded, weight: .bold))
                        .foregroundColor(Theme.backgroundColor)
                )
            
            configuration.label
                .font(Theme.bodyFont)
                .foregroundColor(Theme.textColor)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: Theme.optionHeight)
        .background(Theme.secondaryBackgroundColor)
        .cornerRadius(Theme.cornerRadius)
        .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .font(.system(.body, weight: .semibold))
            
            Image(systemName: "chevron.right")
                .font(.system(.body, weight: .bold))
        }
        .frame(height: Theme.buttonHeight)
        .padding(.horizontal, Theme.padding32)
        .background(Theme.primaryColor)
        .foregroundColor(Theme.backgroundColor)
        .cornerRadius(Theme.buttonHeight / 2) // Fully rounded
        .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: Theme.buttonHeight)
            .background(Theme.secondaryBackgroundColor)
            .foregroundColor(.white)
            .cornerRadius(Theme.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .stroke(Theme.primaryColor, lineWidth: 1)
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

extension View {
    func primaryButton() -> some View {
        self.buttonStyle(PrimaryButtonStyle())
    }
    
    func secondaryButton() -> some View {
        self.buttonStyle(SecondaryButtonStyle())
    }
    
    func quizOption(number: Int) -> some View {
        self.buttonStyle(QuizOptionStyle(number: number))
    }
    
    func backgroundGradient() -> some View {
        self.background(
            LinearGradient(
                gradient: Gradient(colors: [Theme.gradientStart, Theme.gradientEnd]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
} 