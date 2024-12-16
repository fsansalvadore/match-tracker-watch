import Foundation

struct Goal: Identifiable, Codable {
    let id: UUID
    let timestamp: TimeInterval
    let scorer: Player
    let assist: Player?
    
    init(id: UUID = UUID(), timestamp: TimeInterval, scorer: Player, assist: Player? = nil) {
        self.id = id
        self.timestamp = timestamp
        self.scorer = scorer
        self.assist = assist
    }
} 