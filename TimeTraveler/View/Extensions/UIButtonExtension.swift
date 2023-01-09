//
//  UIButtonExtension.swift
//  TimeTraveler
//
//  Created by Heemo on 1/5/23.
//

import UIKit

extension UIButton {
    func configureButton(configuration: UIButton.Configuration, title: String, image: UIImage! = nil, buttonSize: UIButton.Configuration.Size, topBottomPadding: CGFloat = 0, sidePadding: CGFloat = 0) {
        var config = configuration
        config.title = title
        config.buttonSize = buttonSize
        if topBottomPadding != 0, sidePadding != 0 {
            config.contentInsets = NSDirectionalEdgeInsets(top: topBottomPadding, leading: sidePadding, bottom: topBottomPadding, trailing: sidePadding)
        }
        if let image = image {
            config.image = image
            config.imagePadding = 10
        }
        self.configuration = config
    }
}
