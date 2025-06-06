import SwiftUI

struct EducationalSlide: Identifiable {
    let id: Int
    let title: String
    let content: String
    let imageName: String? // SF Symbol name
}

let educationalSlides: [EducationalSlide] = [
    EducationalSlide(
        id: 1,
        title: "Porn hijacks your brain",
        content: "Pornography floods your brain with dopamine, the same chemical released by addictive drugs. Over time, your brain needs more extreme content to feel the same pleasure.",
        imageName: "brain.head.profile"
    ),
    EducationalSlide(
        id: 2,
        title: "Destroys real intimacy",
        content: "Porn creates unrealistic expectations that make it harder to connect with real partners. It rewires your brain to prefer fantasy over genuine human connection.",
        imageName: "heart.slash.fill"
    ),
    EducationalSlide(
        id: 3,
        title: "Steals your time and energy",
        content: "The average user spends hours each week consuming porn, time that could be spent building real relationships, pursuing goals, and developing yourself.",
        imageName: "clock.badge.xmark.fill"
    )
] 