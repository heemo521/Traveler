//
//  SearchCell.swift
//  TimeTraveler
//
//  Created by Heemo on 12/27/22.
//

import UIKit
import MapKit

class SearchCell: UITableViewCell {
    static let identifier = "SearchCell"
    
    let cellImageView = UIImageView()
    let nameLabel = UILabel()
    let addressLabel = UILabel()
    
    func update(location: RecentSearch) {
        cellImageView.image = UIImage(systemName: "magnifyingglass")
        cellImageView.tintColor = UIColor.systemBlue
        nameLabel.text = location.title
        addressLabel.text = location.subTitle
    }
    func update(searchResult: MKLocalSearchCompletion) {
        cellImageView.image = UIImage(systemName: "mappin.and.ellipse")
        cellImageView.tintColor = UIColor.tintColor
        nameLabel.text = searchResult.title
        addressLabel.text = searchResult.subtitle
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .orange
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
