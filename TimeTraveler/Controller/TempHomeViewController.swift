//
//  TempHomeViewController.swift
//  TimeTraveler
//
//  Created by Heemo on 1/2/23.
//

import UIKit
import MapKit

class TempHomeViewController: SuperUIViewController {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let nestedGuideView = UIView()

    let imageContainerView = UIView()
    var imageView: UIImageView!
    var iconView: UIImageView!
    
    var titleLabel: UILabel!
    var categoryLabel: UILabel!
    var addressLabel: UILabel!
    var distanceLabel: UILabel!
    var bottomLabel: UILabel!
    
    let mapView = MKMapView()
    
    var didUpdateMapView = false
    var didUpdateImageView = false
    var fetchedLocationList = [Place]()
    var imageViewsList = [UIImage]()
    var locationManager: CLLocationManager!
    var currentLocation: LocationAnnotation!
//    let shared = UserService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initUI()
        setupScrollView()
        setupLayout()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        updateUI()
    }
}

private extension TempHomeViewController {
    func initUI() {
        imageView = {
           let imageView = UIImageView()
           imageView.translatesAutoresizingMaskIntoConstraints = false
           imageView.image = UIImage(named: "temp.jpeg")
           imageView.contentMode = .scaleToFill
           return imageView
        }()
        
        iconView = {
            let icon = UIImageView()
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.image = UIImage(systemName: "square.and.arrow.up.circle")
            return icon
        }()
        
        titleLabel = createLabel(with: "Rocky Mountains Testing for two lines here right now the right constraint is not working i dont know why it's not working!!!", size: 32, weight: .bold)
        categoryLabel = createLabel(with: "Category", size: 16, weight: .semibold)
        addressLabel = createLabel(with: "Address", size: 16, weight: .semibold)
        distanceLabel = createLabel(with: "Distance", size: 16, weight: .semibold)
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        nestedGuideView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(nestedGuideView)
        scrollView.addSubview(contentView)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        nestedGuideView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        nestedGuideView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        nestedGuideView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        nestedGuideView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
   
        contentView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor, constant: 40).isActive = true
        contentView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor, constant: -40).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -80).isActive = true
    }

    func setupLayout() {
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageContainerView)
        imageContainerView.addSubview(imageView)
        
        imageContainerView.centerXAnchor.constraint(equalTo: nestedGuideView.centerXAnchor).isActive = true
        imageContainerView.centerYAnchor.constraint(equalTo: nestedGuideView.centerYAnchor).isActive = true
        imageContainerView.widthAnchor.constraint(equalTo: nestedGuideView.heightAnchor, multiplier: 0.5).isActive = true
        imageContainerView.heightAnchor.constraint(equalTo: imageContainerView.widthAnchor).isActive = true
        
        imageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor).isActive = true
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(mapView)
        
        contentView.backgroundColor = .yellow
        
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        addressLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor,constant: 12).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        distanceLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 12).isActive = true
        distanceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        distanceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 24).isActive = true
        mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        contentView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 30).isActive = true
    }
    
    func configureUI() {
//        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2
        //        print(nestedGuideView.frame.height)
        //        imageContainerView.layer.cornerRadius = imageContainerView.frame.height / 2
        //        imageContainerView.layer.masksToBounds = true
        //        imageContainerView.layer.borderColor = UIColor.lightGray.cgColor
        //        imageContainerView.layer.borderWidth = 3
        //
    }
    
}
