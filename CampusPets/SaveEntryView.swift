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
    @EnvironmentObject private var storageService: StorageService
    @State private var name = ""
    @State private var description = ""
    @State private var image: Data? = nil
    
    var body: some View {
        Form {
            
            Section("Picture") {
                PicturePicker(selectedData: $image)
            }
            
            Section("Details") {
                TextField("Name", text: $name)
                TextField("Description", text: $description)
            }
            
            Button("Save Entry") {
                let imageName = image != nil ? UUID().uuidString : nil
                let entry = Entry(
                    name: name,
                    description: description.isEmpty ? nil : description,
                    image: imageName
                )
                
                Task {
                    if let image, let imageName {
                        await storageService.upload(image, name: imageName)
                    }
                    await entryService.save(entry)
                    dismiss()
                }
            }
        }
    }
}
