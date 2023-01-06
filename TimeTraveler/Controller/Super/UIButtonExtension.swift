//
//  UIButtonExtension.swift
//  TimeTraveler
//
//  Created by Heemo on 1/5/23.
//

import UIKit

extension UIButton {
    func configure(title: String, image: UIImage! = nil, padding: CGFloat, configuration: UIButton.Configuration) {
        self.configuration = configuration
        self.configuration?.title = title
        self.configuration?.imagePadding = 10
        self.configuration?.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding + 8.0, bottom: padding, trailing: padding + 8.0)
        if let image = image {
            self.configuration?.image = image
        }
    }
}
