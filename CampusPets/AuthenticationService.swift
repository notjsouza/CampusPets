//
//  AuthenticationService.swift
//  CampusPets
//
//  Created by Justin Souza on 5/12/24.
//

import Amplify
import AuthenticationServices
import AWSCognitoAuthPlugin
import SwiftUI

@MainActor
class AuthenticationService: ObservableObject {
    
    @Published var isSignedIn = false
    
    func fetchSession() async {
        
        do {
            
            let result = try await Amplify.Auth.fetchAuthSession()
            isSignedIn = result.isSignedIn
            print("Fetch session completed. isSignedIn = \(isSignedIn)")
            
        } catch {
            
            print("Fetch session failed with error: \(error)")
            
        }
        
    }
    
    func signIn(presentationAnchor: ASPresentationAnchor) async {
        do {
            
            let result = try await Amplify.Auth.signInWithWebUI(
                presentationAnchor: presentationAnchor,
                options: .preferPrivateSession()
            )
            isSignedIn = result.isSignedIn
            print("Sign in completed. isSignedIn = \(isSignedIn)")
            
        } catch {
            
            print("Sign in failed with error: \(error)")
            
        }
    }
    
    func signOut() async {
        
        guard let result = await Amplify.Auth.signOut() as? AWSCognitoSignOutResult else {
            return
        }
        switch result {
        case .complete, .partial:
            isSignedIn = false
        case .failed:
            break
        }
        print("Sign out completed. isSignedIn = \(isSignedIn)")
    }
    
}
