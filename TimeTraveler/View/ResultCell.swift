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
    @IBOutlet weak var likeStatusImage: UIImageView!
    
    func update(location: Place, index: Int) {
        mainImage.layer.cornerRadius = 10.0
        if let imageData = location.imageData {
            mainImage.image = UIImage(data: imageData)
        }
        nameLabel.text =  "\(index + 1). \(location.name!)"
        addressLabel.text = location.address?.formatted_address
        let id = location.id!
        
        if UserService.shared.checkLikedPlace(id: id) {
            likeStatusImage.image = UIImage(systemName: "heart.fill")
        } else {
            likeStatusImage.image = UIImage(systemName: "heart")
        }
    }

}
