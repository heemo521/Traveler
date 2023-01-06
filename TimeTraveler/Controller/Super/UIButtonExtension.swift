//
//  UIButtonExtension.swift
//  TimeTraveler
//
//  Created by Heemo on 1/5/23.
//

import UIKit

extension UIButton {
    func configure(title: String, image: UIImage, padding: CGFloat, corner: CGFloat) {
        self.setTitle(title, for: .normal)
        self.setImage(image, for: .normal)
        self.configuration = UIButton.Configuration.gray()
        self.layer.cornerRadius = corner
        self.configuration?.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
    }
}
