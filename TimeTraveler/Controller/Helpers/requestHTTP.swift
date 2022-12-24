//
//  requestHTTP.swift
//  TimeTraveler
//
//  Created by Heemo on 12/24/22.
//

import Foundation

class buildURLRequest {
    static let shared = requestHTTP()
    
    func makeRequest(query: [String]) {
        print(query.first!)
    }
    
}
