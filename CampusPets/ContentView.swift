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
	@StateObject private var mapModel = MapModel()
	@State private var activeSheet: ActiveSheet?
	@State private var region = MKCoordinateRegion(
		center: CLLocationCoordinate2D(latitude: 32.8802, longitude: -117.2394),
		span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
	)
	
	enum ActiveSheet: Identifiable {
		case savingEntry, takingPicture, displayingEntries
		
		var id: Int {
			switch self {
			case .savingEntry: return 0
			case .takingPicture: return 1
			case .displayingEntries: return 2
			}
		}
	}
    
    var body: some View {
        NavigationStack {
			ZStack {
				VStack {
					MapView(region: $region)
						.environmentObject(mapModel)
				}
				.onAppear {
					if let location = mapModel.currentLocation {
						mapModel.setRegion(location: location, region: &region)
					}
				}
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
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
					
					ToolbarItemGroup(placement: .bottomBar) {
						
						Button(action: {
							if let location = mapModel.currentLocation {
								mapModel.setRegion(location: location, region: &region)
							}
						}) {
							Image(systemName: "location.fill")
								.foregroundColor(.black)
								.fontWeight(.semibold)
								.padding(.vertical, 10)
								.padding(.horizontal, 10)
								.background(Color.white)
								.clipShape(Circle())
						}
						
						Spacer()
						
						Button(action: { activeSheet = .takingPicture }) {
							Image(systemName: "camera.fill")
								.foregroundColor(.black)
								.fontWeight(.semibold)
								.padding(.vertical, 20)
								.padding(.horizontal, 40)
								.background(Color.white)
								.clipShape(Capsule())
						}
						.bold()
						
						Spacer()
						
						Button(action: { activeSheet = .displayingEntries }) {
							Image(systemName: "list.clipboard.fill")
							.foregroundColor(.black)
							.fontWeight(.semibold)
							.padding(.vertical, 10)
							.padding(.horizontal, 15)
							.background(Color.white)
							.clipShape(Capsule())
						}
						.bold()
					}
				}
			}
			
        }
		.sheet(item: $activeSheet) { sheet in
			switch sheet {
			case .savingEntry:
				SaveEntryView()
			case .takingPicture:
				CameraView().environmentObject(mapModel)
			case .displayingEntries:
				DisplayEntries()
			}
		}
    }
}

#Preview {
	ContentView()
}
