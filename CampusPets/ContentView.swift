//
//  ContentView.swift
//  CampusPets
//
//  Created by Justin Souza on 5/12/24.
//

import SwiftUI
import Amplify
import AVFoundation

struct ContentView: View {
    
    @EnvironmentObject private var authenticationService: AuthenticationService
    @EnvironmentObject private var entryService: EntryService
    @EnvironmentObject private var storageService: StorageService
    @State private var isSavingEntry = false
	@State private var isTakingPicture = false
    
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
                            if let image = entry.image {
                                await storageService.remove(withName: image)
                            }
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
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("", systemImage: "plus.app.fill") {
                        isSavingEntry = true
                    }
                    .bold()
					.sheet(isPresented: $isSavingEntry) {
							SaveEntryView()
					}
					
					Spacer()
					
					Button("", systemImage: "camera.fill") {
						isTakingPicture = true
					}
					.bold()
					.sheet(isPresented: $isTakingPicture) {
						CameraView()
					}
					
					Spacer()
					
                }
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
