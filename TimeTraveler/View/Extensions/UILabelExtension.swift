//
//  LabelExtension.swift
//  TimeTraveler
//
//  Created by Heemo on 1/8/23.
//

import UIKit

extension UILabel {
    func configureLabel(with labelText: String, fontSize: Int, weight: UIFont.Weight, numberOfLines: Int = 1) {
        self.text = labelText
        self.font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: weight)
        self.numberOfLines = numberOfLines
    }
}
