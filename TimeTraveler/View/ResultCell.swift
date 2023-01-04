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
        nameLabel.numberOfLines = 2
        nameLabel.font = UIFont.systemFont(ofSize: CGFloat(20), weight: .bold)
        nameLabel.text = "Loading..."
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    let addressLabel: UILabel = {
        let addressLabel = UILabel()
        addressLabel.numberOfLines = 2
        addressLabel.text = ""
        addressLabel.font = UIFont.systemFont(ofSize: CGFloat(14), weight: .light)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        return addressLabel
    }()
    
    let mainImage: UIImageView = {
        let mainImage = UIImageView()
        mainImage.image = UIImage(systemName: "doc.text.image")
        mainImage.layer.cornerRadius = 10.0
        mainImage.layer.masksToBounds = true
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        return mainImage
    }()
    
    let likeStatusImage: UIImageView = {
        let likeStatusImage = UIImageView()
        likeStatusImage.translatesAutoresizingMaskIntoConstraints = false
        return likeStatusImage
    }()
    
    func update(location: Place, index: Int) {
        if let imageUrl = location.imageUrl {
            mainImage.loadFrom(url: imageUrl)
        }
        nameLabel.text =  "\(index + 1). \(location.name!)"
        addressLabel.text = location.address?.formatted_address
        
        let id = location.id!
        let imageName = UserService.shared.checkLikedPlace(id: id) ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)?.withTintColor(.white, renderingMode: .alwaysTemplate)
        likeStatusImage.image = image
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
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: CGFloat(10), right: 0))
        
        mainImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        mainImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        mainImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10).isActive = true
        mainImage.widthAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        
        likeStatusImage.leadingAnchor.constraint(equalTo: mainImage.trailingAnchor, constant: -60).isActive = true
        likeStatusImage.topAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: -60).isActive = true
        likeStatusImage.widthAnchor.constraint(equalTo: mainImage.widthAnchor, multiplier: 0.25).isActive = true
        likeStatusImage.heightAnchor.constraint(equalTo: likeStatusImage.widthAnchor).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: mainImage.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: mainImage.trailingAnchor, constant: 10).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10).isActive = true
        
        addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        
    }
}
