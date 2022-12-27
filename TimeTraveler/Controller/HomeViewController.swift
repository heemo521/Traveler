//
//  HomeViewController.swift
//  TimeTraveler
//
//  Created by Heemo on 12/24/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var filterControl: UISegmentedControl!
    
    var fetchedLocationList: [Location]!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedLocationList = []
        updateUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        httpRequest()
    }

}

private extension HomeViewController {
    func updateUI() {}
    
    func getSelectedFilter() -> String {
        let filterIndex = self.filterControl.selectedSegmentIndex
        return self.filterControl.titleForSegment(at: filterIndex)!
    }
    
    
    @IBAction func segementControlAction(_ sender: UISegmentedControl) {
        // Remove the current tables and then make the request
        fetchedLocationList = []
        self.tableView.reloadData()
        
        httpRequest()
    }
    
    func httpRequest() {
        let selectedFilter = getSelectedFilter()
        let categories:[Categories] = [.historic, .nationalPark]
        let combinedCategories = categories.map({$0.rawValue}).joined(separator: ",")
        let request = buildURLRequest.build(for: "get", with: ["near" : selectedFilter, "categories": combinedCategories], from: "search")
        
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
                        print("decodedData: \(dataDecoded.results.first!.name!)")
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    }
                    catch let error {
                        print("\(String(describing: error.localizedDescription))")
                    }
                } else {
                    print("Error from request \(String(describing: error?.localizedDescription))")
                }
                
            }.resume()
        }
        
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedLocationList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        let location = fetchedLocationList[indexPath.row]
        cell.update(location: location, index: indexPath.row)
        return cell
    }


}


