import SwiftUI

struct ContentView: View {
    @StateObject private var matchStore = MatchStore()
    @State private var showingNewMatch = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Custom header with gear icon
                HStack {
                    Spacer()
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gear")
                            .font(.system(size: 20)) // Smaller size for the gear icon
                            .foregroundColor(.gray) // Gray color for the gear icon
                            .frame(maxWidth: .infinity) // Full width
                            .padding(.vertical, 10) // Vertical padding for height
                            .background(Color.clear) // Clear background
                            .cornerRadius(5) // Less rounded corners
                    }
                }
                
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
        }
        .sheet(isPresented: $showingNewMatch) {
            NewMatchView(matchStore: matchStore)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
} 