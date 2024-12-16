import Foundation

struct Match: Identifiable, Codable {
    let id: UUID
    let duration: TimeInterval
    let teamA: [Player]
    let teamB: [Player]
    let goalsA: [Goal]
    let goalsB: [Goal]
    let date: Date
    
    var scoreA: Int { goalsA.count }
    var scoreB: Int { goalsB.count }
    
    init(id: UUID = UUID(), duration: TimeInterval, teamA: [Player], teamB: [Player], goalsA: [Goal], goalsB: [Goal], date: Date = Date()) {
        self.id = id
        self.duration = duration
        self.teamA = teamA
        self.teamB = teamB
        self.goalsA = goalsA
        self.goalsB = goalsB
        self.date = date
    }
} 