import Foundation

struct Goal: Identifiable, Codable {
    let id: UUID
    let timestamp: Int  // Changed from TimeInterval to Int
    let scorer: Player
    let assist: Player?
    
    init(id: UUID = UUID(), timestamp: TimeInterval, scorer: Player, assist: Player? = nil) {
        self.id = id
        self.timestamp = Int(timestamp)  // Convert TimeInterval to Int during initialization
        self.scorer = scorer
        self.assist = assist
    }
} 