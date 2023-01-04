//
//  ExtendImageView.swift
//  TimeTraveler
//
//  Created by Heemo on 1/2/23.
//

import UIKit

extension UIImageView {
    func loadFrom(url: String) {
        guard let url = URL(string: url) else { return }
        // UPDATE THIS METHOD USIN URL SESSION TO avoid
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error!!! \(String(describing: error.localizedDescription))")
                return
            }
            if let imageData = data, let loadedImage = UIImage(data: imageData) {
                DispatchQueue.main.async { [weak self] in
                    self?.image = loadedImage

                    UIView.transition(with: self!, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        self?.isHidden = false
                    })
                }
            }
        }.resume()
    }
}
