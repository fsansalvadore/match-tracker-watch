import Foundation

@MainActor
class MatchStore: ObservableObject {
    @Published private(set) var matches: [Match] = []
    private let saveKey = "SavedMatches"
    
    init() {
        loadMatches()
    }
    
    func addMatch(_ match: Match) {
        matches.append(match)
        saveMatches()
    }
    
    func deleteMatch(at indexSet: IndexSet) {
        matches.remove(atOffsets: indexSet)
        saveMatches()
    }
    
    func deleteMatch(_ match: Match) {
        matches.removeAll { $0.id == match.id }
        saveMatches()
    }
    
    private func loadMatches() {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let decoded = try? JSONDecoder().decode([Match].self, from: data) else { return }
        matches = decoded
    }
    
    private func saveMatches() {
        guard let encoded = try? JSONEncoder().encode(matches) else { return }
        UserDefaults.standard.set(encoded, forKey: saveKey)
    }
} 