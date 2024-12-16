import SwiftUI

struct ContentView: View {
    @StateObject private var matchStore = MatchStore()
    @State private var showingNewMatch = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(matchStore.matches) { match in
                    NavigationLink(destination: MatchStatsView(match: match, matchStore: matchStore)) {
                        VStack(alignment: .leading) {
                            Text("\(match.scoreA)-\(match.scoreB)")
                            Text(match.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                        }
                    }
                }
                .onDelete { indexSet in
                    matchStore.deleteMatch(at: indexSet)
                }
            }
            .navigationTitle("Matches")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingNewMatch = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
        }
        .sheet(isPresented: $showingNewMatch) {
            NewMatchView(matchStore: matchStore)
        }
    }
} 