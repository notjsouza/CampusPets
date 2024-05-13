//
//  Entry.swift
//  CampusPets
//
//  Created by Justin Souza on 5/12/24.
//

import Foundation

struct Entry {
    let id: String
    let name: String
    let description: String?
    let image: String?
    
    init(
        id: String,
        name: String,
        description: String? = nil,
        image: String?
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.image = image
    }
}
