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
        VStack(spacing: 4) {
            Text(timeFormatter.string(from: timestamp) ?? "00:00:00")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Scorer")
                    .font(.callout)

                Button {
                    showingScorerPicker = true
                } label: {
                    HStack {
                        Text(selectedScorer?.name ?? "Select Player")
                            .foregroundColor(selectedScorer == nil ? .gray : .white)
                            .font(.system(size: 12))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .frame(width: 12)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 4)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Assist")
                    .font(.callout)
                
                Button {
                    showingAssistPicker = true
                } label: {
                    HStack {
                        Text(selectedAssist?.name ?? "Select Player")
                            .foregroundColor(selectedAssist == nil ? .gray : .white)
                            .font(.system(size: 12))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .frame(width: 12)
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
                .padding(2)
                
                Button("Save") {
                    if let scorer = selectedScorer {
                        let goal = Goal(timestamp: timestamp, scorer: scorer, assist: selectedAssist)
                        onSave(goal)
                        dismiss()
                    }
                }
                .tint(.green)
                .padding(2)
                .disabled(selectedScorer == nil)
            }
        }
        .padding()
        .sheet(isPresented: $showingScorerPicker) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 8) {
                    ForEach(teamPlayers) { player in
                        Button {
                            selectedScorer = player
                            showingScorerPicker = false
                        } label: {
                            HStack {
                                Text(player.name)
                                    .font(.system(size: 14))
                                    .lineLimit(1)
                                Spacer()
                                
                                if player == selectedScorer {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 12))
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .foregroundColor(.primary)
                        .padding(.horizontal, 8)
                        .frame(height: 20)

                        if player.id != teamPlayers.last?.id {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 0.5)
                                .padding(.horizontal, 8)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .sheet(isPresented: $showingAssistPicker) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 8) {
                    ForEach(teamPlayers) { player in
                        Button {
                            selectedAssist = player
                            showingAssistPicker = false
                        } label: {
                            HStack {
                                Text(player.name)
                                    .font(.system(size: 14))
                                    .lineLimit(1)
                                Spacer()
                                
                                if player == selectedAssist {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 12))
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .foregroundColor(.primary)
                        .padding(.horizontal, 8)
                        .frame(height: 20)

                        if player.id != teamPlayers.last?.id {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 0.5)
                                .padding(.horizontal, 8)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
} 