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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var iconLabel: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryContainer: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var likeStatusButton: UIButton!
    
    var didUpdateMapView = false
    var didUpdateImageView = false
    var fetchedLocationList = [Place]()
    var imageViewsList = [UIImage]()
    var locationManager: CLLocationManager!
    var currentLocation: LocationAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        locationManagerInit()
        getLocationDataHTTP()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if didUpdateImageView {
            scalingAnimation()
        }
    }
    
    // MARK: - Device Orientation Update
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        scalingAnimation()
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
          if let first = fetchedLocationList.first, let id = first.id {
              if UserService.shared.checkLikedPlace(id: id) {
                  print("un-liked")
                  UserService.shared.unlikeAPlace(id: id)
                  likeStatusButton.setImage(UIImage(systemName: "heart"), for: .normal)
              } else {
                  print("liked")
                  UserService.shared.likeAPlace(id: id)
                  likeStatusButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
              }
          }
    }
    
    // MARK: - Photos Segue
    @IBAction func imageTab(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "detailSegue", sender: fetchedLocationList.first!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let DetailVC = segue.destination as? DetailViewController, let selectedPlace = sender as? Place {
            DetailVC.selectedPlace = selectedPlace
        }
    }
}

// MARK: - UI
private extension HomeViewController {
    func showSpinner() {
        // Clean up the data and show loading initially and possibly prepare a loader view on the app so the data fetches before segue to this main view
        imageView.isHidden = true
        scrollView.isHidden = true
        iconLabel.isHidden = true
        // *****Create a loading spinnner here!!!!!
    }
    
    func hideSpinner() {
        UIView.transition(with: scrollView, duration: 1.0, options: .transitionCrossDissolve, animations: { self.scrollView.isHidden = false
        })
    }
    
    func createCategoryLabel(title: String) -> UIButton {
        let font = UIFont(name: "Arial Hebrew", size: 20)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (title as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        let labelButton = UIButton(frame: CGRect(x: 0, y: 0, width: size.width + 10.0, height: size.height + 5.0))
        labelButton.backgroundColor = .systemBlue
        labelButton.layer.cornerRadius = 15.0
        labelButton.layer.borderWidth = 1
        labelButton.layer.borderColor = UIColor.systemGray.cgColor
        labelButton.setTitle(title, for: .normal)
        labelButton.isEnabled = false
        return labelButton
    }
    
    func updateUI() {
        imageViewContainer.layer.cornerRadius = imageViewContainer.frame.width / 2
        imageViewContainer.clipsToBounds = true
        imageViewContainer.layer.borderColor = UIColor.gray.cgColor
        imageViewContainer.layer.borderWidth = 3
    }
    
    func scalingAnimation() {
        if UIDevice.current.orientation.isLandscape {
            UIView.animate(withDuration: 0.6, animations: {
                self.imageViewContainer.transform = CGAffineTransform.identity
            }, completion: { _ in
                UIView.animate(withDuration: 0.6, animations: {
                    self.imageViewContainer.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                })
            })
        } else {
            UIView.animate(withDuration: 0.6, animations: {
                self.imageViewContainer.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            }, completion: { _ in
                UIView.animate(withDuration: 0.6, animations: {
                     self.imageViewContainer.transform = CGAffineTransform.identity
                })
            })
        }
    }
    
    func updateContent(with selectedLocation: Place) {
        let categoryLabel = createCategoryLabel(title: (selectedLocation.categories!.first?.name)!)
        categoryContainer.addSubview(categoryLabel)
        titleLabel.text = selectedLocation.name
        descriptionLabel.text = selectedLocation.address!.formatted_address!
        let shared = UserService.shared
        print("user likes how many places: \(shared.getNumberOfLikedPlaces())")
        
        if let id = selectedLocation.id {
            if shared.checkLikedPlace(id: id) {
                likeStatusButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                likeStatusButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
    }
}

// MARK: - HTTP
private extension HomeViewController {
    func getLocationDataHTTP() {
        showSpinner()
        
        let defaultFields = "fsq_id,name,geocodes,location,categories,related_places,link"
        let searchQuery = "Empire building" // Replace with user location here - replace this with a searched text
        let queryItems = ["near" : searchQuery, "categories": "16000", "fields": defaultFields]
        
        let request = buildURLRequest.build(for: "get", with: queryItems, from: "/search")!
        
        buildURLRequest.httpRequest(for: "data request type", request: request, onCompletion: { data in
            do {
                let decoder = JSONDecoder()
                let dataDecoded = try decoder.decode(Response.self, from: data)
                self.fetchedLocationList = dataDecoded.results
                
                if let id = dataDecoded.results.first!.id {
                    self.getImageDetailsHTTP(with: id, at: 0)
                }
                
                if let iconURLs = dataDecoded.results.first?.categories?.first?.icon, let prefix = iconURLs.prefix, let suffix = iconURLs.suffix {
                    let url = prefix + "64" + suffix
                    self.getIconDataHTTP(with: url)
                }
                
                DispatchQueue.main.async {
                    self.updateContent(with: dataDecoded.results.first!)
                    self.updateMapViewWIthCoordinates(at: 0)
                    
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
        let request = buildURLRequest.build(for: "get", with: [:], from: "/\(locationID)/photos")!
        
        buildURLRequest.httpRequest(for: "get image details", request: request, onCompletion: { data in
            do {
                let decoder = JSONDecoder()
                let dataDecoded = try decoder.decode([Image].self, from: data)

                if let first = dataDecoded.first, let prefix = first.prefix, let suffix = first.suffix {
                    let url = prefix + "500x500" + String(suffix[suffix.startIndex...])
                    print("image url \(url)")
                    self.getImageDataHTTP(with: url, at: 0)
                }
            } catch let error {
                print("\(String(describing: error.localizedDescription))")
            }
        })
    }
    
    func getImageDataHTTP(with imageURL: String, at index: Int) {
        let url = URL(string: imageURL)!
        let request = URLRequest(url: url)
        
        buildURLRequest.httpRequest(for: "image data", request: request, onCompletion: { data in
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.didUpdateImageView = true // allow animation in the view will appear
                    self.imageView.image = image
                    UIView.transition(with: self.imageView, duration: 1.0, options: .transitionCrossDissolve, animations: {
                        self.imageView.isHidden = false
                    })
                    self.scalingAnimation()
                }
                
            }
        })
    }
    
    func getIconDataHTTP(with imageURL: String) {
        let url = URL(string: imageURL)!
        let request = URLRequest(url: url)
        
        buildURLRequest.httpRequest(for: "get icon data", request: request, onCompletion: { data in
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.iconLabel.image = image
                    UIView.transition(with: self.iconLabel, duration: 1.0, options: .transitionCrossDissolve, animations: {
                        self.iconLabel.isHidden = false
                    })
                }
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
                locationManager.startUpdatingLocation()
            case .restricted, .denied:
                print("restricted")
            default:
                print("Not authorized")
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
        print("location update latitude: \(location.coordinate.latitude) longitude \(location.coordinate.longitude)")
        let coord = location.coordinate
        let locationCoord = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
        currentLocation = LocationAnnotation(coordinate: locationCoord)
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - Map
extension HomeViewController {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if !didUpdateMapView {
            print(userLocation.coordinate)
            let regionView = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 300.0, longitudinalMeters: 300.0)
            mapView.setRegion(regionView, animated: true)
            didUpdateMapView = true
        }
    }

    func updateMapViewWIthCoordinates(at index: Int) {
        guard didUpdateMapView == false else { return }
        if let geocodes = fetchedLocationList[index].geocodes, let lat = geocodes.main?.latitude, let lng = geocodes.main?.longitude {
            let locationCoord = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            let regionView = MKCoordinateRegion(center: locationCoord, latitudinalMeters: 100.0, longitudinalMeters: 100.0)
            mapView.setRegion(regionView, animated: true)
            mapView.addAnnotation(LocationAnnotation(coordinate: locationCoord))
            didUpdateMapView = true
        }
    }
}
