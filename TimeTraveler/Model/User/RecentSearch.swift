//
//  RecentSearch.swift
//  TimeTraveler
//
//  Created by Heemo on 12/28/22.
//

import Foundation

class RecentSearch {
    var id: String
    var title: String
    var subTitle: String?
    
    init(id: String, title: String, subTitle: String?) {
        self.id = id
        self.title = title
        self.subTitle = subTitle ?? ""
        
    }
}
