//
//  EntryView.swift
//  CampusPets
//
//  Created by Justin Souza on 5/12/24.
//

import SwiftUI

struct EntryView: View {
    @State var entry: Entry
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 5.0) {
            
            VStack(alignment: .leading, spacing: 5.0) {
                
                Text(entry.name).bold()
                
                if let description = entry.description {
                    Text(description)
                }
            }
            
            if let image = entry.image {
                Spacer()
                
                Divider()
                
                Image(systemName: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30, height: 30)
                
            }
        }
    }
}
