//
//  LandingView.swift
//  CampusPets
//
//  Created by Justin Souza on 5/12/24.
//

import AuthenticationServices
import SwiftUI

struct LandingView: View {
    
    @EnvironmentObject private var authenticationService: AuthenticationService
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView()
            }
            Group {
                if authenticationService.isSignedIn {
                    ContentView()
                } else {
                    Button("Sign In") {
                        Task {
                            await authenticationService.signIn(presentationAnchor: window)
                        }
                    }
                }
            }
            .opacity(isLoading ? 0.5 : 1)
            .disabled(isLoading)
        }
        .task {
            isLoading = true
            await authenticationService.fetchSession()
            if !authenticationService.isSignedIn {
                await authenticationService.signIn(presentationAnchor: window)
            }
            isLoading = false
        }
    }
    
    private var window: ASPresentationAnchor {
        if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? UIWindowSceneDelegate,
           let window = delegate.window as? UIWindow {
            return window
        }
        return ASPresentationAnchor()
    }
    
}
