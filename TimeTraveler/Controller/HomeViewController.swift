//
//  HomeViewController.swift
//  TimeTraveler
//
//  Created by Heemo on 12/25/22.
//

import UIKit
import MapKit
import CoreLocation


// [] - Refactor & Final Clean up
// [] - OPT: Liked Page using resultview and detail view

// [x] - Fetch correct image size based on the imageview's frame width & height
// [x] - Searchbar style
// [x] - Draw direction to the place and display distance
// [x] - texts and labels
// [x] - Clean up transition animations
// [x] - Remove the heart from the first page
// [x] - User last location saved
// [x] - Make sure for correct rendering data (image)
// [x] - Put icon on the left corner
// [x] - like button on the right corner
// [x] - animation clean up


class HomeViewController: SuperUIViewController {
    // MARK: Navigation
    var searchButton: ActionButton!
    
    // MARK: Views
    let scrollView = UIScrollView()
    let contentView = UIView()
    let guideView = UIView()

    var imageContainerView: UIView!
    var imageView: UIImageView!
    var iconView: UIImageView!
    var likeButton: ActionButton!
    
    var nameLabel: UILabel!
    var categoryLabel: UILabel!
    var categoryText: UITextView!
    var addressLabel: UILabel!
    var addressText: UITextView!
    var distanceLabel: UILabel!
    var distanceText: UITextView!
    
    let mapView = MKMapView()
    
    // MARK: State
    var didUpdateMapView = false
    var locationRadiusInMeters = 5000.0
    var placesAPIList = [Place]()
    var locationManager: CLLocationManager!
    var currentLocation: LocationAnnotation!
    let shared = UserService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        initNavigationBar()
        initUI()
        setupScrollView()
        setupLayout()
        locationManagerInit()
        
        mapView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scalingAnimation()
        if let first = placesAPIList.first {
            let heartType = shared.checkLikedPlace(id: first.id!) ? "heart.fill" : "heart"
            likeButton.setImage(UIImage(systemName: heartType), for: .normal)
        }
    }
    
    // MARK: - Device Orientation Update
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        scalingAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scalingAnimation()
    }
}

// MARK: Navigation
private extension HomeViewController {
    func initNavigationBar() {
        
        searchButton = {
            let searchBtn = ActionButton()
            let image = UIImage(systemName: "magnifyingglass")
            searchBtn.configure(title: "Search destination", image: image!, padding: 5.0, configuration: .gray())
            searchBtn.buttonIsClicked(do: searchButtonClicked)
            return searchBtn
        }()
        
        navigationItem.titleView = searchButton
    }
    
    @objc private func searchButtonClicked() {
        let SearchVC = SearchViewController()
        SearchVC.modalPresentationStyle = .fullScreen
        self.navigationController?.modalTransitionStyle = .flipHorizontal
        self.navigationController?.pushViewController(SearchVC, animated: true)
    }
    
    @objc private func didTapLikeButton() {
        if let first = placesAPIList.first, let id = first.id {
            if shared.checkLikedPlace(id: id) {
                shared.unlikeAPlace(id: id)
                likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            } else {
                shared.likeAPlace(id: id)
                likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
        }
    }
    
    @objc private func imageViewClicked() {
        let DetailVC = DetailViewController()
        DetailVC.selectedPlace = placesAPIList.first
        DetailVC.modalTransitionStyle = .flipHorizontal
        DetailVC.modalPresentationStyle = .fullScreen
        self.present(DetailVC, animated: true)
    }
}

// MARK: - UI
private extension HomeViewController {
    func initUI() {
        view.backgroundColor = .white
        
        imageContainerView = {
            let imageContainerView = UIView()
            imageContainerView.backgroundColor = .systemBlue
            imageContainerView.layer.borderWidth = 3
            imageContainerView.layer.borderColor = UIColor.gray.cgColor
            imageContainerView.translatesAutoresizingMaskIntoConstraints = false
            return imageContainerView
        }()
        
        imageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "doc.text.image")
            imageView.contentMode = .scaleToFill
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.imageViewClicked))
            gesture.numberOfTapsRequired = 1
            imageView.addGestureRecognizer(gesture)
            imageView.isUserInteractionEnabled = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
           return imageView
        }()
    
        iconView = {
            let icon = UIImageView()
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.widthAnchor.constraint(equalToConstant: 50).isActive = true
            icon.heightAnchor.constraint(equalToConstant: 50).isActive = true
            icon.layer.cornerRadius = 25
            icon.clipsToBounds = true
            icon.layer.borderColor = UIColor.white.cgColor
            icon.layer.borderWidth = 3
            icon.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            return icon
        }()
        
        likeButton = {
            let likeButton = ActionButton()
            let image = UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate)
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .white
            likeButton.translatesAutoresizingMaskIntoConstraints = false
            likeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
            likeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            likeButton.layer.cornerRadius = 25
            likeButton.clipsToBounds = true
            likeButton.layer.borderColor = UIColor.white.cgColor
            likeButton.layer.borderWidth = 3
            likeButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            likeButton.buttonIsClicked(do: didTapLikeButton)
            
            return likeButton
        }()
        
        nameLabel = {
            let nameLabel = createLabel(with: "Loading...", size: 32, weight: .bold)
            nameLabel.numberOfLines = 2
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            return nameLabel
        }()
        categoryLabel = {
            let categoryLabel = createLabel(with: "Category", size: 16, weight: .semibold)
            categoryLabel.translatesAutoresizingMaskIntoConstraints = false
            return categoryLabel
        }()
        categoryText = {
            let categoryText = UITextView()
            categoryText.isEditable = false
            categoryText.isScrollEnabled = false
            categoryText.textAlignment = .left
            categoryText.font = UIFont.boldSystemFont(ofSize: 12)
            categoryText.text = "..."
            categoryText.translatesAutoresizingMaskIntoConstraints = false
            return categoryText
        }()
        
        addressLabel = {
            let addressLabel = createLabel(with: "Address", size: 16, weight: .semibold)
            addressLabel.translatesAutoresizingMaskIntoConstraints = false
            return addressLabel
        }()
        addressText = {
            let addressText = UITextView()
            addressText.isEditable = false
            addressText.isScrollEnabled = false
            addressText.textAlignment = .left
            addressText.font = UIFont.boldSystemFont(ofSize: 12)
            addressText.text = "..."
            addressText.translatesAutoresizingMaskIntoConstraints = false
            return addressText
        }()
        distanceLabel = {
            let distanceLabel = createLabel(with: "Distance", size: 16, weight: .semibold)
            distanceLabel.translatesAutoresizingMaskIntoConstraints = false
            return distanceLabel
        }()
        distanceText = {
            let distanceText = UITextView()
            distanceText.isEditable = false
            distanceText.isScrollEnabled = false
            distanceText.textAlignment = .left
            distanceText.font = UIFont.boldSystemFont(ofSize: 12)
            distanceText.text = "..."
            distanceText.translatesAutoresizingMaskIntoConstraints = false
            return distanceText
        }()
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        guideView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(guideView)
        scrollView.addSubview(contentView)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        guideView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        guideView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        guideView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        guideView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        
        contentView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor, constant: 40).isActive = true
        contentView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor, constant: -40).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -80).isActive = true
    }

    func setupLayout() {
        contentView.addSubview(imageContainerView)
        imageContainerView.addSubview(imageView)
        imageView.addSubview(iconView)
        imageView.addSubview(likeButton)
        
        imageContainerView.centerXAnchor.constraint(equalTo: guideView.centerXAnchor).isActive = true
        imageContainerView.centerYAnchor.constraint(equalTo: guideView.centerYAnchor).isActive = true
        imageContainerView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        imageContainerView.heightAnchor.constraint(equalTo: imageContainerView.widthAnchor).isActive = true
        imageContainerView.layer.cornerRadius = 150
        imageContainerView.clipsToBounds = true
        
        imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor).isActive = true
        
        iconView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 20).isActive = true
        iconView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        likeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -20).isActive = true
        likeButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(categoryText)
        contentView.addSubview(addressLabel)
        contentView.addSubview(addressText)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(distanceText)
        contentView.addSubview(mapView)
        
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        categoryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12).isActive = true
        categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        categoryText.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 2).isActive = true
        categoryText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        categoryText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        addressLabel.topAnchor.constraint(equalTo: categoryText.bottomAnchor,constant: 12).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        addressText.topAnchor.constraint(equalTo: addressLabel.bottomAnchor,constant: 2).isActive = true
        addressText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        addressText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        distanceLabel.topAnchor.constraint(equalTo: addressText.bottomAnchor, constant: 12).isActive = true
        distanceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        distanceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        distanceText.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 2).isActive = true
        distanceText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        distanceText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: distanceText.bottomAnchor, constant: 24).isActive = true
        mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        contentView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 30).isActive = true
    }
    
    func updateContent(with selectedLocation: Place) {
        nameLabel.text = selectedLocation.name
        categoryText.text = selectedLocation.categories?.first?.name
        addressText.text = selectedLocation.address!.formatted_address!
        
        if let id = selectedLocation.id {
            if shared.checkLikedPlace(id: id) {
                likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
        
        if let geocodes = selectedLocation.geocodes, let lat = geocodes.main?.latitude, let lng = geocodes.main?.longitude {
            let userLocation = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            let desinationLocation = CLLocation(latitude: lat, longitude: lng)
            let distance = userLocation.distance(from: desinationLocation)  * 0.000621371
            distanceText.text = "\(String(format: "%.2f", distance)) mi"
            
            updateMapViewWithCoordinates(lat: lat, lng: lng)
        }
    }
    
    func scalingAnimation() {
        if UIDevice.current.orientation.isLandscape {
            UIView.animate(withDuration: 0.6, animations: {
                self.imageContainerView.transform = CGAffineTransform.identity
            }, completion: { _ in
                UIView.animate(withDuration: 0.6, animations: {
                    self.imageContainerView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                })
            })
        } else {
            UIView.animate(withDuration: 0.6, animations: {
                self.imageContainerView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            }, completion: { _ in
                UIView.animate(withDuration: 0.6, animations: {
                     self.imageContainerView.transform = CGAffineTransform.identity
                })
            })
        }
    }
}

// MARK: - HTTP
private extension HomeViewController {
    func getLocationDataHTTP() {
        let defaultFields = "fsq_id,name,geocodes,location,categories,related_places,link"
        
        let (lat, lng) = shared.getLastUserLocation()
        let ll = "\(lat),\(lng)"
        
        let queryItems = ["query": "outdoor", "limit": "1", "range": String(Int(locationRadiusInMeters)), "ll" : ll, "categories": "16000", "fields": defaultFields, "sort": "distance"]
        
        let request = buildRequest(for: "get", with: queryItems, from: "/search")!
        
        makeRequest(for: "data request type", request: request, onCompletion: { data in
            do {
                let decoder = JSONDecoder()
                let dataDecoded = try decoder.decode(Response.self, from: data)
                self.placesAPIList = dataDecoded.results
                
                if let id = dataDecoded.results.first!.id {
                    self.getImageDetailsHTTP(with: id)
                }
                
                if let iconURLs = dataDecoded.results.first?.categories?.first?.icon, let prefix = iconURLs.prefix, let suffix = iconURLs.suffix {
                    let url = prefix + "64" + suffix
                    self.iconView.loadFrom(url: url)
                }
                
                DispatchQueue.main.async {
                    self.updateContent(with: dataDecoded.results.first!)
                }
            } catch let error {
                // Error when there is no response or data returned from API
                print("\(String(describing: error.localizedDescription))")
            }
        })
    }
    
    // MARK: - Fetch image url using the ids of locations from func httpRequest()
    func getImageDetailsHTTP(with locationID: String) {
        let request = buildRequest(for: "get", with: [:], from: "/\(locationID)/photos")!
        
        makeRequest(for: "get image details", request: request, onCompletion: { data in
            do {
                let decoder = JSONDecoder()
                let dataDecoded = try decoder.decode([Image].self, from: data)
                if dataDecoded.count > 0 {
                    var imageHeight: String!
                    var imageWidth: String!
                    
                    DispatchQueue.main.async {
                        imageHeight = "\(Int(self.imageView.frame.height * 2))"
                        imageWidth = "\(Int(self.imageView.frame.width * 2))"
                    }
                    
                    for (index, image) in dataDecoded.enumerated() {
                        let imageUrl = "\(image.prefix!)\(imageHeight ?? "600")x\(imageWidth ?? "600")\(image.suffix!)"
                        self.placesAPIList[0].imageUrls.append(imageUrl)
                        if index == 0 {
                            self.imageView.loadFrom(url: imageUrl)
                        }
                    }
                    
                }
            } catch let error {
                print("\(String(describing: error.localizedDescription))")
            }
        })
    }
}

// MARK: - Core Location
extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManagerInit() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 20.0 // meters
        locationManager.requestWhenInUseAuthorization()
        
        // When user launches the app after authorizing the status
        var authorizationStatus: CLAuthorizationStatus?
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            // CLLocationManager.authorizatoinStatus() deprecated from iOS 14
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        switch authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                nameLabel.text = "Finding the nearest outdoor place!"
                locationManager.startUpdatingLocation()
            case .restricted, .denied:
                print("Location use restricted")
                nameLabel.text = "Location use restricted, accessing last location"
                self.getLocationDataHTTP()
            default:
                print("Not authorized yet")
                nameLabel.text = "Location use not authorized, accessing last location"
                self.getLocationDataHTTP()
        }
    }
    // First time when user starts the app / user allows the authorization
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        shared.saveLastUserLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.getLocationDataHTTP()
        
        let coord = location.coordinate
        let locationCoord = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
        currentLocation = LocationAnnotation(title: "Current Location", coordinate: locationCoord)
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - Map
extension HomeViewController: MKMapViewDelegate {
    func updateMapViewWithCoordinates(lat: Double, lng: Double) {
        let destinationCoord = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        mapView.addAnnotation(currentLocation)
        mapView.addAnnotation(LocationAnnotation(title: (placesAPIList.first?.name)!, coordinate: destinationCoord))
        displayRoute(destination: destinationCoord)
    
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.systemPurple
        renderer.lineWidth = 3.0
        return renderer
    }
    
    func displayRoute(destination: CLLocationCoordinate2D) {
        let sourcePlaceMark = MKPlacemark(coordinate: self.currentLocation.coordinate)
        let destinationPlaceMark = MKPlacemark(coordinate: destination)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate() {(response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let response = response {
                let route = response.routes.first!
                self.mapView.addOverlay(route.polyline, level: .aboveLabels)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 25.0, left: 25.0, bottom: 25.0, right: 25.0), animated: true)
            }
        }
    }
}
