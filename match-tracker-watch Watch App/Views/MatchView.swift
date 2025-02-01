import SwiftUI
import WatchKit

struct MatchView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var matchStore: MatchStore
    let teamA: [Player]
    let teamB: [Player]
    @State private var timeElapsed: TimeInterval = 0
    @State private var timer: Timer?
    @State private var goalsA: [Goal] = []
    @State private var goalsB: [Goal] = []
    @State private var isRunning = false
    @State private var showingMatchStats = false
    @State private var showingGoalEditorA = false
    @State private var showingGoalEditorB = false
    @State private var pendingGoalTimestamp: TimeInterval?
    @State private var showingGoalieChangeAlert = false
    @State private var startTime: Date?
    
    private let timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    private let goalieChangeInterval: TimeInterval = 300 // 5 minutes in seconds
    
    private var formattedTime: String {
        let hours = Int(timeElapsed) / 3600
        let minutes = (Int(timeElapsed) % 3600) / 60
        let seconds = Int(timeElapsed) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    var body: some View {
        VStack(spacing: 2) {
            Text(formattedTime)
                .font(.system(size: 32))
                .padding()
                .monospacedDigit()
            
            HStack {
                Button(isRunning ? "Pause" : "Start") {
                    if isRunning {
                        pauseMatch()
                    } else {
                        startMatch()
                    }
                }
                .tint(isRunning ? .orange : .green)
                
                Button("Stop") {
                    stopMatch()
                }
                .tint(.red)
            }
            
            HStack {
                Button {
                    if isRunning {
                        pendingGoalTimestamp = timeElapsed
                        showingGoalEditorA = true
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 12))
                        .frame(width: 24, height: 24)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing, 16)
                
                Text("\(goalsA.count)")
                    .font(.title)
                Text("-")
                    .font(.title)
                Text("\(goalsB.count)")
                    .font(.title)
                
                Button {
                    if isRunning {
                        pendingGoalTimestamp = timeElapsed
                        showingGoalEditorB = true
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 12))
                        .frame(width: 24, height: 24)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.leading, 16)
            }
            .padding()
        }
        .fullScreenCover(isPresented: $showingMatchStats) {
            NavigationView {
                MatchStatsView(match: Match(
                    duration: timeElapsed,
                    teamA: teamA,
                    teamB: teamB,
                    goalsA: goalsA,
                    goalsB: goalsB
                ), matchStore: matchStore)
            }
        }
        .sheet(isPresented: $showingGoalEditorA) {
            if let timestamp = pendingGoalTimestamp {
                GoalEditorView(
                    timestamp: TimeInterval(pendingGoalTimestamp ?? 0),
                    teamPlayers: teamA,
                    onSave: { goal in
                        goalsA.append(goal)
                    }
                )
            }
        }
        .sheet(isPresented: $showingGoalEditorB) {
            if let timestamp = pendingGoalTimestamp {
                GoalEditorView(
                    timestamp: TimeInterval(pendingGoalTimestamp ?? 0),
                    teamPlayers: teamB,
                    onSave: { goal in
                        goalsB.append(goal)
                    }
                )
            }
        }
        .alert("Cambio purti", isPresented: $showingGoalieChangeAlert) {
            Button("OK") {
                WKInterfaceDevice.current().play(.stop)
            }
        } message: {
            Text("Prossimo cambio tra 5 minuti")
        }
    }
    
    private func startMatch() {
        isRunning = true
        startTime = Date() // Record the start time
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            if let startTime = startTime {
                timeElapsed = Date().timeIntervalSince(startTime) // Calculate elapsed time
            }
            
            // Check for 5-minute intervals
            let previousInterval = Int((timeElapsed - 0.01) / goalieChangeInterval)
            let currentInterval = Int(timeElapsed / goalieChangeInterval)
            
            if currentInterval > previousInterval {
                showGoalieChangeNotification()
            }
        }
    }
    
    private func pauseMatch() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        startTime = nil // Reset start time
    }
    
    private func stopMatch() {
        timer?.invalidate()
        timer = nil
        startTime = nil // Reset start time
        let match = Match(
            duration: timeElapsed,
            teamA: teamA,
            teamB: teamB,
            goalsA: goalsA,
            goalsB: goalsB
        )
        matchStore.addMatch(match)
        showingMatchStats = true
    }
    
    private func showGoalieChangeNotification() {
        showingGoalieChangeAlert = true
        WKInterfaceDevice.current().play(.notification)
    }
}
