import SwiftUI

struct GoalEditorView: View {
    @Environment(\.dismiss) private var dismiss
    let timestamp: TimeInterval
    let teamPlayers: [Player]
    @State private var selectedScorer: Player?
    @State private var selectedAssist: Player?
    @State private var showingScorerPicker = false
    @State private var showingAssistPicker = false
    let onSave: (Goal) -> Void
    
    private let timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 16) {
            Text(timeFormatter.string(from: timestamp) ?? "00:00:00")
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Scorer")
                    .font(.headline)
                
                Button {
                    showingScorerPicker = true
                } label: {
                    HStack {
                        Text(selectedScorer?.name ?? "Select Player")
                            .foregroundColor(selectedScorer == nil ? .gray : .white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Assist")
                    .font(.headline)
                
                Button {
                    showingAssistPicker = true
                } label: {
                    HStack {
                        Text(selectedAssist?.name ?? "Select Player")
                            .foregroundColor(selectedAssist == nil ? .gray : .white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Spacer()
            
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .tint(.red)
                
                Button("Save") {
                    if let scorer = selectedScorer {
                        let goal = Goal(timestamp: timestamp, scorer: scorer, assist: selectedAssist)
                        onSave(goal)
                        dismiss()
                    }
                }
                .tint(.green)
                .disabled(selectedScorer == nil)
            }
        }
        .padding()
        .sheet(isPresented: $showingScorerPicker) {
            List(teamPlayers) { player in
                Button {
                    selectedScorer = player
                    showingScorerPicker = false
                } label: {
                    Text(player.name)
                        .foregroundColor(player == selectedScorer ? .accentColor : .white)
                }
            }
        }
        .sheet(isPresented: $showingAssistPicker) {
            List(teamPlayers) { player in
                Button {
                    selectedAssist = player
                    showingAssistPicker = false
                } label: {
                    Text(player.name)
                        .foregroundColor(player == selectedAssist ? .accentColor : .white)
                }
            }
        }
    }
} 