//
//  SuperUIViewController.swift
//  TimeTraveler
//
//  Created by Heemo on 1/2/23.
//

import UIKit

class HTTPRequest {
    static let shared = HTTPRequest()
    
    private init() {}
    
    func buildRequest(for method: String, with parameters: [String: String], from path: String) -> URLRequest? {
        //Build URL
        let urlComponents = NSURLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.foursquare.com"
        urlComponents.path = "/v3/places\(path)"
        urlComponents.queryItems = parameters.map({ URLQueryItem(name: $0.key, value: $0.value)})
        
        //Final URL
        guard let finalUrl = urlComponents.url else { return nil }
        
        //Build Request
        var request = URLRequest(url: finalUrl, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        let header = [
            "accept": "application.json",
            "Authorization": Bundle.main.infoDictionary!["API_KEY"] as! String
        ]
        request.httpMethod = method.uppercased()
        request.allHTTPHeaderFields = header
        
        return request
    }
    
    func makeRequest(for requestType: String,  request: URLRequest, onCompletion callback: @escaping (Data) -> ()) {
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error for \(requestType) request \(String(describing: error.localizedDescription))")
                return
            }
            
            if let res = response as? HTTPURLResponse {
                print("response for \(requestType) statuscode: \(res.statusCode)")
            }
            
            guard let data = data else {
                print("Failed to receive data for \(requestType)")
                return
            }
            
            callback(data)
            
        }.resume()
    }
}
