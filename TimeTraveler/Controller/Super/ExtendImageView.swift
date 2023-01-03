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
        do {
            let imageData = try Data(contentsOf: url)
            if let loadedImage = UIImage(data: imageData) {
                DispatchQueue.main.async { [weak self] in
                    self?.image = loadedImage
                    UIView.transition(with: self!, duration: 1.0, options: .transitionCrossDissolve, animations: {
                        self?.isHidden = false
                    })
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
