//
//  LocationAnnotation.swift
//  TimeTraveler
//
//  Created by Heemo on 12/27/22.
//

import Foundation
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
