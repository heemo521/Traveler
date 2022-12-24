//
//  Location.swift
//  TimeTraveler
//
//  Created by Heemo on 12/24/22.
//

import Foundation

class Location: NSObject, Decodable {
    var id: String?
    var name: String?
    var link: String?
//    var address: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "fsq_id"
        case name = "name"
        case link = "link"
//        case address = "formatted_address"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        link = try container.decodeIfPresent(String.self, forKey: .link)
//        address = try container.decodeIfPresent(String.self, forKey: .address)

    }
}
