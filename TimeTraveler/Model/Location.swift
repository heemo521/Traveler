//
//  Location.swift
//  TimeTraveler
//
//  Created by Heemo on 12/24/22.
//

import Foundation

class Location: Codable {
    let id: String
    let name: String
    let address: String
    
    init(id: String, name: String, address: String){
        self.id = id
        self.name = name
        self.address = address
    }
}
