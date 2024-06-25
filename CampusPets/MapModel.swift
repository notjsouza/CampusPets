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
    var locationManager: CLLocationManager
    @Published var currentLocation: CLLocation?
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DispatchQueue.main.async {
                self.currentLocation = location
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location with error \(error.localizedDescription)")
    }
    
    func setRegion(location: CLLocation, region: inout MKCoordinateRegion) {
        region.center = CLLocationCoordinate2D(
            latitude: round(location.coordinate.latitude * 10000) / 10000,
            longitude: round(location.coordinate.longitude * 10000) / 10000
        )
    }
}
