//
//  requestHTTP.swift
//  TimeTraveler
//
//  Created by Heemo on 12/24/22.
//

import Foundation

enum Categories: String {
    case building = "16007"
    case forest = "16015"
    case historic = "16020"
    case mountain = "16027"
    case nationalPark = "16034"
    case naturalPark = "16035"
}

struct buildURLRequest {

    static func build(for method: String, with parameters: [String: String]) -> URLRequest? {
        
        //Build URL
        let urlComponents = NSURLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.foursquare.com"
        urlComponents.path = "/v3/places/search"
        urlComponents.queryItems = parameters.map({ URLQueryItem(name: $0.key, value: $0.value)})
        
        //Final URL
        guard let finalUrl = urlComponents.url else { return nil }
        print(finalUrl)
        
        var request = URLRequest(url: finalUrl, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        let header = [
            "accept": "application.json",
            "Authorization": Bundle.main.infoDictionary!["API_KEY"] as! String
        ]
        request.httpMethod = method.uppercased()
        request.allHTTPHeaderFields = header
        return request
    }
    
}
