//
//  Coordinate.swift
//  TimeTraveler
//
//  Created by Heemo on 1/8/23.
//

import Foundation

class Coordinate: Decodable, Encodable {
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double = 41.8781, longitude: Double = -87.6298) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
