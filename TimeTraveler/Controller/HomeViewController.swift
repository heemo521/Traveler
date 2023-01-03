//
//  HomeViewController.swift
//  TimeTraveler
//
//  Created by Heemo on 12/25/22.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewController: SuperUIViewController {
    // MARK: Navigation
    var searchButton: ActionButton!
    
    // MARK: Views
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
    
    let mapView = MKMapView()
    
    // MARK: State
    var didUpdateMapView = false
    var didUpdateImageView = false
    var fetchedLocationList = [Place]()
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
        configureUI()
        
        locationManagerInit()
        getLocationDataHTTP()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if didUpdateImageView {
            scalingAnimation()
        }
        if let first = fetchedLocationList.first {
            if shared.checkLikedPlace(id: first.id!) {
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
            } else {
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
            }
        }
    }
    
    // MARK: - Device Orientation Update
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        scalingAnimation()
    }
    
    
    
    // MARK: - Photos Segue
//    @IBAction func imageTab(_ sender: UITapGestureRecognizer) {
//        performSegue(withIdentifier: "detailSegue", sender: fetchedLocationList.first!)
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let DetailVC = segue.destination as? DetailViewController, let selectedPlace = sender as? Place {
//            DetailVC.selectedPlace = selectedPlace
//        }
//    }
}

// MARK: Navigation
private extension HomeViewController {
    func initNavigationBar() {
        searchButton = {
            let searchBtn = ActionButton()
            searchBtn.setTitle("Search destination", for: .normal)
            searchBtn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            searchBtn.backgroundColor = .lightGray
            searchBtn.buttonIsClicked { [unowned self] in
                let searchVC = TempSearchViewController()
                searchVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(searchVC, animated: true)
//                self.present(searchVC, animated: true)
                
            }
            
            return searchBtn
        }()
        
        navigationItem.titleView = searchButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(didTapLikeButton))
    }
    
    @objc private func didTapLikeButton() {
        if let first = fetchedLocationList.first, let id = first.id {
            if shared.checkLikedPlace(id: id) {
                shared.unlikeAPlace(id: id)
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
            } else {
                shared.likeAPlace(id: id)
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
            }
        }
    }
}

// MARK: - UI
private extension HomeViewController {
    func initUI() {
        view.backgroundColor = .white
        
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
        
        titleLabel = createLabel(with: "Rocky Mountains", size: 32, weight: .bold)
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
        imageContainerView.widthAnchor.constraint(equalTo: nestedGuideView.heightAnchor, multiplier: 0.7).isActive = true
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
        
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50).isActive = true
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
        titleLabel.numberOfLines = 2
        addressLabel.numberOfLines = 2
        
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.shadowRadius = 10
        imageView.layer.shadowOffset = .zero
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowPath = UIBezierPath(rect: imageView.bounds).cgPath
    }
    
    func showSpinner() {
        // Clean up the data and show loading initially and possibly prepare a loader view on the app so the data fetches before segue to this main view
        imageView.isHidden = true
        scrollView.isHidden = true
        iconView.isHidden = true
        // *****Create a loading spinnner here!!!!!
    }
    
    func hideSpinner() {
        UIView.transition(with: scrollView, duration: 1, options: .transitionCrossDissolve, animations: { self.scrollView.isHidden = false
        })
    }
    
    func scalingAnimation() {
//        UIView.animate(withDuration: 1, delay: 0, animations: {self.imageView.transform = CGAffineTransform.identity})
        if UIDevice.current.orientation.isLandscape {
            
//            UIView.animate(withDuration: 0.6, delay: 0, animations: {self.imageView.transform = CGAffineTransform.identity})
            
//            UIView.animate(withDuration: 0.6, animations: {
//                self.imageView.transform = CGAffineTransform.identity
//            }, completion: { _ in
//                UIView.animate(withDuration: 0.6, animations: {
//                    self.imageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
//                })
//            })
//        } else {
//            UIView.animate(withDuration: 0.6, animations: {
//                self.imageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
//            }, completion: { _ in
//                UIView.animate(withDuration: 0.6, animations: {
//                     self.imageView.transform = CGAffineTransform.identity
//                })
//            })
        }
    }
    
    func updateContent(with selectedLocation: Place) {
        categoryLabel.text = selectedLocation.categories?.first?.name
        titleLabel.text = selectedLocation.name
        addressLabel.text = selectedLocation.address!.formatted_address!
    
        if let id = selectedLocation.id {
            if shared.checkLikedPlace(id: id) {
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
            } else {
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
            }
        }
        self.updateMapViewWithCoordinates(at: 0)

    }
}

// MARK: - HTTP
private extension HomeViewController {
    func getLocationDataHTTP(lat: Double = 0.0, lng: Double = 0.0) {
        showSpinner()
        let defaultFields = "fsq_id,name,geocodes,location,categories,related_places,link"
        var ll: String!
        
        if lat != 0.0, lng != 0.0 {
            ll = "\(String(lat)),\(String(lng))"
        } else {
            let (lat, lng) = shared.getLastUserLocation()
            ll = "\(String(lat)),\(String(lng))"
        }
        
        let queryItems = ["query": "outdoor", "limit": "1", "range": "10000.0", "ll" : ll!, "categories": "16000", "fields": defaultFields, "sort": "distance"]
        
        let request = buildRequest(for: "get", with: queryItems, from: "/search")!
        
        makeRequest(for: "data request type", request: request, onCompletion: { data in
            do {
                let decoder = JSONDecoder()
                let dataDecoded = try decoder.decode(Response.self, from: data)
                self.fetchedLocationList = dataDecoded.results
                
                if let id = dataDecoded.results.first!.id {
                    self.getImageDetailsHTTP(with: id, at: 0)
                }
                
                if let iconURLs = dataDecoded.results.first?.categories?.first?.icon, let prefix = iconURLs.prefix, let suffix = iconURLs.suffix {
                    let url = prefix + "64" + suffix
                    self.iconView.loadFrom(url: url)
                }
                
                DispatchQueue.main.async {
                    self.updateContent(with: dataDecoded.results.first!)
                    
                    self.hideSpinner()
                }
            } catch let error {
                // Error when there is no response or data returned from API
                print("\(String(describing: error.localizedDescription))")
            }
        })
    }
    
    // MARK: - Fetch image url using the ids of locations from func httpRequest()
    func getImageDetailsHTTP(with locationID: String, at: Int) {
        let request = buildRequest(for: "get", with: [:], from: "/\(locationID)/photos")!
        
        makeRequest(for: "get image details", request: request, onCompletion: { data in
            do {
                let decoder = JSONDecoder()
                let dataDecoded = try decoder.decode([Image].self, from: data)

                if let first = dataDecoded.first, let prefix = first.prefix, let suffix = first.suffix {
                    let url = prefix + "500x500" + String(suffix[suffix.startIndex...])
                    self.imageView.loadFrom(url: url)
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
            case .authorizedWhenInUse:
                print("all good now!")
                locationManager.startUpdatingLocation()
            case .restricted, .denied:
                print("restricted")
            default:
                print("Not authorized yet")
        }
    }
    // First time when user starts the app / user allows the authorization
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        self.getLocationDataHTTP(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
        
        let coord = location.coordinate
        let locationCoord = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
        currentLocation = LocationAnnotation(coordinate: locationCoord)
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - Map
extension HomeViewController {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("udpating user locaiton")
        let regionView = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
        self.mapView.setRegion(regionView, animated: true)
        didUpdateMapView = true
    }

    func updateMapViewWithCoordinates(at index: Int) {
    
//        guard didUpdateMapView == false else { return }
   
        if let geocodes = fetchedLocationList.first?.geocodes, let lat = geocodes.main?.latitude, let lng = geocodes.main?.longitude {
            let locationCoord = CLLocationCoordinate2D(latitude: lat, longitude: lng)
    
            let regionView = MKCoordinateRegion(center: locationCoord, latitudinalMeters: 1000.0, longitudinalMeters: 1000.0)
            mapView.setRegion(regionView, animated: true)
            mapView.addAnnotation(LocationAnnotation(coordinate: locationCoord))
            didUpdateMapView = true
        }
    }
}
