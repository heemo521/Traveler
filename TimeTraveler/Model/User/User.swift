//
//  User.swift
//  TimeTraveler
//
//  Created by Heemo on 12/26/22.
//

import Foundation

typealias LocationId = String
typealias SearchQuery = String

class User {
    var likedLocations = [LocationId]()
    var recentSearch = [RecentSearch]()
//    var userFilter = Filter(searchRadius: 0, useUserLocation: <#Bool#>)
//    var userLocation = LocationCoordinates
}
