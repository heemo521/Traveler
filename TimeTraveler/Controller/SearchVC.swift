//
//  SearchVC.swift
//  TimeTraveler
//
//  Created by Heemo on 12/26/22.
//

import UIKit

class SearchVC: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {

//    let searchController = UISearchController()
//    let searchBarButton = UIBarButtonItem(customView: UISearchController)

    @IBOutlet var searchBarView: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.searchController = searchController
//        navigationItem.leftBarButtonItem = searchController
//        searchController.searchResultsUpdater = self
        // Do any additional setup after loading the view.
        navigationItem.titleView = searchBarView
        searchBarView.becomeFirstResponder()

    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text!
        print(text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchBarView.text!)
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
