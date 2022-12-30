//
//  Location.swift
//  TimeTraveler
//
//  Created by Heemo on 12/24/22.
//

import Foundation



//Renmae the class to Place instead of location
class Place: NSObject, Decodable {
    var id: String?
    var name: String?
    var link: String?
    var categories: [Category]?
    var geocodes: Geocode?
    var address: Address?
    var imageData: Data?
    //  var relatedPlaces: [String]? // an object containing parent and child
    // Example:
    //    parent = Los Angeles International Airport
    //    children = Terminal 1, Terminal 2, Terminal 3...

    enum CodingKeys: String, CodingKey {
        case id = "fsq_id"
        case name = "name"
        case link = "link"
        case categories = "categories"
        case geocodes = "geocodes"
        case address = "location"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        link = try container.decodeIfPresent(String.self, forKey: .link)
        categories = try container.decodeIfPresent([Category].self, forKey: .categories)
        geocodes = try container.decodeIfPresent(Geocode.self, forKey: .geocodes)
        address = try container.decodeIfPresent(Address.self, forKey: .address)

    }
}

class Address: Decodable {
    var formatted_address: String?
    var locality: String?
    var region: String?
}

class Geocode: Decodable {
    var main: Coordinates?
    var roof: Coordinates?
}

class Coordinates: Decodable {
    var latitude: Double?
    var longitude: Double?
}

class Category: Decodable {
    var id: Int?
    var name: String?
    var icon: Icon?
}

class Icon: Decodable {
    var prefix: String?
    var suffix: String?
}
