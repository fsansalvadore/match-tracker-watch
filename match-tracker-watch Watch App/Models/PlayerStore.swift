import Foundation

@MainActor
class PlayerStore: ObservableObject {
    @Published var players: [Player] = []

    private let saveKey = "SavedPlayers"

    init() {
        loadPlayers()
    }

    func savePlayers() {
        guard let encoded = try? JSONEncoder().encode(players) else { return }
        UserDefaults.standard.set(encoded, forKey: saveKey)
    }

    private func loadPlayers() {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let decoded = try? JSONDecoder().decode([Player].self, from: data) else { return }
        players = decoded
    }
} 