import Foundation

@MainActor
class PlayerStore: ObservableObject {
    @Published private(set) var players: [Player] = [
        Player(name: "Player 1"),
        Player(name: "Player 2"),
        Player(name: "Player 3"),
        Player(name: "Player 4"),
        Player(name: "Player 5"),
        Player(name: "Player 6"),
        Player(name: "Player 7"),
        Player(name: "Player 8"),
        Player(name: "Player 9"),
        Player(name: "Player 10"),
        Player(name: "Player 11"),
        Player(name: "Player 12"),
        Player(name: "Player 13"),
        Player(name: "Player 14"),
        Player(name: "Player 15")
    ]
} 