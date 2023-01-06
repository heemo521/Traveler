//
//  DetailViewController.swift
//  TimeTraveler
//
//  Created by Heemo on 12/29/22.
//

// [] - Refactor & Final Clean up
// [] Render with the initial lower quality image, then fetch the image again for the correct screen size 
// [] show pagination 
// [] change the scroll/content view to a slidable modal instead
// [] implement coordinates to the map
// [] make the buttons change in color when clicked onto
// [] Placd the name label on top of the image
// [x] swipable images


import UIKit
import MapKit

class DetailViewController: SuperUIViewController {
    var selectedPlace: Place!
    let shared = UserService.shared
    
    var collectionView: UICollectionView!
    var mainImageView: UIImageView!
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    var nameLabel: UILabel!
    var categoryLabel: UILabel!
    var categoryText: UITextView!
    var addressLabel: UILabel!
    var addressText: UITextView!
    var relatedPlaceLabel: UILabel!
    var relatedPlaceText: UITextView!
    
    let mapView = MKMapView()
    
    var likeButton = UIButton()
    var dismissButton: UIButton!
    
    var likedStatus: Bool? {
        didSet {
            likeButton.setNeedsUpdateConfiguration()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        likedStatus = shared.checkLikedPlace(id: selectedPlace.id!)
        
        initUI()
        setupSubviews()
        setupLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        scrollView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        likeButton.setImage(UIImage(systemName: shared.checkLikedPlace(id: selectedPlace.id!) ? "heart.fill" : "heart"), for: .normal)
    }
}

private extension DetailViewController {
    @objc private func likeButtonClicked() {
        let id = self.selectedPlace.id!
        self.shared.toggleLike(id: id)
        likedStatus = shared.checkLikedPlace(id: selectedPlace.id!)
    }
    
    func initUI() {
        view.backgroundColor = .white
        
        likedStatus = shared.checkLikedPlace(id: selectedPlace.id!)
        
        collectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            let size = UIScreen.main.bounds
            layout.itemSize = CGSize(width: size.width, height: size.height * 0.6)
            layout.scrollDirection = .horizontal
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.isPagingEnabled = true
            collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
            collectionView.alwaysBounceVertical = false
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
        }()
        
        nameLabel = createLabel(with: selectedPlace.name!, size: 30, weight: .bold)
        nameLabel.layer.cornerRadius = 10.0
        
        categoryLabel = createLabel(with: "Category", size: 16, weight: .semibold)
        addressLabel = createLabel(with: "Address", size: 16, weight: .semibold)
        relatedPlaceLabel = createLabel(with: "Related Place", size: 16, weight: .semibold)
        
        categoryText = {
            let categoryText = UITextView()
            categoryText.isEditable = false
            categoryText.isScrollEnabled = false
            categoryText.textAlignment = .left
            categoryText.font = UIFont.boldSystemFont(ofSize: 12)
            if let category = selectedPlace.categories?.first?.name {
                categoryText.text = category
            } else {
                categoryText.text = "Loading"
            }
            categoryText.translatesAutoresizingMaskIntoConstraints = false
            return categoryText
        }()
        
        addressText = {
            let addressText = UITextView()
            addressText.isEditable = false
            addressText.isScrollEnabled = false
            addressText.textAlignment = .left
            addressText.font = UIFont.boldSystemFont(ofSize: 12)
            if let address = selectedPlace.address?.formatted_address {
                addressText.text = address
            } else {
                addressText.text = "Not available"
            }
            addressText.translatesAutoresizingMaskIntoConstraints = false
            return addressText
        }()
        relatedPlaceText = {
            let relatedPlaceText = UITextView()
            relatedPlaceText.isEditable = false
            relatedPlaceText.isScrollEnabled = false
            relatedPlaceText.textAlignment = .left
            relatedPlaceText.font = UIFont.boldSystemFont(ofSize: 12)
            relatedPlaceText.text = "None"
//            if false {
//                relatedPlaceText.text = selectedPlace.address?.formatted_address // change here
//            } else {
//                relatedPlaceText.text = "None"
//            }
            relatedPlaceText.translatesAutoresizingMaskIntoConstraints = false
            return relatedPlaceText
        }()
        likeButton = {
            let likeButton = ActionButton()
            likeButton.buttonIsClicked(do: likeButtonClicked)
            var configuration = UIButton.Configuration.filled()
            configuration.buttonSize = .medium
            configuration.title = "Like"
            configuration.image = UIImage(systemName: "heart")
            configuration.background.backgroundColor = .purple
            likeButton.configuration = configuration
            likeButton.configurationUpdateHandler = {
                [unowned self] button in
                var config = button.configuration
                config?.image = self.likedStatus! ? UIImage(systemName: "heart") : UIImage(systemName: "heart.fill")
                button.configuration = config
            }
            
            likeButton.translatesAutoresizingMaskIntoConstraints = false
            return likeButton
        }()
        dismissButton = {
            let dismissButton = ActionButton()
            dismissButton.configure(title: "Dismiss", padding: 10, configuration: .gray())
            dismissButton.configuration?.buttonSize = .large
            dismissButton.configuration?.baseForegroundColor = .purple
            dismissButton.configurationUpdateHandler = {
                button in
                var config = button.configuration
                config?.title = button.isHighlighted ? "" : "Dismiss"
                config?.image = button.isHighlighted ? UIImage(systemName: "xmark.circle") : UIImage()
                button.configuration = config
            }
            dismissButton.buttonIsClicked {
                self.dismiss(animated: true)
            }
            dismissButton.translatesAutoresizingMaskIntoConstraints = false
            return dismissButton
        }()
    }
    
    func setupSubviews() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: CGFloat(0.6)).isActive = true
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        contentView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor, constant: 40).isActive = true
        contentView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor, constant: -40).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 35).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -80).isActive = true

    }
    
    func setupLayout() {
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        relatedPlaceLabel.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
//        contentView.addSubview(nameLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(categoryText)
        contentView.addSubview(addressLabel)
        contentView.addSubview(addressText)
        contentView.addSubview(relatedPlaceLabel)
        contentView.addSubview(relatedPlaceText)
        contentView.addSubview(mapView)
        contentView.addSubview(likeButton)
        view.addSubview(dismissButton)
        
        categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        categoryText.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10).isActive = true
        categoryText.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor).isActive = true
        addressLabel.topAnchor.constraint(equalTo: categoryText.bottomAnchor, constant: 30).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: categoryText.leadingAnchor).isActive = true
        addressText.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10).isActive = true
        addressText.leadingAnchor.constraint(equalTo: addressLabel.leadingAnchor).isActive = true
        relatedPlaceLabel.topAnchor.constraint(equalTo: addressText.bottomAnchor, constant: 30).isActive = true
        relatedPlaceLabel.leadingAnchor.constraint(equalTo: addressText.leadingAnchor).isActive = true
        relatedPlaceText.topAnchor.constraint(equalTo: relatedPlaceLabel.bottomAnchor, constant: 10).isActive = true
        relatedPlaceText.leadingAnchor.constraint(equalTo: relatedPlaceLabel.leadingAnchor).isActive = true
        
        mapView.topAnchor.constraint(equalTo: relatedPlaceText.bottomAnchor, constant: 50).isActive = true
        mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        contentView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 50).isActive = true
        
        likeButton.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor).isActive = true
        likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        UIView.transition(with: self.dismissButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.dismissButton.isHidden = true
        })
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        UIView.transition(with: self.dismissButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.dismissButton.isHidden = false
        })
    }
}

extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected a picture")
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedPlace.imageUrls.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
        let imageUrl = selectedPlace.imageUrls[indexPath.row]
        cell.imageView.loadFrom(url: imageUrl)
        
        return cell
    }
}

