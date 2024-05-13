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

@main
struct CampusPetsApp: App {
    
    init(){
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.configure()
            print("Successfully configured Amplify")
        } catch {
            print("Couldn't configure Amplify, \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            LandingView()
                .environmentObject(AuthenticationService())
        }
    }
    
}
