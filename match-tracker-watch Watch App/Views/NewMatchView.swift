import SwiftUI

struct NewMatchView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var matchStore: MatchStore
    @State private var teamA: [Player] = []
    @State private var teamB: [Player] = []
    @State private var showingTeamAPlayers = false
    @State private var showingTeamBPlayers = false
    @State private var showingMatchView = false
    
    var body: some View {
        VStack {
            HStack(spacing: 8) {
                Button {
                    showingTeamAPlayers = true
                } label: {
                    TeamBox(name: "Team A", playerCount: teamA.count)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button {
                    showingTeamBPlayers = true
                } label: {
                    TeamBox(name: "Team B", playerCount: teamB.count)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal)
            
            Spacer().frame(height: 16)
            
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .tint(.red)
                
                Button("Start") {
                    showingMatchView = true
                }
                .tint(.green)
                .disabled(teamA.isEmpty || teamB.isEmpty)
            }
        }
        .sheet(isPresented: $showingTeamAPlayers) {
            NavigationView {
                TeamPlayersView(
                    players: $teamA,
                    otherTeamPlayers: $teamB,
                    teamName: "Team A",
                    otherTeamName: "Team B"
                )
            }
        }
        .sheet(isPresented: $showingTeamBPlayers) {
            NavigationView {
                TeamPlayersView(
                    players: $teamB,
                    otherTeamPlayers: $teamA,
                    teamName: "Team B",
                    otherTeamName: "Team A"
                )
            }
        }
        .fullScreenCover(isPresented: $showingMatchView) {
            MatchView(matchStore: matchStore, teamA: teamA, teamB: teamB)
        }
    }
}

struct TeamBox: View {
    let name: String
    let playerCount: Int
    
    var body: some View {
        VStack(spacing: 4) {
            Text(name)
                .font(.headline)
            Text("\(playerCount) \(playerCount == 1 ? "player" : "players")")
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color(.darkGray).opacity(0.3))
        .cornerRadius(6)
    }
} 