import Foundation

class MatchSync {
    static func syncMatch(_ match: Match) async throws -> Date {
        // Simulate API call
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
        
        // Simulate successful response
        return Date()
    }
} 