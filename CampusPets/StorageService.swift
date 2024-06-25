//
//  StorageService.swift
//  CampusPets
//
//  Created by Justin Souza on 5/22/24.
//

import Foundation
import Amplify

class StorageService: ObservableObject {
        
    func upload(_ data: Data, name: String) async {
        let task = Amplify.Storage.uploadData(
            key: name,
            data: data,
            options: .init(accessLevel: .protected)
        )
        do {
            let result = try await task.value
            print("Data upload complete with result: \(result)")
        } catch {
            print("Failed to upload data, error: \(error)")
        }
    }
    
    func download(withName name: String) async -> Data? {
        let task = Amplify.Storage.downloadData(
            key: name,
            options: .init(accessLevel: .protected)
        )
        do {
            let result = try await task.value
            print("Data downloaded successfully")
            return result
        } catch {
            print("Data download failed, error: \(error)")
            return nil
        }
    }
    
    func remove(withName name: String) async {
        do {
            let result = try await Amplify.Storage.remove(
                key: name,
                options: .init(accessLevel: .protected)
            )
            print("Completed item removal, result: \(result)")
        } catch {
            print("Failed to remove item, error: \(error)")
        }
    }
}
