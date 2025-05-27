import Foundation

struct SymptomCategory {
    let id: Int
    let title: String
    let symptoms: [String]
}

let symptomCategories: [SymptomCategory] = [
    SymptomCategory(
        id: 1,
        title: "Mental Symptoms",
        symptoms: [
            "Brain fog",
            "Low motivation",
            "Poor concentration",
            "Depression",
            "Anxiety",
            "Low self-esteem",
            "Mood swings"
        ]
    ),
    SymptomCategory(
        id: 2,
        title: "Physical Symptoms",
        symptoms: [
            "Always tired",
            "Can't sleep well",
            "No interest in real sex",
            "Performance anxiety",
            "Can't finish or finish too fast",
            "Tense muscles",
            "Dark under-eye circles",
            "Frequent headaches",
            "Poor hygiene habits",
            "Feeling physically weak"
        ]
    ),
    SymptomCategory(
        id: 3,
        title: "Social Symptoms",
        symptoms: [
            "Social anxiety",
            "Relationship issues",
            "Isolation",
            "Low self-worth",
            "Shame",
            "Guilt",
            "Emotional numbness",
            "Avoiding social events"
        ]
    )
] 