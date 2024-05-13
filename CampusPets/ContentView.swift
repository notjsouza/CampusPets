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
    @State var entry: [Entry] = []
    
    var body: some View {
        NavigationStack {
            List {
                if entry.isEmpty {
                    Text("No entries!")
                }
                ForEach(entry, id: \.id) { entry in
                    EntryView(entry: entry)
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
        }
    }
}

#Preview {
    ContentView()
}
