//
//  CampusPetsApp.swift
//  CampusPets
//
//  Created by Justin Souza on 5/12/24.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin
import AWSS3StoragePlugin
import AWSAPIPlugin

@main
struct CampusPetsApp: App {
    
    init(){
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: AmplifyModels()))
            try Amplify.configure()
            print("Successfully configured Amplify")
        } catch {
            print("Couldn't configure Amplify, error: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            LandingView()
                .environmentObject(EntryService())
                .environmentObject(AuthenticationService())
                .environmentObject(StorageService())
        }
    }
    
}
