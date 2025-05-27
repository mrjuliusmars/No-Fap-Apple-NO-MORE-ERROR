import Foundation

struct QuizQuestion: Identifiable {
    let id: Int
    let question: String
    let options: [String]
    let subtitle: String? // Optional subtitle for additional context
}

let quizQuestions: [QuizQuestion] = [
    QuizQuestion(
        id: 1,
        question: "What is your gender?",
        options: ["Male", "Female"],
        subtitle: nil
    ),
    QuizQuestion(
        id: 2,
        question: "How long have you been struggling with porn?",
        options: ["5+ years", "2-5 years", "Less than 2 years"],
        subtitle: nil
    ),
    QuizQuestion(
        id: 3,
        question: "How often do you typically view pornography?",
        options: ["More than once a day", "Once a day", "A few times a week", "Less than once a week"],
        subtitle: nil
    ),
    QuizQuestion(
        id: 4,
        question: "Do you feel guilty after watching porn?",
        options: ["Always", "Sometimes", "Rarely"],
        subtitle: nil
    ),
    QuizQuestion(
        id: 5,
        question: "Have you tried to quit before?",
        options: ["Many times", "A few times", "Never"],
        subtitle: nil
    ),
    QuizQuestion(
        id: 6,
        question: "Do you find it difficult to achieve sexual arousal without pornography?",
        options: ["Frequently", "Occasionally", "Rarely or never"],
        subtitle: nil
    ),
    QuizQuestion(
        id: 7,
        question: "Has porn affected your relationships?",
        options: ["Severely", "Moderately", "Not at all"],
        subtitle: nil
    ),
    QuizQuestion(
        id: 8,
        question: "Do you feel porn controls your life?",
        options: ["Completely", "Somewhat", "Not at all"],
        subtitle: nil
    ),
    QuizQuestion(
        id: 9,
        question: "Do you watch pornography out of boredom?",
        options: ["Frequently", "Occasionally", "Rarely or never"],
        subtitle: nil
    ),
    QuizQuestion(
        id: 10,
        question: "Has porn affected your self-esteem?",
        options: ["Severely", "Moderately", "Not at all"],
        subtitle: nil
    ),
    QuizQuestion(
        id: 11,
        question: "Do you want to quit porn for good?",
        options: ["Absolutely", "Maybe", "Not sure"],
        subtitle: nil
    ),
    QuizQuestion(
        id: 12,
        question: "Are you ready to take action today?",
        options: ["Yes, I'm ready", "Maybe later", "Not yet"],
        subtitle: "Your journey to freedom starts here"
    )
]

// Goals selection
struct Goal: Identifiable {
    let id: Int
    let title: String
    let description: String
}

let availableGoals: [Goal] = [
    Goal(id: 1, title: "Better Relationships", description: "Build genuine connections"),
    Goal(id: 2, title: "Mental Clarity", description: "Sharpen your focus"),
    Goal(id: 3, title: "More Energy", description: "Feel alive again"),
    Goal(id: 4, title: "Self Control", description: "Master your impulses"),
    Goal(id: 5, title: "Confidence", description: "Become your best self"),
    Goal(id: 6, title: "Better Sex Life", description: "Restore natural function"),
    Goal(id: 7, title: "Productivity", description: "Achieve your goals"),
    Goal(id: 8, title: "Inner Peace", description: "Find freedom from shame")
] 