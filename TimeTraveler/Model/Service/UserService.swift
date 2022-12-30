//
//  UserService.swift
//  TimeTraveler
//
//  Created by Heemo on 12/26/22.
//

import Foundation

class UserService {
    static let shared = UserService()
    
    private var user = User()
    
    private var url: URL
    
    private init() {
        url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        url.append(path: "userData.json")
        loadUserData()
    }
    
    func loadUserData() {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let decodeData = try decoder.decode(User.self, from: data)
            user = decodeData
        } catch {
            print("error from loading data \(error.localizedDescription)")
        }
    }
    
    func saveUserData() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(user)
            try data.write(to: url)
        } catch {
            print("error from saving data \(error.localizedDescription)")
        }
    }
    
    func likeAPlace(id: String) {
        user.likedLocations.insert(id)
    }

    func unlikeAPlace(id: String) {
        user.likedLocations.remove(id)
    }
    
    func getNumberOfLikedPlaces() -> Int{
        return user.likedLocations.count
    }
    
    func getAllLikedPlaces() ->[String] {
        return Array(user.likedLocations)
    }
    
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
}
