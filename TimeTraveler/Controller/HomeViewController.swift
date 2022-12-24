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
   
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        httpRequest()
    }

}

private extension HomeViewController {
    func updateUI() {
     

    }
    
    func getSelectedFilter() -> String {
        let filterIndex = self.filterControl.selectedSegmentIndex
        return self.filterControl.titleForSegment(at: filterIndex)!
    }
    
    func httpRequest() {
        let selectedFilter = getSelectedFilter()
        let categories:[Categories] = [.historic, .nationalPark]
        let combinedCategories = categories.map({$0.rawValue}).joined(separator: ",")
        
        buildURLRequest.getRequest(parameters: ["near" : selectedFilter, "categories": combinedCategories])
    }
    
    
    @IBAction func segementControlAction(_ sender: UISegmentedControl) {
        
        // When user changes filter, make http request accordingly
    }
    
    
    @IBAction func openSearchView (btn: UIButton) {
        print("open search view")
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


