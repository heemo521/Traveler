//
//  requestHTTP.swift
//  TimeTraveler
//
//  Created by Heemo on 12/24/22.
//

import Foundation

struct buildURLRequest {

    static func getRequest(query: [String], parameters: [String: String]) {
        
        //Build URL
        let urlComponents = NSURLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.foursquare.com"
        urlComponents.path = "/v3/places/search"
        urlComponents.queryItems = parameters.map({ URLQueryItem(name: $0.key, value: $0.value)})
        
        //Final URL
        guard let finalUrl = urlComponents.url else { return }
        print(finalUrl)
    }
    
}
