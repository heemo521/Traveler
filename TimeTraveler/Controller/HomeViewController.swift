//
//  HomeViewController.swift
//  TimeTraveler
//
//  Created by Heemo on 12/24/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var filterControl: UISegmentedControl!
    
    var fetchedLocationList: [Location]!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
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
        // When user changes filter, make http request accordingly
        httpRequest()
    }
    
    
    @IBAction func openSearchView (btn: UIButton) {
        print("open search view")
    }
    
    func httpRequest() {
        let selectedFilter = getSelectedFilter()
        let categories:[buildURLRequest.Categories] = [.historic, .nationalPark]
        let combinedCategories = categories.map({$0.rawValue}).joined(separator: ",")
        let request = buildURLRequest.build(for: "get", with: ["near" : selectedFilter, "categories": combinedCategories])
        
        if let request = request {
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error == nil {
                    guard let data = data else {
                        print("Failed to receive data \(String(describing: error?.localizedDescription))")
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        let dataDecoded = try decoder.decode([Location].self, from: data)
                        self.fetchedLocationList = dataDecoded
//                        print("decodedData: \(dataDecoded.first!.name)")-
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
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }


}


