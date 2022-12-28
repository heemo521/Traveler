//
//  HomeVC.swift
//  TimeTraveler
//
//  Created by Heemo on 12/25/22.
//

import UIKit
import MapKit
import CoreLocation

// [] REFACTOR http request function global one or class?
// [] REFACTOR UI

// [x] Next is core location and
// [x] displaying the coordinates on to the map
// [x] Fix the label to button and dynamic render
// [] Update the Logo image
// [] Fetch all images and load it to shareable model : Singleton
// [] Change the imageViewsList to list of fethed data. Ensemble the e UIImage at func showImage()
// [] search bar implementation
// [] recent search implemntation
// [] use current location button
// [] maybe remove tabs - save it for use preference
// [] add map / search bar view controller and cell
// [] maybe display reviews as a table on the bottonm

class HomeVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var iconLabel: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var categoryContainer: UIView!
    // change this to a button and diable for padding, also give rounded border
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    var didUpdateMapView = false
    
    var fetchedLocationList: [Location]!
    var imageViewsList: [UIImage]!
    var locationManager: CLLocationManager!
    
    var currentLocation: LocationCoordinates!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViewsList = []
        fetchedLocationList = []
        updateUI()
        locationManagerInit()
        getLocationDataHTTP() // if the user doesn't allow the core location then use different data or just make random recommendation
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // animation everytime the view appears instead of only once per app launch
        scalingAnimation()
    }
    
    // MARK: - Device Orientation Update
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        scalingAnimation()
    }
    
    // MARK: - Photos Segue
    @IBAction func imageTab(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "detailsSegue", sender: self)
    }
}

// MARK: - UI
private extension HomeVC {
    func showSpinner() {
        // Clean up the data and show loading initially and possibly prepare a loader view on the app so the data fetches before segue to this main view
        imageView.isHidden = true
        scrollView.isHidden = true
        
        // *****Create a loading spinnner here!!!!!
    }
    
    func hideSpinner() {
        // Remove the spinner and the display
        UIView.transition(with: scrollView, duration: 1.0, options: .transitionCrossDissolve, animations: { self.scrollView.isHidden = false
        })
    }
    
    func showImage(at index: Int) {
        let currentImageView = self.imageViewsList[index]
        imageView.image = currentImageView
        UIView.transition(with: scrollView, duration: 1.0, options: .transitionCrossDissolve, animations: { self.imageView.isHidden = false
        })
    }
    
    func showIcon(at index: Int) {
        
    }
    
    func createCategoryLabel(title: String) -> UIButton {
        let font = UIFont(name: "Arial", size: 20)
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
    
    func updateContent(with selectedLocation: Location) {
        let categoryLabel = createCategoryLabel(title: (selectedLocation.categories!.first?.name)!)
        let categoryLabel2 = createCategoryLabel(title: (selectedLocation.categories!.first?.name)!)
        categoryContainer.addSubview(categoryLabel)
        categoryContainer.addSubview(categoryLabel2)
        
        titleLabel.text = selectedLocation.name
        descriptionLabel.text = selectedLocation.address!.formatted_address!
//        iconLabel.image = UIImage(selectedLocation.categories!.first!.icon)
        
        

    }
}

// MARK: - HTTP
private extension HomeVC {
    func httpRequest(for requestType: String,  request: URLRequest, onCompletion callback: @escaping (Data) -> ()) {
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error for \(requestType) request \(String(describing: error.localizedDescription))")
                return
            }
            
            if let res = response as? HTTPURLResponse {
                print("response for \(requestType) statuscode: \(res.statusCode)")
            }
            
            guard let data = data else {
                print("Failed to receive data for \(requestType)")
                return
            }
            
            callback(data)
            
        }.resume()
    }
    
    func getLocationDataHTTP() {
        showSpinner()
        
        let defaultFields = "fsq_id,name,geocodes,location,categories,related_places,link"
        let searchQuery = "Empire building" // Replace with user location here - replace this with a searched text
        let categories:[Categories] = [.historic, .nationalPark]
        let combinedCategories = categories.map({$0.rawValue}).joined(separator: ",")
        let queryItems = ["near" : searchQuery, "categories": combinedCategories, "fields": defaultFields]
        
        let request = buildURLRequest.build(for: "get", with: queryItems, from: "/search")!
        
        httpRequest(for: "data request type", request: request, onCompletion: { data in
            do {
                let decoder = JSONDecoder()
                let dataDecoded = try decoder.decode(Response.self, from: data)
                self.fetchedLocationList = dataDecoded.results
                
                if let id = dataDecoded.results.first!.id {
                    self.getImageDetailsHTTP(with: id, at: 0)
                }
                
                if let iconURLs = dataDecoded.results.first?.categories?.first?.icon, let prefix = iconURLs.prefix, let suffix = iconURLs.suffix {
                    let url = prefix + "64" + suffix
                    print("icon url")
                    self.getIconDataHTTP(with: prefix + "64" + suffix)
                }
                
                DispatchQueue.main.async {
                    self.updateContent(with: dataDecoded.results.first!)
                    self.updateMapViewWIthCoordinates(at: 0)
                    
                    self.hideSpinner()
                }
            }
            catch let error {
                // Error when there is no response or data returned from API
                print("\(String(describing: error.localizedDescription))")
            }
        })
    }
    
    // MARK: - Fetch image url using the ids of locations from func httpRequest()
    func getImageDetailsHTTP(with locationID: String, at: Int) {
        let request = buildURLRequest.build(for: "get", with: [:], from: "/\(locationID)/photos")!
        
        httpRequest(for: "get image details", request: request, onCompletion: { data in
            do {
                let decoder = JSONDecoder()
                let dataDecoded = try decoder.decode([ImageHTTP].self, from: data)

                if let first = dataDecoded.first, let prefix = first.prefix, let suffix = first.suffix {
                    let url = prefix + "500x500" + String(suffix[suffix.startIndex...])
                    print("image url \(url)")
                    self.getImageDataHTTP(with: url, at: 0)
                }
            }
            catch let error {
                print("\(String(describing: error.localizedDescription))")
            }
        })
    }
    
    func getImageDataHTTP(with imageURL: String, at index: Int) {
        let url = URL(string: imageURL)!
        let request = URLRequest(url: url)
        
        httpRequest(for: "image data", request: request, onCompletion: { data in
            if let image = UIImage(data: data) {
                self.imageViewsList.append(image)
                DispatchQueue.main.async {
                  self.showImage(at: self.imageViewsList.count - 1)
                }
                
            }
        })
    }
    
    func getIconDataHTTP(with imageURL: String) {
        let url = URL(string: imageURL)!
        let request = URLRequest(url: url)
        
        httpRequest(for: "get icon data", request: request, onCompletion: { data in
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.iconLabel.image = image
                }
            }
        })
    }
}
// MARK: - Core Location
extension HomeVC: CLLocationManagerDelegate {
    
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
        currentLocation = LocationCoordinates(name: "User's Location", latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - Map
extension HomeVC {
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
