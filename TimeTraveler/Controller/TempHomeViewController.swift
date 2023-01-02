//
//  TempHomeViewController.swift
//  TimeTraveler
//
//  Created by Heemo on 1/2/23.
//

import UIKit

class TempHomeViewController: UIViewController {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let nestedGuideView = UIView()
    
    // navigationcontroller
        // LikeButton
        // User button
    // image
    let imageContainerView = UIView()
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "temp.jpeg")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    // icon with background
    
    // title label
    // address label
    // distance label
    
    // mapkit

    override func viewDidLoad() {
        super.viewDidLoad()
//        overrideUserInterfaceStyle = .light
        view.backgroundColor = .white
        
        setupScrollView()
        setupLayout()
    }
}

private extension TempHomeViewController {
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        nestedGuideView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(nestedGuideView)
        scrollView.addSubview(contentView)

        view.addSubview(scrollView)
     
        
        nestedGuideView.backgroundColor = .yellow
        

        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        nestedGuideView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        nestedGuideView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        nestedGuideView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        nestedGuideView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
 
        contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 300).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 1200).isActive = true
    }
    
    func setupLayout() {
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageContainerView)
        imageContainerView.addSubview(imageView)
        
        imageContainerView.centerXAnchor.constraint(equalTo: nestedGuideView.centerXAnchor).isActive = true
        imageContainerView.centerYAnchor.constraint(equalTo: nestedGuideView.centerYAnchor).isActive = true
        imageContainerView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        imageContainerView.heightAnchor.constraint(equalTo: imageContainerView.widthAnchor).isActive = true
        imageContainerView.layer.cornerRadius = imageContainerView.frame.width / 2
        imageContainerView.clipsToBounds = true
        imageContainerView.layer.borderColor = UIColor.lightGray.cgColor
        imageContainerView.layer.borderWidth = 3
        
        imageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor).isActive = true
        
        
        
        let bottomLabel = UILabel()
        bottomLabel.text = "bottom"
        contentView.addSubview(bottomLabel)
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10).isActive = true
    }
}
