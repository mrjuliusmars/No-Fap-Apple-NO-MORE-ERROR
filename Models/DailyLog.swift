import Foundation

struct DailyUrgeLog: Codable, Identifiable {
    let id: UUID
    let date: Date
    let urgeLevel: String // "🔥", "😐", "🙌"
    
    init(date: Date, urgeLevel: String) {
        self.id = UUID()
        self.date = date
        self.urgeLevel = urgeLevel
    }
}

struct DailyReflection: Codable, Identifiable {
    let id: UUID
    let date: Date
    let mood: String // e.g., "😊", "😐", "😣"
    
    init(date: Date, mood: String) {
        self.id = UUID()
        self.date = date
        self.mood = mood
    }
} 
