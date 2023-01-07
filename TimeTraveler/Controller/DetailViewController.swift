//
//  DetailViewController.swift
//  TimeTraveler
//
//  Created by Heemo on 12/29/22.
//

// [] Refactor & Final Clean up

import UIKit
import MapKit

class DetailViewController: SuperUIViewController {
    // MARK: Views
    var collectionView: UICollectionView!
    let scrollView = UIScrollView()
    let contentView = UIView()
    var nameLabel: UIButton!
    var categoryLabel: UILabel!
    var categoryText: UITextView!
    var addressLabel: UILabel!
    var addressText: UITextView!
    var relatedPlaceLabel: UILabel!
    var relatedPlaceContainer = UIView()
    var relatedPlaceText: UITextView!
    let mapView = MKMapView()
    var likeButton = UIButton()
    var dismissButton: UIButton!
    
    // MARK: State
    var selectedPlace: Place!
    let shared = UserService.shared
    var likedStatus: Bool? {
        didSet {
            likeButton.setNeedsUpdateConfiguration()
        }
    }
    
    var mainBackgroundColor: UIColor = .systemBackground
    var contentBackgroundColor: UIColor = .tertiarySystemBackground
    var hightlightColor: UIColor = .systemPurple
    
    override func viewDidLoad() {
        super.viewDidLoad()
        likedStatus = shared.checkLikedPlace(id: selectedPlace.id!)
    
        initUI()
        setupSubviews()
        setupLayout()
        
        getImageDetailsHTTP(with: selectedPlace.id!)
        locateDesinationOnTheMap()
        collectionView.dataSource = self
        collectionView.delegate = self
        scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        likeButton.setImage(UIImage(systemName: shared.checkLikedPlace(id: selectedPlace.id!) ? "heart.fill" : "heart"), for: .normal)
    }

    
    @objc private func likeButtonClicked() {
        let id = self.selectedPlace.id!
        self.shared.toggleLike(id: id)
        likedStatus = shared.checkLikedPlace(id: selectedPlace.id!)
    }
}
// MARK: - UI
private extension DetailViewController {
    func createRelatedPlaceButton(id: String, name: String, index: Int) -> UIButton {
        let action = UIAction(handler: {_ in
            self.reloadPlaceData(id: id, name: name)
        })
        var config = UIButton.Configuration.gray()
        config.title = name
        config.buttonSize = .mini
        config.baseForegroundColor = .white
        config.baseBackgroundColor = index % 2 == 0 ? .systemPurple : .systemTeal
        let relatedPlaceButton = ActionButton(configuration: config, primaryAction: action)
        return relatedPlaceButton
    }
    
    func initUI() {
        view.backgroundColor = mainBackgroundColor
        contentView.backgroundColor = contentBackgroundColor
        
        
        collectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            let size = UIScreen.main.bounds
            layout.itemSize = CGSize(width: size.width, height: 500)
            layout.scrollDirection = .horizontal
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.isPagingEnabled = true
            collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
            collectionView.alwaysBounceVertical = false
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.backgroundColor = .secondarySystemBackground
            return collectionView
        }()
        
        nameLabel = {
            var configuration = UIButton.Configuration.filled()
            configuration.title =  selectedPlace.name

            let transformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.boldSystemFont(ofSize: 24)
                return outgoing
            }
            configuration.titleTextAttributesTransformer = transformer
            configuration.titleAlignment = .trailing
            configuration.baseForegroundColor = .white
            configuration.baseBackgroundColor = .systemPurple
            
            configuration.buttonSize = .large
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            let nameLabel = UIButton(configuration: configuration)
            nameLabel.isUserInteractionEnabled = false
            nameLabel.isHighlighted = true
            return nameLabel
        }()

        
        categoryLabel = createLabel(with: "Category", size: 24, weight: .semibold)
        addressLabel = createLabel(with: "Address", size: 24, weight: .semibold)
        relatedPlaceLabel = createLabel(with: "Related Places", size: 24, weight: .semibold)
        
        categoryText = {
            let categoryText = UITextView()
            categoryText.isEditable = false
            categoryText.isScrollEnabled = false
            categoryText.textAlignment = .left
            categoryText.font = UIFont.boldSystemFont(ofSize: 17)
            if let category = selectedPlace.categories?.first?.name {
                categoryText.text = category
            } else {
                categoryText.text = "None"
            }
            categoryText.backgroundColor = contentBackgroundColor
            categoryText.translatesAutoresizingMaskIntoConstraints = false
            return categoryText
        }()

        addressText = {
            let addressText = UITextView()
            addressText.isEditable = false
            addressText.isScrollEnabled = false
            addressText.textAlignment = .left
            addressText.font = UIFont.boldSystemFont(ofSize: 17)
            if let address = selectedPlace.address?.formatted_address {
                addressText.text = address
            } else {
                addressText.text = "Not available"
            }
            addressText.backgroundColor = contentBackgroundColor
            addressText.translatesAutoresizingMaskIntoConstraints = false
            return addressText
        }()
        
        relatedPlaceText = {
            let relatedPlaceText = UITextView()
            relatedPlaceText.isEditable = false
            relatedPlaceText.isScrollEnabled = false
            relatedPlaceText.textAlignment = .left
            relatedPlaceText.font = UIFont.boldSystemFont(ofSize: 17)
            relatedPlaceText.text = "None"
            relatedPlaceText.backgroundColor = contentBackgroundColor
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
            configuration.background.backgroundColor = hightlightColor
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
            dismissButton.configuration?.baseForegroundColor = hightlightColor
            dismissButton.configurationUpdateHandler = {
                button in
                var config = button.configuration
                config?.title = button.isHighlighted ? "" : "Back"
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
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
       
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        contentView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
        
    }
    
    func setupLayout() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        relatedPlaceLabel.translatesAutoresizingMaskIntoConstraints = false
        relatedPlaceContainer.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(collectionView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(categoryText)
        contentView.addSubview(addressLabel)
        contentView.addSubview(addressText)
        contentView.addSubview(relatedPlaceLabel)
        contentView.addSubview(relatedPlaceContainer)

        contentView.addSubview(mapView)
        contentView.addSubview(likeButton)
        view.addSubview(dismissButton)
    
        collectionView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo:contentView.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 500).isActive = true

        nameLabel.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -40).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: -12).isActive = true
        nameLabel.widthAnchor.constraint(lessThanOrEqualTo: collectionView.widthAnchor, multiplier: 0.7).isActive = true
        
        categoryLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 30).isActive = true
        categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30).isActive = true
        categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
        
        categoryText.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 6).isActive = true
        categoryText.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor).isActive = true
        categoryText.trailingAnchor.constraint(equalTo: categoryLabel.trailingAnchor).isActive = true
        
        addressLabel.topAnchor.constraint(equalTo: categoryText.bottomAnchor, constant: 30).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: categoryLabel.trailingAnchor).isActive = true
        
        addressText.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 6).isActive = true
        addressText.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor).isActive = true
        addressText.trailingAnchor.constraint(equalTo: categoryLabel.trailingAnchor).isActive = true
        
        mapView.topAnchor.constraint(equalTo: addressText.bottomAnchor, constant: 30).isActive = true
        mapView.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: categoryLabel.trailingAnchor).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        relatedPlaceLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 30).isActive = true
        relatedPlaceLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor).isActive = true
        relatedPlaceLabel.trailingAnchor.constraint(equalTo: categoryLabel.trailingAnchor).isActive = true
        
        var lastButton: UIButton!
        
        if let related = selectedPlace.relatedPlaces, let relatedPlaces = related.children, relatedPlaces.count > 0 {
            
            for (index, place) in relatedPlaces.enumerated() {
                let relatedPlaceButton = createRelatedPlaceButton(id: place.fsq_id, name: place.name, index: index)
                relatedPlaceButton.translatesAutoresizingMaskIntoConstraints = false
                relatedPlaceContainer.addSubview(relatedPlaceButton)
                if index == 0 {
                    relatedPlaceButton.topAnchor.constraint(equalTo: relatedPlaceContainer.topAnchor).isActive = true
                    relatedPlaceButton.leadingAnchor.constraint(equalTo: relatedPlaceContainer.leadingAnchor).isActive = true
                } else {
                    relatedPlaceButton.topAnchor.constraint(equalTo: lastButton.bottomAnchor, constant: 5).isActive = true
                    relatedPlaceButton.leadingAnchor.constraint(equalTo: lastButton.leadingAnchor).isActive = true
                }
                lastButton = relatedPlaceButton
            }
        } else {
            relatedPlaceContainer.addSubview(relatedPlaceText)
            relatedPlaceText.topAnchor.constraint(equalTo: relatedPlaceLabel.bottomAnchor, constant: 6).isActive = true
            relatedPlaceText.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor).isActive = true
            relatedPlaceText.trailingAnchor.constraint(equalTo: categoryLabel.trailingAnchor).isActive = true
        }
        
        relatedPlaceContainer.topAnchor.constraint(equalTo: relatedPlaceLabel.bottomAnchor, constant: 6).isActive = true
        relatedPlaceContainer.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor).isActive = true
        relatedPlaceContainer.trailingAnchor.constraint(equalTo: categoryLabel.trailingAnchor).isActive = true
        relatedPlaceContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 10).isActive = true
        
        if let lastButton = lastButton {
            contentView.bottomAnchor.constraint(equalTo: lastButton.bottomAnchor, constant: 100).isActive = true
        } else {
            contentView.bottomAnchor.constraint(equalTo: relatedPlaceText.bottomAnchor, constant: 100).isActive = true
        }
        
        likeButton.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor).isActive = true
        likeButton.trailingAnchor.constraint(equalTo: categoryLabel.trailingAnchor).isActive = true
        
        dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
}

private extension DetailViewController {
    func getImageDetailsHTTP(with locationID: String) {
        let request = buildRequest(for: "get", with: [:], from: "/\(locationID)/photos")!
        
        makeRequest(for: "get image details", request: request, onCompletion: { data in
            do {
                let decoder = JSONDecoder()
                let dataDecoded = try decoder.decode([Image].self, from: data)
            
                if dataDecoded.count > 0 {
                    self.selectedPlace.imageUrls = []
                    var width: String!
                    var height: String!
                    DispatchQueue.main.async {
                        width = "\(Int(self.collectionView.frame.width) * 2)"
                        height = "\(Int(self.collectionView.frame.height) * 2)"
                    }
                    
                    for (index, image) in dataDecoded.enumerated() {
                        let imageUrl = "\(image.prefix!)\(width ?? "600")x\(height ?? "1000")\(image.suffix!)"
                        self.selectedPlace.imageUrls.append(imageUrl)
                        
                        DispatchQueue.main.async {
                            let indexPath = IndexPath(row: index, section: 0)
                            self.collectionView.reloadItems(at: [indexPath])
                        }
                    }
                }
                
            }
            catch let error {
                print("\(String(describing: error.localizedDescription))")
            }
        })
    }
    
    func reloadPlaceData(id: String, name: String) {
        print(id)
        print(name)
    }
}

// MARK: - ScrollDelegate
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

// MARK: CollectionView Delegate
extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            self.nameLabel.isHidden = true
        } else {
            UIView.transition(with: self.nameLabel, duration: 1, options: .transitionCrossDissolve, animations: {
                self.nameLabel.isHidden = false
            })
        }
    }
}


// MARK: CollectionView Data Source
extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = selectedPlace.imageUrls.count
        return count != 0 ? count : 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
        cell.backgroundColor = contentBackgroundColor
        if selectedPlace.imageUrls.count > 0 {
            let imageUrl = selectedPlace.imageUrls[indexPath.row]
            cell.imageView.loadFrom(url: imageUrl)
        } else {
            cell.imageView.image = UIImage(systemName: "doc.text.image")?.withRenderingMode(.alwaysTemplate).withTintColor(.systemPurple)
        }
        
        return cell
    }
}


// MARK: MAP
private extension DetailViewController {
    func locateDesinationOnTheMap() {
        let coords = selectedPlace.geocodes?.main
        if let lat = coords?.latitude, let lng = coords?.longitude {
            let annotation = LocationAnnotation(title: selectedPlace.name ?? "", coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng))
            let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
            mapView.addAnnotation(annotation)
            mapView.setRegion(region, animated: true)
        }
    }
}
