//
//  LocationCell.swift
//  TimeTraveler
//
//  Created by Heemo on 12/24/22.
//

import UIKit

class ResultCell: UITableViewCell {
    static let identifier = "ResultCell"
    
    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Loading..."
        return nameLabel
    }()
    
    let addressLabel: UILabel = {
        let addressLabel = UILabel()
        addressLabel.numberOfLines = 2
        addressLabel.text = ""
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        return addressLabel
    }()
    
    let mainImage: UIImageView = {
        let mainImage = UIImageView()
        mainImage.image = UIImage(systemName: "doc.text.image")
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        mainImage.layer.cornerRadius = 10.0
        return mainImage
    }()
    
    let likeStatusImage: UIImageView = {
        let likeStatusImage = UIImageView()
        likeStatusImage.translatesAutoresizingMaskIntoConstraints = false
        return likeStatusImage
    }()
    
    func update(location: Place, index: Int) {
        if let imageData = location.imageData {
            //get url as argument and update it here using loadFrom
//            mainImage.loadFrom(url: <#T##String#>)
            mainImage.image = UIImage(data: imageData)
        }
        nameLabel.text =  "\(index + 1). \(location.name!)"
        addressLabel.text = location.address?.formatted_address
        
        let id = location.id!
        let imageName = UserService.shared.checkLikedPlace(id: id) ? "heart.fill" : "heart"
        likeStatusImage.image = UIImage(systemName: imageName)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(mainImage)
        contentView.addSubview(likeStatusImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
