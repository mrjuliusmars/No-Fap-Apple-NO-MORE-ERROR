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
        question: "At what age did regular porn viewing enter your life?",
        options: ["12 or younger", "13 to 16", "17 to 24", "25 or older"],
        subtitle: nil
    ),
    QuizQuestion(
        id: 2,
        question: "How often do you typically view pornography?",
        options: ["More than once a day", "Once a day", "A few times a week", "Less than once a week"],
        subtitle: nil
    ),
    QuizQuestion(
        id: 3,
        question: "Do you feel guilty after watching porn?",
        options: ["Yes", "No"],
        subtitle: nil
    ),
    QuizQuestion(
        id: 4,
        question: "Have you tried to quit before?",
        options: ["Many times", "A few times", "Never"],
        subtitle: nil
    ),
    QuizQuestion(
        id: 5,
        question: "Has the porn you view become more graphic or extreme?",
        options: ["Yes", "No"],
        subtitle: nil
    ),
    QuizQuestion(
        id: 6,
        question: "Do you watch porn to avoid stress?",
        options: ["Yes", "No"],
        subtitle: nil
    ),
    QuizQuestion(
        id: 7,
        question: "Do you watch pornography out of boredom?",
        options: ["Yes", "No"],
        subtitle: nil
    ),
    QuizQuestion(
        id: 8,
        question: "Do you feel porn controls your life?",
        options: ["Yes", "No"],
        subtitle: nil
    ),
    QuizQuestion(
        id: 9,
        question: "Do you want to quit porn for good?",
        options: ["Yes", "No"],
        subtitle: nil
    ),
    QuizQuestion(
        id: 10,
        question: "Are you ready to take action today?",
        options: ["Yes, I'm ready", "Not yet"],
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