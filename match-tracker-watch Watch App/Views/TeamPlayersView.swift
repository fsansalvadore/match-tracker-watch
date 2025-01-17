import SwiftUI

struct TeamPlayersView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var players: [Player]
    @Binding var otherTeamPlayers: [Player]
    let teamName: String
    let otherTeamName: String
    @StateObject private var playerStore = PlayerStore()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 8) {
                ForEach(playerStore.players) { player in
                    Button {
                        handlePlayerSelection(player)
                    } label: {
                        HStack {
                            Text(player.name)
                                .font(.system(size: 14))
                                .lineLimit(1)
                            Spacer()
                            
                            if players.contains(player) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12))
                                    .foregroundColor(.accentColor)
                            } else if otherTeamPlayers.contains(player) {
                                Text(otherTeamName)
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .foregroundColor(otherTeamPlayers.contains(player) ? .gray : .primary)
                    .padding(.horizontal, 8)
                    .frame(height: 20)

                    if player.id != playerStore.players.last?.id {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 0.5)
                            .padding(.horizontal, 8)
                    }
                }
            }
            .padding(.vertical, 8)
        }
        .navigationTitle("\(teamName) Players")
    }
    
    private func handlePlayerSelection(_ player: Player) {
        if players.contains(player) {
            players.removeAll { $0.id == player.id }
        } else if otherTeamPlayers.contains(player) {
            otherTeamPlayers.removeAll { $0.id == player.id }
            players.append(player)
        } else {
            players.append(player)
        }
    }
} 