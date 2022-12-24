//
//  Response.swift
//  TimeTraveler
//
//  Created by Heemo on 12/24/22.
//

import Foundation

class Response: NSObject, Decodable {
    let results: [Location]
}
