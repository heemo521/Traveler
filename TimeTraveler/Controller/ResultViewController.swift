//
//  SearchResultsVC.swift
//  TimeTraveler
//
//  Created by Heemo on 12/28/22.
//

import UIKit
// [] fetch data and display on cell
// [] like button implementation
// [] list/map split view
// [] create map view cells
// [] allow slidable action using tableview/collectionview?
// [] segue to details page
// [] details page slidable image gallery
// [] place reviews
// [] maybe display reviews as a table on the bottonm
// [] Show distance
// [] REFACTOR UI

class ResultViewController: UIViewController {
    var queryString: String!
    var placesAPIList = [Place]()
    var imageDataList = [[UIImage]]()

    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func BackButtonClicked(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if queryString == "" {
            // pop the view and show warning
            navigationController?.popViewController(animated: true)
        }
        print("queryString \(queryString!)")
//        getLocationDataHTTP()
        // fetch here since it takes time to load map view any ways
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        getLocationDataHTTP()
    }
}

private extension ResultViewController {
    func getLocationDataHTTP() {
//        showSpinner()
        print("queryString \(queryString!)")
        let defaultFields = "fsq_id,name,geocodes,location,categories,related_places,link"
//        let searchQuery = "Empire building" // Replace with user location here - replace this with a searched text
        let categories:[Categories] = [.historic, .nationalPark]
        let combinedCategories = categories.map({$0.rawValue}).joined(separator: ",")
        let queryItems = ["near" : queryString!, "categories": combinedCategories, "fields": defaultFields]
        
        let request = buildURLRequest.build(for: "get", with: queryItems, from: "/search")!
        
        buildURLRequest.httpRequest(for: "data request type", request: request, onCompletion: { data in
            do {
                let decoder = JSONDecoder()
                let dataDecoded = try decoder.decode(Response.self, from: data)
                self.placesAPIList = dataDecoded.results
                print(dataDecoded.results.count)
                for (index, place) in self.placesAPIList.enumerated() {
                    self.getImageDetailsHTTP(with: place.id!, at: index)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch let error {
                // Error when there is no response or data returned from API
                print("\(String(describing: error.localizedDescription))")
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
            if let imageData = UIImage(data: data) {
                DispatchQueue.main.async {
//                    self.imageDataList[index].append(image)
                    let indexPath = IndexPath(row: index, section: 0)
                    let cell = self.tableView.cellForRow(at: indexPath) as! ResultCell
                    cell.update(imageData: imageData)
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
//                    self.tableView.reloadData()
//                    if let firstImage = imageDataList[indexPath.row].first {
//                        cell.update(imageData: firstImage)
//                    }
                }
            }
        })
    }
}


extension ResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    }
}

extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesAPIList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell") as! ResultCell
        let place = placesAPIList[indexPath.row]
        cell.update(location: place, index: indexPath.row)
        return cell
    }
}
