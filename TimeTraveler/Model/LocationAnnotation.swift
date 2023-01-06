//
//  LocationAnnotation.swift
//  TimeTraveler
//
//  Created by Heemo on 12/27/22.
//

import Foundation
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
