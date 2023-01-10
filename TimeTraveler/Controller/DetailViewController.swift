//
//  DetailViewController.swift
//  TimeTraveler
//
//  Created by Heemo on 12/29/22.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    // MARK: Views
    let scrollView = UIScrollView()
    let contentView = UIView()
    var collectionView: UICollectionView!
    var nameLabel: UIButton! // used as label
    var categoryLabel: UILabel!
    var relatedPlaceLabel: UILabel!
    var addressLabel: UILabel!
    var categoryText: UITextView!
    var addressText: UITextView!
    var likeButton = UIButton()
    var modalCloseButton: UIButton!
    let mapView = MKMapView()
    var relatedPlaceContainer = UIView()
    var relatedPlaceText: UITextView!
    
    // MARK: State & Resources
    var selectedPlace: Place!
    var likedStatus: Bool? {
        didSet {
            likeButton.setNeedsUpdateConfiguration()
        }
    }
    let UserServiceShared = UserService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let id = selectedPlace.id!
        likedStatus = UserServiceShared.checkLikedPlace(id: id)
        initView()
        httpGetImageData(with: id)
        updateSelectedPlaceAndView()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    @objc private func likeButtonClicked() {
        let id = self.selectedPlace.id!
        self.UserServiceShared.toggleLike(id: id)
        likedStatus = UserServiceShared.checkLikedPlace(id: selectedPlace.id!)
    }
    
    @objc private func modalCloseButtonClicked() {
        self.dismiss(animated: true)
    }
    
    func updateSelectedPlaceAndView() {
        let place = selectedPlace!
        let name = place.name ?? "Name is not available"
        let category = place.categories?.first?.name ?? ""
        let address = place.address?.formatted_address ?? ""
        updateContent(name: name, address: address, category: category)

        if let coords = place.geocodes?.main {
            let coordinate = CLLocationCoordinate2D(latitude: coords.latitude, longitude: coords.longitude)
            locateDesinationOnTheMap(name: name, coordinate: coordinate)
        }
    }
}
// MARK: - UI
private extension DetailViewController {
    func initView() {
        initUI()
        setupSubviews()
        setupLayout()
    }
    func createRelatedPlaceButton(id: String, name: String, index: Int) -> UIButton {
        var config = UIButton.Configuration.gray()
        config.title = name
        config.buttonSize = .mini
        config.baseForegroundColor = .white
        config.baseBackgroundColor = index % 2 == 0 ? .systemPurple : .systemTeal
        let relatedPlaceButton = UIButton(configuration: config)
        relatedPlaceButton.isUserInteractionEnabled = false
        relatedPlaceButton.isHighlighted = true
        return relatedPlaceButton
    }
    
    func initUI() {
        view.backgroundColor = UIColor.MyColor.primaryBackground
        contentView.backgroundColor = UIColor.MyColor.secondaryBackground
    
        relatedPlaceContainer.translatesAutoresizingMaskIntoConstraints = false
       
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
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
            collectionView.backgroundColor = UIColor.MyColor.secondaryBackground
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
        }()
        
        nameLabel = {
            let nameLabel = UIButton()
            nameLabel.configureButton(configuration: .filled(), title: "", buttonSize: .large)
            
            let transformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.boldSystemFont(ofSize: 24)
                return outgoing
            }
            var config = nameLabel.configuration
            config?.titleTextAttributesTransformer = transformer
            config?.titleAlignment = .trailing
            config?.baseForegroundColor = .white
            config?.baseBackgroundColor = .systemPurple
            config?.buttonSize = .large
            config?.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            nameLabel.configuration = config
            nameLabel.isUserInteractionEnabled = false
            nameLabel.isHighlighted = true
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            return nameLabel
        }()

        categoryLabel = {
            let categoryLabel = UILabel()
            categoryLabel.configureLabel(with: "Category", fontSize: 24, weight: .semibold)
            categoryLabel.translatesAutoresizingMaskIntoConstraints = false
            return categoryLabel
        }()
        
        addressLabel = {
            let addressLabel = UILabel()
            addressLabel.configureLabel(with: "Address", fontSize: 24, weight: .semibold)
            addressLabel.translatesAutoresizingMaskIntoConstraints = false
            return addressLabel
        }()
        
        relatedPlaceLabel = {
            let relatedPlaceLabel = UILabel()
            relatedPlaceLabel.configureLabel(with: "Related Place", fontSize: 24, weight: .semibold)
            relatedPlaceLabel.translatesAutoresizingMaskIntoConstraints = false
            return relatedPlaceLabel
        }()
        
        categoryText = {
            let categoryText = UITextView()
            categoryText.configureNonEditableTextView(text: "None", fontSize: 17, weight: .semibold)
            categoryText.translatesAutoresizingMaskIntoConstraints = false
            return categoryText
        }()

        addressText = {
            let addressText = UITextView()
            addressText.configureNonEditableTextView(text: "Not available", fontSize: 17, weight: .semibold)
            addressText.translatesAutoresizingMaskIntoConstraints = false
            return addressText
        }()
        
        relatedPlaceText = {
            let relatedPlaceText = UITextView()
            relatedPlaceText.configureNonEditableTextView(text: "None", fontSize: 17, weight: .semibold)
            relatedPlaceText.translatesAutoresizingMaskIntoConstraints = false
            return relatedPlaceText
        }()
        
        likeButton = {
            let UIAction = UIAction { _ in
                self.likeButtonClicked()
            }
            let likeButton = UIButton(primaryAction: UIAction)
            likeButton.configureButton(configuration: .filled(), title: "Like", image: UIImage(), buttonSize: .medium)
            likeButton.configuration?.background.backgroundColor = UIColor.MyColor.hightlightColor
            likeButton.configurationUpdateHandler = {
                [unowned self] button in
                var config = button.configuration
                config?.image = self.likedStatus! ? UIImage(systemName: "bolt.heart") : UIImage(systemName: "heart.fill")
                config?.title = self.likedStatus! ? "Liked" : "Like"
                button.configuration = config
            }
            likeButton.translatesAutoresizingMaskIntoConstraints = false
            return likeButton
        }()
        
        modalCloseButton = {
            let UIAction = UIAction { _ in
                self.modalCloseButtonClicked()
            }
            let modalCloseButton = UIButton(primaryAction: UIAction)
            modalCloseButton.configureButton(configuration: .plain(), title: "", image: UIImage(systemName: "arrow.backward.circle.fill")!, buttonSize: .large)
            modalCloseButton.configuration?.baseForegroundColor = UIColor.MyColor.hightlightColor
            modalCloseButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            modalCloseButton.translatesAutoresizingMaskIntoConstraints = false
            return modalCloseButton
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
        view.addSubview(modalCloseButton)
        
        modalCloseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        modalCloseButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        
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
    }
    
    func updateContent(name: String, address: String, category: String) {
        nameLabel.configuration?.title = name
        categoryText.text = category
        addressText.text = address
    }
}

private extension DetailViewController {
    func httpGetImageData(with locationID: String) {
        let request = HTTPRequest.buildRequest(for: "get", with: [:], from: "/\(locationID)/photos")!
        
        HTTPRequest.makeRequest(for: "get image details", request: request, onCompletion: { data in
            do {
                let decoder = JSONDecoder()
                let dataDecoded = try decoder.decode([Image].self, from: data)
            
                if dataDecoded.count > 0 {
                    self.selectedPlace.imageUrls = []
                    var imageWidth: String!
                    var imageHeight: String!
                    DispatchQueue.main.async {
                        imageWidth = "\(Int(self.collectionView.frame.width) * 2)"
                        imageHeight = "\(Int(self.collectionView.frame.height) * 2)"
                    }
                    
                    for (index, image) in dataDecoded.enumerated() {
                        let imageUrl = "\(image.prefix!)\(imageWidth ?? "600")x\(imageHeight ?? "1000")\(image.suffix!)"
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
        cell.backgroundColor = UIColor.MyColor.secondaryBackground
        if selectedPlace.imageUrls.count > 0 {
            let imageUrl = selectedPlace.imageUrls[indexPath.row]
            cell.imageView.loadFrom(url: imageUrl, animation: true)
        } else {
            cell.imageView.image = UIImage(systemName: "doc.text.image")?.withRenderingMode(.alwaysTemplate)
        }
        return cell
    }
}


// MARK: MAP
private extension DetailViewController {
    func locateDesinationOnTheMap(name: String, coordinate: CLLocationCoordinate2D) {
        let annotation = LocationAnnotation(title: name, coordinate: coordinate)
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: true)
    }
}
