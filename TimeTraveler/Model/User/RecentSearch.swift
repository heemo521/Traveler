//
//  RecentSearch.swift
//  TimeTraveler
//
//  Created by Heemo on 12/28/22.
//

import Foundation

class RecentSearch: Codable, Equatable, Hashable {
    var title: String
    var subTitle: String?

    func hash(into hasher: inout Hasher) {
        hasher.combine(title.hashValue)
    }
    static func == (lhs: RecentSearch, rhs: RecentSearch) -> Bool {
        return lhs.title == rhs.title 
    }
    
    init(title: String, subTitle: String?) {
        self.title = title
        self.subTitle = subTitle ?? ""
    }
}
