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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var likeStatusImage: UIButton!
    
    func update(location: Place, index: Int) {
        if let imageData = location.imageData {
            mainImage.image = UIImage(data: imageData)
        }
        nameLabel.text =  "\(index + 1). \(location.name!)"
        addressLabel.text = location.address?.formatted_address
    }

}
