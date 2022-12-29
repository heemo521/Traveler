//
//  SearchResultsVC.swift
//  TimeTraveler
//
//  Created by Heemo on 12/28/22.
//

import UIKit

class SearchResultsVC: UIViewController {
    var queryString: String!
    var placesAPIList = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // fetch here since it takes time to load map view any ways
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SearchResultsVC: UITableViewDelegate {
    
}

extension SearchResultsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
