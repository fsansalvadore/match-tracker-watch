import SwiftUI

struct MatchStatsView: View {
    @Environment(\.dismiss) private var dismiss
    let match: Match
    @ObservedObject var matchStore: MatchStore
    @State private var lastSyncDate: Date?
    @State private var isSyncing = false
    
    private let timerFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            VStack {
                Text("\(match.scoreA)-\(match.scoreB)")
                    .font(.title)
                    .padding()
                
                Text("Goals Timeline")
                    .font(.headline)
                
                VStack(alignment: .leading) {
                    ForEach(match.goalsA) { goal in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Team A")
                                    .font(.caption2)
                                Text(goal.scorer.name)
                                if let assist = goal.assist {
                                    Text("Assist: \(assist.name)")
                                        .font(.caption2)
                                }
                            }
                            Spacer()
                            Text(timerFormatter.string(from: goal.timestamp) ?? "00:00:00")
                        }
                        .font(.caption)
                        .padding(.vertical, 4)
                    }
                    
                    ForEach(match.goalsB) { goal in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Team B")
                                    .font(.caption2)
                                Text(goal.scorer.name)
                                if let assist = goal.assist {
                                    Text("Assist: \(assist.name)")
                                        .font(.caption2)
                                }
                            }
                            Spacer()
                            Text(timerFormatter.string(from: goal.timestamp) ?? "00:00:00")
                        }
                        .font(.caption)
                        .padding(.vertical, 4)
                    }
                }
                .padding()
                
                Spacer()
                
                VStack(spacing: 16) {
                    HStack {
                        Button("Delete") {
                            matchStore.deleteMatch(match)
                            dismiss()
                        }
                        .tint(.red)
                        
                        Button {
                            Task {
                                await syncMatch()
                            }
                        } label: {
                            HStack {
                                Text("Sync")
                                if isSyncing {
                                    ProgressView()
                                        .tint(.white)
                                }
                            }
                        }
                        .tint(.blue)
                        .disabled(isSyncing)
                    }
                    
                    if let syncDate = lastSyncDate {
                        Text("Match synced at \(syncDate.formatted(date: .omitted, time: .shortened))")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
            }
        }
    }
    
    private func syncMatch() async {
        isSyncing = true
        do {
            lastSyncDate = try await MatchSync.syncMatch(match)
        } catch {
            // Handle error (could add an alert here)
            print("Sync failed: \(error)")
        }
        isSyncing = false
    }
} 