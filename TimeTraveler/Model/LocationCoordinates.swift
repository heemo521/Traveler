//
//  LocationCoordinates.swift
//  TimeTraveler
//
//  Created by Heemo on 12/27/22.
//

import Foundation
import MapKit

class LocationCoordinates: Codable {
    let name: String
    let latitude: Double
    let longitude: Double
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(placemark: MKPlacemark) {
        self.name = placemark.name ?? ""
        self.latitude = placemark.coordinate.latitude
        self.longitude = placemark.coordinate.longitude
    }
}
