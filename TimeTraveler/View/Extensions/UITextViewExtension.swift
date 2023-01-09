//
//  UITextViewExtension.swift
//  TimeTraveler
//
//  Created by Heemo on 1/8/23.
//

import UIKit

extension UITextView {
    func configureNonEditableTextView(text: String, fontSize: CGFloat, weight: UIFont.Weight, bgColor: UIColor = UIColor.MyColor.secondaryBackground, aligntment: NSTextAlignment = .left) {
        self.text = text
        self.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        self.backgroundColor = UIColor.MyColor.secondaryBackground
        self.isEditable = false
        self.isScrollEnabled = false
        self.textAlignment = aligntment
    }
}
