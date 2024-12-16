import SwiftUI

struct TeamPlayersView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var players: [Player]
    @StateObject private var playerStore = PlayerStore()
    @State private var showingPlayerPicker = false
    
    var body: some View {
        List {
            Section {
                ForEach(players) { player in
                    Text(player.name)
                }
                .onDelete { indexSet in
                    players.remove(atOffsets: indexSet)
                }
            }
            
            Section {
                Button {
                    showingPlayerPicker = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Player")
                    }
                }
            }
        }
        .navigationTitle("Team Players")
        .sheet(isPresented: $showingPlayerPicker) {
            PlayerPickerView(selectedPlayers: $players, availablePlayers: playerStore.players)
        }
    }
} 