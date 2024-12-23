//
//  ContentView.swift
//  match-tracker-watch Watch App
//
//  Created by Francesco Sansalvadore on 15/12/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var matchStore = MatchStore()
    @State private var showingNewMatch = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(matchStore.matches) { match in
                    NavigationLink(destination: MatchStatsView(match: match)) {
                        VStack(alignment: .leading) {
                            Text("\(match.scoreA)-\(match.scoreB)")
                            Text(match.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                        }
                    }
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

#Preview {
    ContentView()
}
