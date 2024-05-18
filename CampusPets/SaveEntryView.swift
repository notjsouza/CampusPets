//
//  SaveEntryView.swift
//  CampusPets
//
//  Created by Justin Souza on 5/18/24.
//

import SwiftUI

struct SaveEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var entryService: EntryService
    @State private var name = ""
    @State private var description = ""
    @State private var image = ""
    
    var body: some View {
        Form {
            Section("Details") {
                TextField("Name", text: $name)
                TextField("Description", text: $description)
            }
            
            Section("Picture") {
                TextField("Image Name", text: $image)
            }
            
            Button("Save Entry") {
                let entry = Entry(
                    name: name,
                    description: description.isEmpty ? nil : description,
                    image: image.isEmpty ? nil : image
                )
                
                Task {
                    await entryService.save(entry)
                    dismiss()
                }
            }
        }
    }
}
