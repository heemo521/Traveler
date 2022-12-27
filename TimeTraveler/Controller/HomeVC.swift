//
//  HomeVC.swift
//  TimeTraveler
//
//  Created by Heemo on 12/25/22.
//

import UIKit
import MapKit
import CoreLocation

class HomeVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var iconLabel: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    // change this to a button and diable for padding, also give rounded border
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var fetchedLocationList: [Location]!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedLocationList = []
        updateUI()
        httpRequest()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
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
        // imageViewContainer.
        scrollView.isHidden = true
        // *****Create a loading spinnner here!!!!!
    }
    
    func hideSpinner() {
        // Remove the spinner and the display
        scrollView.isHidden = false
    }
    
    func updateUI() {
        imageViewContainer.layer.cornerRadius = imageViewContainer.frame.width / 2
        imageViewContainer.clipsToBounds = true
        imageViewContainer.layer.borderColor = UIColor.gray.cgColor
        imageViewContainer.layer.borderWidth = 3
        
        categoryLabel.layer.cornerRadius = 15.0
        categoryLabel.layer.borderColor = UIColor.gray.cgColor
        categoryLabel.layer.borderWidth = 1
        categoryLabel.layer.backgroundColor = UIColor.systemBlue.cgColor
        categoryLabel.textColor = UIColor.white
        
        descriptionLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
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
//        @IBOutlet weak var iconLabel: UIImageView!
//        @IBOutlet weak var titleLabel: UILabel!
//        @IBOutlet weak var mapView: MKMapView!
        
        titleLabel.text = selectedLocation.name
        descriptionLabel.text = selectedLocation.address!.formatted_address!
        categoryLabel.text = selectedLocation.categories!.first!.name
//        iconLabel.image

    }
}

// MARK: - HTTP
private extension HomeVC {
    func httpRequest() {
        showSpinner()
        
        let defaultFields = "fsq_id,name,geocodes,location,categories,related_places,link"
        let searchQuery = "Empire building" // Replace with user location here - replace this with a searched text
        let categories:[Categories] = [.historic, .nationalPark]
        let combinedCategories = categories.map({$0.rawValue}).joined(separator: ",")
        
        let request = buildURLRequest.build(for: "get", with: ["near" : searchQuery, "categories": combinedCategories, "fields": defaultFields])
        
        if let request = request {
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error == nil {
                    guard let data = data else {
                        print("Failed to receive data \(String(describing: error?.localizedDescription))")
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        let dataDecoded = try decoder.decode(Response.self, from: data)
                        self.fetchedLocationList = dataDecoded.results
                        print("decodedData: \(dataDecoded.results.first!.categories!.count)")
                        // call update content here with the data
                        
                        DispatchQueue.main.async {
                            self.updateContent(with: dataDecoded.results.first!)
                            self.hideSpinner()
                        }
                        
                    }
                    catch let error {
                        // Error when there is no response or data returned from API
                        print("\(String(describing: error.localizedDescription))")
                    }
                } else {
                    print("Error from request \(String(describing: error?.localizedDescription))")
                }
                
            }.resume()
        }
        
    }
}

// MARK: - Core Location

extension HomeVC: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        <#code#>
//    }
}