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
                "players": match.teamA.map { ["id": $0.id] },
                "goals": match.goalsA.map { ["playerId": $0.scorer.id, "assistPlayerId": $0.assist?.id ?? "", "timestamp": Date(timeIntervalSince1970: $0.timestamp).iso8601String] }
            ],
            "team_b": [
                "name": "Team B",
                "players": match.teamB.map { ["id": $0.id] },
                "goals": match.goalsB.map { ["playerId": $0.scorer.id, "assistPlayerId": $0.assist?.id ?? "", "timestamp": Date(timeIntervalSince1970: $0.timestamp).iso8601String] }
            ]
        ]
        
        // Convert payload to JSON data
        let jsonData = try JSONSerialization.data(withJSONObject: payload)

        // Check if we are in DEBUG mode
        #if DEBUG
        let debugMode = true
        #else
        let debugMode = false
        #endif

        // Create the URL
        guard let url = URL(string: debugMode ? "http://localhost:3000/api/create-match?leagueId=1" : "https://match-tracker-web.vercel.app/api/create-match?leagueId=1") else {
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