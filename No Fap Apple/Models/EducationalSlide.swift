import SwiftUI

// MARK: - EducationalSlide Model
struct EducationalSlide {
    let id: Int
    let title: String
    let content: String
    let icon: String
    let color: Color
    let backgroundColor: Color
}

// MARK: - Educational Slides Data
let educationalSlides: [EducationalSlide] = [
    EducationalSlide(
        id: 1,
        title: "Porn Hijacks your Brain",
        content: "Porn floods your brain with dopamine, the same chemical released by addictive drugs.",
        icon: "brain.head.profile",
        color: .pink,
        backgroundColor: Color.pink.opacity(0.1)
    ),
    
    EducationalSlide(
        id: 2,
        title: "Destroys Real Relationships",
        content: "Porn trains your brain to prefer fantasy over real intimacy.",
        icon: "heart.fill",
        color: .red,
        backgroundColor: Color.red.opacity(0.1)
    ),
    
    EducationalSlide(
        id: 3,
        title: "Steals Your Time and Energy",
        content: "The average user spends 40 minutes per session - time that could build your dreams. Your biggest goals are being sacrificed for empty pleasure.",
        icon: "clock.fill",
        color: .blue,
        backgroundColor: Color.blue.opacity(0.1)
    )
] 
