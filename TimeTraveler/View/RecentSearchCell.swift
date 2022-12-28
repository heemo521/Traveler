//
//  RecentSearchCell.swift
//  TimeTraveler
//
//  Created by Heemo on 12/27/22.
//

import UIKit
import MapKit

class RecentSearchCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    func update(location: Location) {
//        cellImageView.image = UIImage()
        nameLabel.text = location.name
        addressLabel.text = location.address?.formatted_address
    }
    func update(searchResult: MKLocalSearchCompletion) {
        nameLabel.text = searchResult.title
        addressLabel.text = searchResult.subtitle
    }
}
