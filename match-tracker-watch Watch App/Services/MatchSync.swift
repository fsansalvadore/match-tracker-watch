import Foundation

class MatchSync {
    static func syncMatch(_ match: Match) async throws -> Date {
        // Prepare the payload
        let payload: [String: Any] = [
            "location": "Podiciotto",
            "note": "Match from endpoint",
            "date": match.date.iso8601String,
            "start_at": match.date.iso8601String,
            "end_at": match.date.iso8601String,
            "league_id": 1,
            "team_a": [
                "name": "Team A",
                "players": match.teamA.map { ["id": $0.id.uuidString, "name": $0.name] },
                "goals": match.goalsA.map { ["id": $0.id.uuidString, "team": "team_a", "playerId": $0.scorer.id.uuidString, "assistPlayerId": $0.assist?.id.uuidString ?? "", "timestamp": Date(timeIntervalSince1970: $0.timestamp).iso8601String] }
            ],
            "team_b": [
                "name": "Team B",
                "players": match.teamB.map { ["id": $0.id.uuidString, "name": $0.name] },
                "goals": match.goalsB.map { ["id": $0.id.uuidString, "team": "team_b", "playerId": $0.scorer.id.uuidString, "assistPlayerId": $0.assist?.id.uuidString ?? "", "timestamp": Date(timeIntervalSince1970: $0.timestamp).iso8601String] }
            ]
        ]
        
        // Convert payload to JSON data
        let jsonData = try JSONSerialization.data(withJSONObject: payload)

        // Create the URL
        guard let url = URL(string: "https://match-tracker-web.vercel.app/api/create-match") else {
            throw URLError(.badURL)
        }

        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        // Perform the API call
        let (data, response) = try await URLSession.shared.data(for: request)

        // Check for a successful response
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        // Handle the response (if needed)
        return Date()
    }
} 