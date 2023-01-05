//
//  ImageCell.swift
//  TimeTraveler
//
//  Created by Heemo on 1/4/23.
//

import UIKit

class ImageCell: UICollectionViewCell {
    static let identifier = "ImageCell"
    
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleToFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
    }
}
