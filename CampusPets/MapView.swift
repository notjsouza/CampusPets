//
//  MapView.swift
//  CampusPets
//
//  Created by Justin Souza on 6/24/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @Binding var region: MKCoordinateRegion
    
    @EnvironmentObject var mapModel: MapModel
    @EnvironmentObject private var entryService: EntryService
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region,
                annotationItems: mapModel.annotations) { entry in
                MapAnnotation(coordinate: CLLocationCoordinate2D(
                    latitude: entry.latitude ?? 0,
                    longitude: entry.longitude ?? 0
                )) {
                    if let imageName = entry.image {
                        RemoteImage(name: imageName)
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                )
                            .shadow(radius: 3)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
