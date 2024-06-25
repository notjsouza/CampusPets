//
//  DisplayEntries.swift
//  CampusPets
//
//  Created by Justin Souza on 6/24/24.
//

import SwiftUI
import Foundation

struct DisplayEntries: View {
    
    @EnvironmentObject private var entryService: EntryService
    @EnvironmentObject private var storageService: StorageService
    
    var body: some View {
        VStack {
            if entryService.entries.isEmpty {
                VStack(alignment: .center) {
                    Text("Nothing logged yet, go out and explore!")
                        .bold()
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }
            
            List {
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
        }
        .task {
            await entryService.fetchNotes()
        }
    }
}
