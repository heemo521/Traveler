//
//  LocationService.swift
//  TimeTraveler
//
//  Created by Heemo on 12/28/22.
//

import Foundation

class PlaceService {
    static let shared = PlaceService()
    
    private var fetchedLocations = [Place]()
    
    private init() {}
}
