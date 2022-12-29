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
    
    func update(location: Place) {
        cellImageView.image = UIImage(systemName: "magnifyingglass")
        cellImageView.tintColor = UIColor.systemBlue
        nameLabel.text = location.name
        addressLabel.text = location.address?.formatted_address
    }
    func update(searchResult: MKLocalSearchCompletion) {
        cellImageView.image = UIImage(systemName: "mappin.and.ellipse")
        cellImageView.tintColor = UIColor.tintColor
        nameLabel.text = searchResult.title
        addressLabel.text = searchResult.subtitle
    }
}
