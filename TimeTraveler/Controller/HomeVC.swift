//
//  HomeVC.swift
//  TimeTraveler
//
//  Created by Heemo on 12/25/22.
//

import UIKit
import MapKit
import CoreLocation

// REFACTOR http request functions
// create a global one or class?
// Next is core location and displaying the coordinates on to the map
// Fix the label to button
// Update the Logo
// Fetch all images and load it to shareable model : Singleton
// Change the imageViewsList to list of fethed data. Ensemble the e UIImage at func showImage()
// search bar implementation
// recent search implemntation
// use current location button
// maybe remove tabs - save it for use preference
// add map / search bar view controller and cell
// maybe display reviews as a table on the bottonm

class HomeVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var iconLabel: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    // change this to a button and diable for padding, also give rounded border
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    var fetchedLocationList: [Location]!
    var locationManager: CLLocationManager!
    
    var imageViewsList: [UIImage]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViewsList = []
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
        
//        descriptionLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
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
        titleLabel.text = selectedLocation.name
        descriptionLabel.text = selectedLocation.address!.formatted_address!
        categoryLabel.text = selectedLocation.categories!.first!.name
        //        @IBOutlet weak var iconLabel: UIImageView!
        //        @IBOutlet weak var titleLabel: UILabel!
        //        @IBOutlet weak var mapView: MKMapView!
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
        let queryItems = ["near" : searchQuery, "categories": combinedCategories, "fields": defaultFields]
        
        guard let request = buildURLRequest.build(for: "get", with: queryItems, from: "/search") else { return }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error from main request \(String(describing: error.localizedDescription))")
                return
            }
            
            if let res = response as? HTTPURLResponse {
                print("response main statuscode: \(res.statusCode)")
            }
            
            guard let data = data else {
                print("Failed to receive main data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let dataDecoded = try decoder.decode(Response.self, from: data)
                self.fetchedLocationList = dataDecoded.results
                
                if let id = dataDecoded.results.first!.id {
                    self.getImageDetails(with: id, atIndex: 0)
                }
                
                DispatchQueue.main.async {
                    self.updateContent(with: dataDecoded.results.first!)
                    self.hideSpinner()
                }
            }
            catch let error {
                // Error when there is no response or data returned from API
                print("\(String(describing: error.localizedDescription))")
            }
        }.resume()
    }
    
    // MARK: - Fetch image url using the ids of locations from func httpRequest()
    func getImageDetails(with locationID: String, atIndex: Int) {
        guard let request = buildURLRequest.build(for: "get", with: [:], from: "/\(locationID)/photos") else { return }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error from image info request \(String(describing: error.localizedDescription))")
                return
            }
            
            if let res = response as? HTTPURLResponse {
                print("response from image info statuscode: \(res.statusCode)")
            }
            
            guard let data = data else {
                print("Failed to receive image info data")
                return
            }
        
            do {
                let decoder = JSONDecoder()
                let dataDecoded = try decoder.decode([ImageHTTP].self, from: data)
//                print(dataDecoded.first?.prefix!)
                if let first = dataDecoded.first, let prefix = first.prefix, let suffix = first.suffix {
                    let url = prefix + "500x500" + String(suffix[suffix.startIndex...])
                    print("image url \(url)")
                    self.getImageData(with: url, atIndex: 0)
                }
            }
            catch let error {
                // Error when there is no response or data returned from API
                print("\(String(describing: error.localizedDescription))")
            }
        }.resume()
    }
    
    func getImageData(with imageURL: String, atIndex: Int) {
        guard let request = URL(string: imageURL) else { return }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error from image data request \(String(describing: error.localizedDescription))")
                return
            }
            
            if let res = response as? HTTPURLResponse {
                print("response from image data statuscode: \(res.statusCode)")
            }
            
            guard let data = data else {
                print("Failed to receive image data data")
                return
            }
            if let image = UIImage(data: data) {
                self.imageViewsList.append(image)
                DispatchQueue.main.async {
                  self.showImage(at: self.imageViewsList.count - 1)
                }
                
            }
        }.resume()
    }
}
// MARK: - Core Location
extension HomeVC: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        <#code#>
//    }
}
