//
//  SearchResultsVC.swift
//  TimeTraveler
//
//  Created by Heemo on 12/28/22.
//

import UIKit

// [] list/map split view
// [] segue to details page
// [] details page slidable image gallery
// [] place reviews
// [] maybe display reviews as a table on the bottonm
// [] Show distance
// [] REFACTOR UI

class ResultViewController: UIViewController {
    var queryString: String!
    var placesAPIList = [Place]()
    
    @IBAction func BackButtonClicked(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // fetch here since it takes time to load map view any ways
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
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
extension ResultViewController: UITableViewDelegate {
    
}

extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
