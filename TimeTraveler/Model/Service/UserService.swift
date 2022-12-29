//
//  UserService.swift
//  TimeTraveler
//
//  Created by Heemo on 12/26/22.
//

import Foundation

class UserService {
    static let shared = UserService()
    
    private let user = User()
    
    private init() {}
    
    //likeLocation
    
    //unLikeLocation
    
    //addToRecent Search
    func addRecentSearch(recentSearch: RecentSearch) {
        print("adding recent search \(recentSearch.title)")
        user.recentSearch.insert(recentSearch)
    }
    //delete recent search
    func removeRecentSearch(recentSearch: RecentSearch) {
        print("removing recent search \(recentSearch.title)")
        user.recentSearch.remove(recentSearch)
    }
    
    func getAllRecentSearch() -> [RecentSearch] {
        return Array(user.recentSearch)
    }
    
    func numberOfRecentSearch() -> Int {
        return user.recentSearch.count
    }
    //delete all recent search
    
}
