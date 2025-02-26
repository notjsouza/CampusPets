//
//  MapModel.swift
//  CampusPets
//
//  Created by Justin Souza on 6/24/24.
//

import Foundation
import MapKit
import CoreLocation
import Combine

class MapModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentLocation: CLLocation?
    @Published var annotations: [Entry] = []
    @Published var region = MKCoordinateRegion()
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
//        forEach(entry : ) {
//            self.annotations.append(entry)
//        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        
    }
    
    func setRegion(location: CLLocation, region: inout MKCoordinateRegion) {
        region.center = CLLocationCoordinate2D(
            latitude: round(location.coordinate.latitude * 10000) / 10000,
            longitude: round(location.coordinate.longitude * 10000) / 10000
        )
    }
    
    func addAnnotation(_ entry: Entry) {
        DispatchQueue.main.async {
            self.annotations.append(entry)
        }
    }
}

