//
//  User.swift
//  TimeTraveler
//
//  Created by Heemo on 12/26/22.
//

import Foundation

class User: Codable {
    var likedLocations = Set<LikedLocation>()
    var recentSearch = Set<RecentSearch>()
    var lastLocation = Coordinate()
}
