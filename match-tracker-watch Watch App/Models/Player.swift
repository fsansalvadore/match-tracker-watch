import Foundation

struct Player: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    
    init(id: Int = 0, name: String) {
        self.id = id
        self.name = name
    }
} 