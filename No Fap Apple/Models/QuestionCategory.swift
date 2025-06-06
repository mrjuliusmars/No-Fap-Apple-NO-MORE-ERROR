import Foundation

enum QuestionCategory: String, CaseIterable {
    case awareness
    case consequences
    case struggles
    case costAnalysis
    case solution
    case commitment
    case goals
    
    var title: String {
        switch self {
        case .awareness:
            return "Awareness"
        case .consequences:
            return "Consequences"
        case .struggles:
            return "Struggles"
        case .costAnalysis:
            return "Cost Analysis"
        case .solution:
            return "Solution"
        case .commitment:
            return "Commitment"
        case .goals:
            return "Goals"
        }
    }
    
    var description: String {
        switch self {
        case .awareness:
            return "Understanding your patterns and triggers"
        case .consequences:
            return "Recognizing the impact on your life"
        case .struggles:
            return "Identifying your biggest challenges"
        case .costAnalysis:
            return "Analyzing what this habit costs you"
        case .solution:
            return "Finding effective strategies"
        case .commitment:
            return "Making a commitment to change"
        case .goals:
            return "Setting clear objectives"
        }
    }
} 