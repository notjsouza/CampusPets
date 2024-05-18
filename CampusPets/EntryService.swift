//
//  EntryService.swift
//  CampusPets
//
//  Created by Justin Souza on 5/18/24.
//

import Amplify
import SwiftUI

@MainActor
class EntryService: ObservableObject {
    @Published var entries: [Entry] = []
    
    func fetchNotes() async {
        do {
            let result = try await Amplify.API.query(request: .list(Entry.self))
            switch result {
            case .success(let entryList):
                print("Fetched \(entryList.count) entries")
                entries = entryList.elements
            case .failure(let error):
                print("Couldn't fetch Entry, failed with error: \(error)")
            }
        } catch {
            print("Fetch Entry failed with error: \(error)")
        }
    }
    
    func save(_ entry: Entry) async {
        do {
            let result = try await Amplify.API.mutate(request: .create(entry))
            switch result {
            case .success(let entry):
                print("Saved new entry")
                entries.append(entry)
            case .failure(let error):
                print("Save entry failed with error: \(error)")
            }
        } catch {
            print("Save new entry failed with error: \(error)")
        }
    }
    
    func delete(_ entry: Entry) async {
        do {
            let result = try await Amplify.API.mutate(request: .delete(entry))
            switch result {
            case .success(let entry):
                print("Entry successfully deleted")
                entries.removeAll(where: {$0.id == entry.id })
            case .failure(let error):
                print("Entry could not be deleted, error: \(error)")
            }
        } catch {
            print("Entry could not be deleted, error: \(error)")
        }
    }
    
}

