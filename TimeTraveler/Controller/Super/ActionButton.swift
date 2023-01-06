//
//  ActionButton.swift
//  TimeTraveler
//
//  Created by Heemo on 1/2/23.
//

import UIKit

class ActionButton: UIButton {
    var action: (() -> Void)?
    
    func buttonIsClicked(do action: @escaping() -> Void) {
        self.action = action
        self.addTarget(self, action: #selector(ActionButton.clicked), for: .touchUpInside)
    }
    @objc func clicked() {
        action?()
    }
}
