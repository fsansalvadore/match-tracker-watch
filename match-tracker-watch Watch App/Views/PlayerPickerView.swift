import SwiftUI

struct PlayerPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedPlayers: [Player]
    let availablePlayers: [Player]
    
    var body: some View {
        List(availablePlayers) { player in
            Button {
                if !selectedPlayers.contains(player) {
                    selectedPlayers.append(player)
                }
                dismiss()
            } label: {
                Text(player.name)
            }
        }
    }
} 