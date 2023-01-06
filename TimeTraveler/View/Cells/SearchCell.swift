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
    static let rowHeight = CGFloat(120)
    static let backgroundColor: UIColor = .secondarySystemBackground
    
    let cellImageView: UIImageView = {
        let cellImageView = UIImageView()
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        return cellImageView
    }()
    
    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 2
        nameLabel.font = UIFont.systemFont(ofSize: CGFloat(20), weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    let addressLabel: UILabel = {
        let addressLabel = UILabel()
        addressLabel.font = UIFont.systemFont(ofSize: CGFloat(14), weight: .light)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        return addressLabel
    }()
    
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
        contentView.addSubview(cellImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(addressLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
      
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        
        cellImageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        cellImageView.heightAnchor.constraint(equalTo: cellImageView.widthAnchor).isActive = true
  
        cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        cellImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        nameLabel.topAnchor.constraint(equalTo: cellImageView.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: 30).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true

        addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
    }
}
