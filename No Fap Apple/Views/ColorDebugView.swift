import SwiftUI

struct ColorDebugView: View {
    @State private var selectedColorCategory: ColorCategory = .primary
    
    enum ColorCategory: String, CaseIterable {
        case primary = "Primary Colors"
        case surfaces = "Surface Colors"
        case text = "Text Colors"
        case borders = "Border Colors"
        case status = "Status Colors"
        case gradients = "Gradients"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.spacing24) {
                    // Category Picker
                    VStack(alignment: .leading, spacing: Theme.spacing12) {
                        Text("Color Categories")
                            .font(Theme.titleFont)
                            .foregroundColor(Theme.textPrimary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: Theme.spacing12) {
                                ForEach(ColorCategory.allCases, id: \.self) { category in
                                    Button(category.rawValue) {
                                        selectedColorCategory = category
                                    }
                                    .padding(.horizontal, Theme.spacing16)
                                    .padding(.vertical, Theme.spacing8)
                                    .background(
                                        RoundedRectangle(cornerRadius: Theme.cornerRadiusSmall)
                                            .fill(selectedColorCategory == category ? Theme.primaryBlue : Theme.surfaceSecondary)
                                    )
                                    .foregroundColor(selectedColorCategory == category ? .white : Theme.textSecondary)
                                    .font(Theme.bodyFont)
                                }
                            }
                            .padding(.horizontal, Theme.spacing20)
                        }
                    }
                    
                    // Color Display
                    LazyVStack(spacing: Theme.spacing16) {
                        switch selectedColorCategory {
                        case .primary:
                            primaryColorsSection()
                        case .surfaces:
                            surfaceColorsSection()
                        case .text:
                            textColorsSection()
                        case .borders:
                            borderColorsSection()
                        case .status:
                            statusColorsSection()
                        case .gradients:
                            gradientsSection()
                        }
                    }
                    .padding(.horizontal, Theme.spacing20)
                }
                .padding(.top, Theme.spacing20)
            }
            .background(Theme.backgroundGradient)
            .navigationTitle("Color Debug")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Export Colors") {
                        exportColorInfo()
                    }
                    .foregroundColor(Theme.primaryBlue)
                }
            }
        }
    }
    
    // MARK: - Color Sections
    
    @ViewBuilder
    private func primaryColorsSection() -> some View {
        colorCard(name: "Primary Navy", color: Theme.primaryNavy, description: "Deep navy primary color")
        colorCard(name: "Primary Navy Dark", color: Theme.primaryNavyDark, description: "Darker navy variant")
        colorCard(name: "Primary Blue", color: Theme.primaryBlue, description: "Muted blue for accents")
    }
    
    @ViewBuilder
    private func surfaceColorsSection() -> some View {
        colorCard(name: "Surface Primary", color: Theme.surfacePrimary, description: "Very dark navy background")
        colorCard(name: "Surface Secondary", color: Theme.surfaceSecondary, description: "Dark navy cards")
        colorCard(name: "Surface Tertiary", color: Theme.surfaceTertiary, description: "Medium navy surfaces")
    }
    
    @ViewBuilder
    private func textColorsSection() -> some View {
        colorCard(name: "Text Primary", color: Theme.textPrimary, description: "Pure white text")
        colorCard(name: "Text Secondary", color: Theme.textSecondary, description: "Semi-transparent white (85%)")
        colorCard(name: "Text Tertiary", color: Theme.textTertiary, description: "Subtle white (60%)")
    }
    
    @ViewBuilder
    private func borderColorsSection() -> some View {
        colorCard(name: "Border Light", color: Theme.borderLight, description: "Light borders (15% white)")
        colorCard(name: "Border Medium", color: Theme.borderMedium, description: "Medium borders (25% white)")
        colorCard(name: "Border Accent", color: Theme.borderAccent, description: "Accent borders (40% white)")
    }
    
    @ViewBuilder
    private func statusColorsSection() -> some View {
        colorCard(name: "Success Green", color: Theme.successGreen, description: "Bright green for success states")
        colorCard(name: "Warning Amber", color: Theme.warningAmber, description: "Golden yellow for warnings")
        colorCard(name: "Error Red", color: Theme.errorRed, description: "Red for error states")
    }
    
    @ViewBuilder
    private func gradientsSection() -> some View {
        gradientCard(name: "Primary Gradient", gradient: Theme.primaryGradient, description: "Main gradient used for buttons")
        gradientCard(name: "Background Gradient", gradient: Theme.backgroundGradient, description: "Background gradient for screens")
        gradientCard(name: "Card Gradient", gradient: Theme.cardGradient, description: "Subtle gradient for cards")
    }
    
    // MARK: - Helper Views
    
    @ViewBuilder
    private func colorCard(name: String, color: Color, description: String) -> some View {
        VStack(alignment: .leading, spacing: Theme.spacing12) {
            HStack {
                // Color Preview
                RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                    .fill(color)
                    .frame(width: 60, height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                            .stroke(Theme.borderLight, lineWidth: 1)
                    )
                
                VStack(alignment: .leading, spacing: Theme.spacing4) {
                    Text(name)
                        .font(Theme.bodyLargeFont)
                        .foregroundColor(Theme.textPrimary)
                    
                    Text(description)
                        .font(Theme.bodyFont)
                        .foregroundColor(Theme.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Color value display
                    if let components = getColorComponents(color) {
                        Text("RGB: \(Int(components.r * 255)), \(Int(components.g * 255)), \(Int(components.b * 255))")
                            .font(Theme.captionFont)
                            .foregroundColor(Theme.textTertiary)
                        
                        if components.a < 1.0 {
                            Text("Alpha: \(String(format: "%.2f", components.a))")
                                .font(Theme.captionFont)
                                .foregroundColor(Theme.textTertiary)
                        }
                    }
                }
                
                Spacer()
                
                // Test Button
                Button("Test") {
                    testColor(name: name, color: color)
                }
                .padding(.horizontal, Theme.spacing12)
                .padding(.vertical, Theme.spacing8)
                .background(color)
                .foregroundColor(getContrastColor(for: color))
                .font(Theme.captionFont)
                .cornerRadius(Theme.cornerRadiusSmall)
            }
        }
        .padding(Theme.spacing16)
        .cardBackground()
    }
    
    @ViewBuilder
    private func gradientCard(name: String, gradient: LinearGradient, description: String) -> some View {
        VStack(alignment: .leading, spacing: Theme.spacing12) {
            HStack {
                // Gradient Preview
                RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                    .fill(gradient)
                    .frame(width: 60, height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                            .stroke(Theme.borderLight, lineWidth: 1)
                    )
                
                VStack(alignment: .leading, spacing: Theme.spacing4) {
                    Text(name)
                        .font(Theme.bodyLargeFont)
                        .foregroundColor(Theme.textPrimary)
                    
                    Text(description)
                        .font(Theme.bodyFont)
                        .foregroundColor(Theme.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
                
                // Test Button with gradient
                Button("Test") {
                    testGradient(name: name)
                }
                .padding(.horizontal, Theme.spacing12)
                .padding(.vertical, Theme.spacing8)
                .background(gradient)
                .foregroundColor(.white)
                .font(Theme.captionFont)
                .cornerRadius(Theme.cornerRadiusSmall)
            }
        }
        .padding(Theme.spacing16)
        .cardBackground()
    }
    
    // MARK: - Helper Functions
    
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
    
    private func getContrastColor(for color: Color) -> Color {
        guard let components = getColorComponents(color) else { return .white }
        
        // Calculate luminance
        let luminance = 0.299 * components.r + 0.587 * components.g + 0.114 * components.b
        return luminance > 0.5 ? .black : .white
    }
    
    private func testColor(name: String, color: Color) {
        print("🎨 Testing color: \(name)")
        print("   RGB values: \(getColorComponents(color) ?? (r: 0, g: 0, b: 0, a: 1))")
        
        // Flash the color briefly (visual feedback)
        withAnimation(.easeInOut(duration: 0.3)) {
            // This could trigger a visual effect or state change
        }
    }
    
    private func testGradient(name: String) {
        print("🌈 Testing gradient: \(name)")
        
        withAnimation(.easeInOut(duration: 0.3)) {
            // Visual feedback for gradient testing
        }
    }
    
    private func exportColorInfo() {
        let colorInfo = """
        Theme Color Export
        ==================
        
        Primary Colors:
        - Primary Navy: RGB(13, 26, 51)
        - Primary Navy Dark: RGB(5, 13, 31)
        - Primary Blue: RGB(26, 77, 153)
        
        Surface Colors:
        - Surface Primary: RGB(3, 5, 20)
        - Surface Secondary: RGB(5, 13, 31)
        - Surface Tertiary: RGB(13, 26, 51)
        
        Status Colors:
        - Success Green: RGB(0, 204, 102)
        - Warning Amber: RGB(255, 214, 0)
        - Error Red: RGB(230, 51, 51)
        """
        
        print(colorInfo)
        
        // In a real app, you might export this to a file or copy to clipboard
        // For now, we'll just print to console for debugging
    }
}

// MARK: - Preview

struct ColorDebugView_Previews: PreviewProvider {
    static var previews: some View {
        ColorDebugView()
            .preferredColorScheme(.dark)
    }
} 