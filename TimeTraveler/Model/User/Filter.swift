//
//  UserPreference.swift
//  TimeTraveler
//
//  Created by Heemo on 12/26/22.
//

import Foundation
// For user settings / preference
class Filter {
    var categories = [Categories]()
    var searchRadius: Int?
    var useUserLocation: Bool
//    var limit: 10 15 25 50
    //sortBy = relevance, rating, distance enum
    
    init(searchRadius: Int, useUserLocation: Bool) {
        self.searchRadius = searchRadius
        self.useUserLocation = useUserLocation
    }
    
    // add category
    // remove category
    
    // update radius
}
