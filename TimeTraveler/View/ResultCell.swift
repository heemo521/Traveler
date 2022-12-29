//
//  LocationCell.swift
//  TimeTraveler
//
//  Created by Heemo on 12/24/22.
//

import UIKit

class ResultCell: UITableViewCell {
//    @IBOutlet weak var indexLabel: UILabel!
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var addressOneLabel: UILabel!
//    @IBOutlet weak var addressLabel: UILabel!
//    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabelButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var likeStatusImage: UIButton!
    
    func update(location: Place, index: Int) {
        indexLabel.text = "\(index + 1)"
        nameLabel.text = location.name
        categoryLabelButton.setTitle(location.categories?.first?.name, for: .normal)
        categoryLabelButton.isEnabled = false
        addressLabel.text = ""
//        mainImage.image = UIImage()
    }
}
