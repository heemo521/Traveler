//
//  LocationCell.swift
//  TimeTraveler
//
//  Created by Heemo on 12/24/22.
//

import UIKit

class ResultCell: UITableViewCell {
    static let identifier = "ResultCell"
    static let rowHeight = CGFloat(200)
    static let backgroundColor: UIColor = .secondarySystemBackground
    
    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 3
        nameLabel.font = UIFont.systemFont(ofSize: CGFloat(20), weight: .bold)
        nameLabel.text = "Loading..."
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    let addressLabel: UILabel = {
        let addressLabel = UILabel()
        addressLabel.numberOfLines = 3
        addressLabel.text = ""
        addressLabel.font = UIFont.systemFont(ofSize: CGFloat(14), weight: .light)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        return addressLabel
    }()
    
    let mainImage: UIImageView = {
        let mainImage = UIImageView()
        mainImage.tintColor = .gray
        mainImage.image = UIImage(systemName: "doc.text.image")?.withRenderingMode(.alwaysTemplate)
        mainImage.layer.cornerRadius = 10.0
        mainImage.layer.masksToBounds = true
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        return mainImage
    }()
    
    let likeStatusImage: UIImageView = {
        let likeStatusImage = UIImageView()
        likeStatusImage.tintColor = UIColor.MyColor.hightlightColor
        likeStatusImage.image = UIImage()
        likeStatusImage.translatesAutoresizingMaskIntoConstraints = false
        return likeStatusImage
    }()
    
    let imageCover: UIView = {
        let imageCover = UIView()
        imageCover.translatesAutoresizingMaskIntoConstraints = false
        return imageCover
    }()
    
    
    func update(location: Place, index: Int) {
        if let imageUrl = location.imageUrls.first {
            mainImage.loadFrom(url: imageUrl, animation: true)
        } else {
            mainImage.image = UIImage(systemName: "doc.text.image")?.withRenderingMode(.alwaysTemplate)
        }
        
        nameLabel.text =  "\(index + 1). \(location.name!)"
        addressLabel.text = location.address?.formatted_address
        
        if let id = location.id, UserService.shared.checkLikedPlace(id: id) {
            let image = UIImage(systemName: "heart.circle")?.withRenderingMode(.alwaysTemplate)
            likeStatusImage.image = image
            likeStatusImage.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(mainImage)
        contentView.addSubview(imageCover)
        contentView.addSubview(likeStatusImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
        
        mainImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        mainImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        mainImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        mainImage.widthAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        
        imageCover.widthAnchor.constraint(equalTo: mainImage.widthAnchor).isActive = true
        imageCover.heightAnchor.constraint(equalTo: mainImage.heightAnchor).isActive = true
        imageCover.centerXAnchor.constraint(equalTo: mainImage.centerXAnchor).isActive = true
        imageCover.centerYAnchor.constraint(equalTo: mainImage.centerYAnchor).isActive = true
        
        likeStatusImage.leadingAnchor.constraint(equalTo: mainImage.trailingAnchor, constant: -50).isActive = true
        likeStatusImage.topAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: -50).isActive = true
        likeStatusImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        likeStatusImage.heightAnchor.constraint(equalTo: likeStatusImage.widthAnchor).isActive = true
        likeStatusImage.layer.cornerRadius = 20
        likeStatusImage.layer.masksToBounds = true
        
        nameLabel.topAnchor.constraint(equalTo: mainImage.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: mainImage.trailingAnchor, constant: 10).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
    }
}
