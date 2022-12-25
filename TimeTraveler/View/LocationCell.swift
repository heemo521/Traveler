//
//  LocationCell.swift
//  TimeTraveler
//
//  Created by Heemo on 12/24/22.
//

import UIKit

class LocationCell: UITableViewCell {
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressOneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    
    func update(location: Location, index: Int) {
        indexLabel.text = "\(index + 1)"
        nameLabel.text = location.name
        addressOneLabel.text = ""
        addressLabel.text = ""
//        mainImage.image = UIImage()
    }
}
