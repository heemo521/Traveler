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
    var recentSearch = [SearchQuery]()
    var userPreference = UserPreference(searchRadius: 0)
}