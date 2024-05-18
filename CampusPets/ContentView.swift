//
//  ContentView.swift
//  CampusPets
//
//  Created by Justin Souza on 5/12/24.
//

import SwiftUI
import Amplify

struct ContentView: View {
    
    @EnvironmentObject private var authenticationService: AuthenticationService
    @EnvironmentObject private var entryService: EntryService
    @State private var isSavingEntry = false
    
    var body: some View {
        NavigationStack {
            List {
                if entryService.entries.isEmpty {
                    Text("No entries!")
                }
                ForEach(entryService.entries, id: \.id) { entry in
                    EntryView(entry: entry)
                }
                .onDelete{ indices in
                    for index in indices {
                        let entry = entryService.entries[index]
                        Task {
                            await entryService.delete(entry)
                        }
                    }
                }
            }
            .navigationTitle("Entries")
            .toolbar {
                Button("Sign Out") {
                    Task {
                        await authenticationService.signOut()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("⨁ New Entry") {
                        isSavingEntry = true
                    }
                    .bold()
                }
            }
            .sheet(isPresented: $isSavingEntry) {
                SaveEntryView()
            }
        }
        .task {
            await entryService.fetchNotes()
        }
    }
}

#Preview {
    ContentView()
}
