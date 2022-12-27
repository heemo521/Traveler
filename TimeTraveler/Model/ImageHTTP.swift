//
//  ImageHTTP.swift
//  TimeTraveler
//
//  Created by Heemo on 12/26/22.
//

import Foundation

class ImageHTTP: NSObject, Decodable {
    var id: String?
    var createdAt: String?
    var prefix: String?
    var suffix: String?
    var width: Int?
    var height: Int?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case prefix = "prefix"
        case suffix = "suffix"
        case width = "width"
        case height = "height"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        prefix = try container.decodeIfPresent(String.self, forKey: .prefix)
        suffix = try container.decodeIfPresent(String.self, forKey: .suffix)
        width = try container.decodeIfPresent(Int.self, forKey: .width)
        height = try container.decodeIfPresent(Int.self, forKey: .height)

    }
}
