//
//  User.swift
//  TimeTraveler
//
//  Created by Heemo on 12/26/22.
//

import Foundation


class User: Decodable, Encodable {
    var likedLocations = Set<String>()
    var recentSearch = Set<RecentSearch>()
    var userFilter = Filter()
    var lastLocation = Coordinates()
}
