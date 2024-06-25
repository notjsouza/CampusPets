//
//  MapView.swift
//  CampusPets
//
//  Created by Justin Souza on 6/24/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @StateObject private var mapModel = MapModel()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 32.8802, longitude: -117.2394),
        span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
    )
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Button(action: {
                    if let location = mapModel.currentLocation {
                        mapModel.setRegion(location: location, region: &region)
                    }
                }) {
                    Image(systemName: "location.fill")
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                        .padding(.vertical, 15)
                        .padding(.horizontal, 15)
                        .background(Color.white)
                        .clipShape(Capsule())
                }
                .padding()
            }
        }
        .onAppear {
            if let location = mapModel.currentLocation {
                mapModel.setRegion(location: location, region: &region)
            }
        }
    }
}
