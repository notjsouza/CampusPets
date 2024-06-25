//
//  ContentView.swift
//  CampusPets
//
//  Created by Justin Souza on 5/12/24.
//

import SwiftUI
import Amplify
import MapKit

struct ContentView: View {
    
    @EnvironmentObject private var authenticationService: AuthenticationService
	
    @State private var isSavingEntry = false
	@State private var isTakingPicture = false
	@State private var isDisplayingEntries = false
    
    var body: some View {
        NavigationStack {
			VStack {
				MapView()
			}
            .toolbar {
				Button(action: {
					Task {
						await authenticationService.signOut()
					}
				}) {
					Text("Sign Out")
						.foregroundColor(.black)
						.fontWeight(.semibold)
						.padding(.vertical, 5)
						.padding(.horizontal, 10)
						.background(Color.white)
						.clipShape(Capsule())
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    
					Button(action: { isSavingEntry = true }) {
						Image(systemName: "plus.app.fill")
							.foregroundColor(.black)
							.fontWeight(.semibold)
							.padding(.vertical, 15)
							.padding(.horizontal, 15)
							.background(Color.white)
							.clipShape(Capsule())
					}
					.bold()
					.sheet(isPresented: $isSavingEntry) {
						SaveEntryView()
					}
					
					Spacer()
					
					Button(action: { isTakingPicture = true }) {
						Image(systemName: "camera.fill")
							.foregroundColor(.black)
							.fontWeight(.semibold)
							.padding(.vertical, 20)
							.padding(.horizontal, 40)
							.background(Color.white)
							.clipShape(Capsule())
						
					}
					.bold()
					.sheet(isPresented: $isTakingPicture) {
						CameraView()
					}
					
					Spacer()
					
					Button(action: { isDisplayingEntries = true }) {
						Image(systemName: "list.clipboard.fill")
						.foregroundColor(.black)
						.fontWeight(.semibold)
						.padding(.vertical, 10)
						.padding(.horizontal, 15)
						.background(Color.white)
						.clipShape(Capsule())
					}
					.bold()
					.sheet(isPresented: $isDisplayingEntries) {
						DisplayEntries()
					}
                }
            }
        }
    }
}

#Preview {
	ContentView()
}
