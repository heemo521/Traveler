//
//  SearchResultsVC.swift
//  TimeTraveler
//
//  Created by Heemo on 12/28/22.
//

import UIKit
// [x] fetch data and display on cell
// [x] like button implementation
// [x] segue to details page
// [] details page slidable image gallery
// [] list/map split view
// [] create map view cells
// [] allow slidable action using tableview/collectionview?
// [] place reviews
// [] maybe display reviews as a table on the bottonm
// [] Show distance
// [] REFACTOR UI

class ResultViewController: UIViewController {
    var queryString: String!
    var placesAPIList = [Place]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func BackButtonClicked(_ sender: UIButton) {
//        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if queryString == "" {
            // pop the view and show warning
            navigationController?.popViewController(animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        if placesAPIList.count == 0 {
            getLocationDataHTTP()
        } else {
                
        }
    }
}

private extension ResultViewController {
    func getLocationDataHTTP() {
//        showSpinner()
        let defaultFields = "fsq_id,name,geocodes,location,categories,related_places,link"
        let queryItems = ["near" : queryString!.lowercased(),"limit": "25", "categories": "16000", "fields": defaultFields]
        
        let request = buildURLRequest.build(for: "get", with: queryItems, from: "/search")!
        
        buildURLRequest.httpRequest(for: "data request type", request: request, onCompletion: { data in
            do {
                let decoder = JSONDecoder()
                let dataDecoded = try decoder.decode(Response.self, from: data)
                self.placesAPIList = dataDecoded.results
    
                for (index, place) in self.placesAPIList.enumerated() {
                    self.getImageDetailsHTTP(with: place.id!, at: index)
                }
                
                if self.placesAPIList.count == 0 {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            catch let error {
                // Error when there is no response or data returned from API
                print("\(String(describing: error.localizedDescription))")
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })
    }
    
    // MARK: - Fetch image url using the ids of locations from func httpRequest()
    func getImageDetailsHTTP(with locationID: String, at index: Int) {
        let request = buildURLRequest.build(for: "get", with: [:], from: "/\(locationID)/photos")!
        
        buildURLRequest.httpRequest(for: "get image details", request: request, onCompletion: { data in
            do {
                let decoder = JSONDecoder()
                let dataDecoded = try decoder.decode([Image].self, from: data)
                
                if let firstImage = dataDecoded.first {
                    let url = "\(firstImage.prefix!)500x300\(firstImage.suffix!)"
                    self.getImageDataHTTP(with: url, at: index)
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
        
        buildURLRequest.httpRequest(for: "image data", request: request, onCompletion: { data in
            self.placesAPIList[index].imageData = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
}


extension ResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "detailSegue", sender: placesAPIList[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let DetailVC = segue.destination as? DetailViewController, let selectedPlace = sender as? Place {
            DetailVC.selectedPlace = selectedPlace
        }
    }
}

extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("placeAPILISTCOUNT \(placesAPIList.count)")
        return placesAPIList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell") as! ResultCell
        let place = placesAPIList[indexPath.row]
        cell.update(location: place, index: indexPath.row)
        return cell
    }
}
