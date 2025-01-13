import SwiftUI

struct SettingsView: View {
    @StateObject private var playerStore = PlayerStore()
    @State private var isLoading = false
    @State private var syncMessage: String? = nil

    var body: some View {
        List {
            Section(header: Text("Actions")) {
                Button("Sync Players") {
                    Task {
                        await syncPlayers()
                    }
                }
                .buttonStyle(PlainButtonStyle())

                if isLoading {
                    ProgressView("Syncing...")
                }
                if let message = syncMessage {
                    Text(message)
                        .foregroundColor(message.starts(with: "Last synced") ? .green : .red)
                        .padding()
                }
            }
        }
        .navigationTitle("Settings")
    }

    private func syncPlayers() async {
        isLoading = true
        syncMessage = nil // Reset message

        do {
            let players = try await fetchPlayers()
            playerStore.players = players // Override the existing players
            playerStore.savePlayers() // Save players to local storage
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yy-MM-dd HH:mm"
            let formattedDate = dateFormatter.string(from: Date())
            syncMessage = "Last synced at \(formattedDate)"
        } catch {
            syncMessage = "Failed to sync players: \(error.localizedDescription)"
        }

        isLoading = false
    }

    // Check if we are in DEBUG mode
    #if DEBUG
    let debugMode = true
    #else
    let debugMode = false
    #endif

    private func fetchPlayers() async throws -> [Player] {
        guard let url = URL(string: debugMode ? "http://localhost:3000/api/get-all-players?leagueId=1" : "https://match-tracker-web.vercel.app/api/get-all-players?leagueId=1") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let playerResponse = try JSONDecoder().decode(PlayerResponse.self, from: data)
        return playerResponse.data.map { Player(id: $0.id, name: $0.name) }
    }
}

struct PlayerResponse: Codable {
    let data: [PlayerData]
}

struct PlayerData: Codable {
    let id: Int
    let name: String
} 