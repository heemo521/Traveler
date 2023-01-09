//
//  UIButtonExtension.swift
//  TimeTraveler
//
//  Created by Heemo on 1/5/23.
//

import UIKit

extension UIButton {
    func configure(title: String, image: UIImage! = nil, padding: CGFloat, configuration: UIButton.Configuration) {
        var config = configuration
        if let image = image {
            config.image = image
            config.imagePadding = 10
        }
        config.title = title
        config.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding + 8.0, bottom: padding, trailing: padding + 8.0)
        self.configuration = config
    }
}
