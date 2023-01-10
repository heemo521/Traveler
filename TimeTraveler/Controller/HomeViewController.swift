//
//  HomeViewController.swift
//  TimeTraveler
//
//  Created by Heemo on 12/25/22.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController {
    // MARK: Navigation
    var searchButton: UIButton!
    
    // MARK: Views
    let scrollView = UIScrollView()
    var contentView = UIView()
    let guideView = UIView()
    var imageContainerView: UIView!
    var imageView: UIImageView!
    var nameLabel: UILabel!
    var categoryLabel: UILabel!
    var addressLabel: UILabel!
    var distanceLabel: UILabel!
    var categoryText: UITextView!
    var addressText: UITextView!
    var distanceText: UITextView!
    let mapView = MKMapView()
    
    // MARK: State & Resources
    var selectedPlace: Place!
    var locationRadiusInMeters = 10000.0
    
    var locationManager: CLLocationManager!
    let shared = UserService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        initView()
        initLocationManager()
        mapView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scalingAnimation()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        scalingAnimation()
    }
}

// MARK: Navigation
private extension HomeViewController {
    func initNavigationBar() {
        searchButton = {
            let UIAction = UIAction { _ in
                self.searchButtonClicked()
            }
            let searchBtn = UIButton(primaryAction: UIAction)
            let image = UIImage(systemName: "magnifyingglass")
            searchBtn.configureButton(configuration: .gray(), title: "Search destination", image: image!, buttonSize: .medium, topBottomPadding: 5.0, sidePadding: 13.0)
            searchBtn.configuration?.baseForegroundColor = UIColor.MyColor.hightlightColor
            return searchBtn
        }()
        navigationItem.titleView = searchButton
    }
    
    @objc private func searchButtonClicked() {
        let SearchVC = SearchViewController()
        self.navigationController?.pushViewController(SearchVC, animated: true)
    }
    
    @objc private func imageViewClicked() {
        if let selectedPlace = selectedPlace {
            scalingAnimation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                let DetailVC = DetailViewController()
                DetailVC.selectedPlace = selectedPlace
                DetailVC.modalTransitionStyle = .flipHorizontal
                DetailVC.modalPresentationStyle = .fullScreen
                self.present(DetailVC, animated: true)
            })
        }
    }
}

// MARK: - UI / View
private extension HomeViewController {
    func initView() {
        initUI()
        setupScrollView()
        setupLayout()
    }
    
    func initUI() {
        view.backgroundColor = UIColor.MyColor.primaryBackground
        
        scrollView.backgroundColor = UIColor.MyColor.secondaryBackground
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        guideView.translatesAutoresizingMaskIntoConstraints = false
        
        imageContainerView = {
            let imageContainerView = UIView()
            imageContainerView.backgroundColor = UIColor.MyColor.tertiaryBackground
            imageContainerView.layer.borderWidth = 10
            imageContainerView.layer.borderColor = UIColor.MyColor.hightlightColor.cgColor
            imageContainerView.layer.cornerRadius = 150
            imageContainerView.clipsToBounds = true
            imageContainerView.translatesAutoresizingMaskIntoConstraints = false
            return imageContainerView
        }()
        
        imageView = {
            let imageView = UIImageView()
            imageView.image = UIImage()
            imageView.contentMode = .scaleToFill
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.imageViewClicked))
            gesture.numberOfTapsRequired = 1
            imageView.addGestureRecognizer(gesture)
            imageView.isUserInteractionEnabled = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
           return imageView
        }()
    
        nameLabel = {
            let nameLabel = UILabel()
            nameLabel.configureLabel(with: "Loading...", fontSize: 32, weight: .bold)
            nameLabel.numberOfLines = 2
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
        
        distanceLabel = {
            let distanceLabel = UILabel()
            distanceLabel.configureLabel(with: "Distance", fontSize: 24, weight: .semibold)
            distanceLabel.translatesAutoresizingMaskIntoConstraints = false
            return distanceLabel
        }()
        
        categoryText = {
            let categoryText = UITextView()
            categoryText.configureNonEditableTextView(text: "...", fontSize: 17, weight: .semibold)
            categoryText.translatesAutoresizingMaskIntoConstraints = false
            return categoryText
        }()
        
        addressText = {
            let addressText = UITextView()
            addressText.configureNonEditableTextView(text: "...", fontSize: 17, weight: .semibold)
            addressText.translatesAutoresizingMaskIntoConstraints = false
            return addressText
        }()
        
        distanceText = {
            let distanceText = UITextView()
            distanceText.configureNonEditableTextView(text: "...", fontSize: 17, weight: .semibold)
            distanceText.translatesAutoresizingMaskIntoConstraints = false
            return distanceText
        }()
    }
    
    func setupScrollView() {
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
        
        imageContainerView.centerXAnchor.constraint(equalTo: guideView.centerXAnchor).isActive = true
        imageContainerView.centerYAnchor.constraint(equalTo: guideView.centerYAnchor).isActive = true
        imageContainerView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        imageContainerView.heightAnchor.constraint(equalTo: imageContainerView.widthAnchor).isActive = true
        
        imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor).isActive = true
        
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
    
    func updateContent(name: String, category: String = "None", address: String = "", distance: String = "") {
        nameLabel.text = name
        categoryText.text = category
        addressText.text = address
    }
    
    func updateDistance(distance: String) {
        distanceText.text = distance
    }
    
    func updateImage(url: String = "") {
        if url == "" {
            imageView.image = UIImage(systemName: "x.circle")
        } else {
            imageView.loadFrom(url: url, animation: true)
        }
    }
}

// MARK: - HTTP
private extension HomeViewController {
    func httpGetPlacesData() {
        let defaultFields = "fsq_id,name,geocodes,location,categories,related_places,link"
        let (userLat, userLng) = shared.getLastUserLocation()
        let ll = "\(userLat),\(userLng)"
        let queryItems = ["query": "outdoor", "limit": "1", "range": String(Int(locationRadiusInMeters)), "ll" : ll, "categories": "16000", "fields": defaultFields, "sort": "distance"]
        
        let request = HTTPRequest.buildRequest(for: "get", with: queryItems, from: "/search")!
        
        HTTPRequest.makeRequest(for: "data request type", request: request, onCompletion: { data in
            do {
                let decoder = JSONDecoder()
                let dataDecoded = try decoder.decode(Response.self, from: data)
                
                if let place = dataDecoded.results.first, let id = place.id {
                    self.selectedPlace = place
                    self.httpGetImageData(with: id)
                    
                    let name = place.name ?? "Name is not available"
                    let category = place.categories?.first?.name ?? ""
                    let address = place.address?.formatted_address ?? ""
                    var distance: String
                    
                    if let geocodes = self.selectedPlace.geocodes, let placeLat = geocodes.main?.latitude, let placeLng = geocodes.main?.longitude {
                        let userLocation = CLLocation(latitude: userLat, longitude: userLng)
                        let desinationLocation = CLLocation(latitude: placeLat, longitude: placeLng)
                        let distanceInMile = userLocation.distance(from: desinationLocation) * 0.000621371
                        distance = "\(String(format: "%.2f", distanceInMile)) mi"
                        
                        DispatchQueue.main.async {
                            self.updateMapViewWithCoordinates(name: name, lat: placeLat, lng: placeLng)
                            self.updateDistance(distance: distance)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.updateContent(name: name, category: category, address: address)
                    }
                }
            } catch let error {
                self.updateContent(name: "Error while retrieving data from network!")
                print("\(String(describing: error.localizedDescription))")
            }
        })
    }
    
    // MARK: - Fetch image url using the ids of locations from func httpRequest()
    func httpGetImageData(with locationID: String) {
        let request = HTTPRequest.buildRequest(for: "get", with: [:], from: "/\(locationID)/photos")!
        
        HTTPRequest.makeRequest(for: "get image details", request: request, onCompletion: { data in
            do {
                let decoder = JSONDecoder()
                let dataDecoded = try decoder.decode([Image].self, from: data)
                let images = dataDecoded
                if images.count > 0 {
                    var imageHeight: String!
                    var imageWidth: String!
                    DispatchQueue.main.async {
                        imageHeight = "\(Int(self.imageView.frame.height * 2))"
                        imageWidth = "\(Int(self.imageView.frame.width * 2))"
                    }
                    for (index, image) in dataDecoded.enumerated() {
                        let imageUrl = "\(image.prefix!)\(imageHeight ?? "600")x\(imageWidth ?? "600")\(image.suffix!)"
                        self.selectedPlace.imageUrls.append(imageUrl)
                        if index == 0 {
                            self.updateImage(url: imageUrl)
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
    func initLocationManager() {
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
                httpGetPlacesData()
                updateContent(name: "Finding the nearest outdoor place!")
                locationManager.startUpdatingLocation()
            case .restricted, .denied:
                print("Location use restricted")
                updateContent(name: "Location use restricted, accessing last location")
            default:
                print("Not authorized yet")
                updateContent(name: "Location use not authorized yet")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        let coord = location.coordinate
        shared.saveLastUserLocation(latitude: coord.latitude, longitude: coord.longitude)
        httpGetPlacesData()
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - Map Delegate
extension HomeViewController: MKMapViewDelegate {
    func updateMapViewWithCoordinates(name: String, lat destinationLat: Double, lng destinationLng: Double) {
        let (userLat, userLng) = shared.getLastUserLocation()
        let userLocation = CLLocationCoordinate2D(latitude: userLat, longitude: userLng)
        let userLocationAnnotation = LocationAnnotation(title: "Current Location", coordinate: userLocation)
        let destinationCoord = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLng)
        let destinationAnnotation = LocationAnnotation(title: name, coordinate: destinationCoord)
        mapView.addAnnotations([userLocationAnnotation, destinationAnnotation])
        displayRoute(userLocation: userLocation, destination: destinationCoord)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.MyColor.hightlightColor
        renderer.lineWidth = 3.0
        return renderer
    }
    
    func displayRoute(userLocation: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        let sourcePlaceMark = MKPlacemark(coordinate: userLocation)
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
