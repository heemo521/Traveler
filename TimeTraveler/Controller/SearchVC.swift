//
//  SearchVC.swift
//  TimeTraveler
//
//  Created by Heemo on 12/26/22.
//

import UIKit
import MapKit
// [x] REFACTOR http request function
// [x] Next is core location and
// [x] displaying the coordinates on to the map
// [x] Fix the label to button and dynamic render
// [x] Update the Logo image
// [] search bar implementation
// - [] display search screen
// - [] display when clicked display list / map view
// [] list/map view -> to main details page
// [] details page slidable image gallery
// [] place reviews
// [] Fetch all images and load it to shareable model : Singleton
// [] Change the imageViewsList to list of fethed data. Ensemble the e UIImage at func showImage()
// [] recent search implemntation
// [] use current location button
// [] maybe remove tabs - save it for use preference
// [] add map / search bar view controller and cell
// [] maybe display reviews as a table on the bottonm
// [] Show distance
// [] REFACTOR UI

class SearchVC: UIViewController, UISearchBarDelegate, MKLocalSearchCompleterDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recentSearchTitle: UILabel!
    
    let searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    @IBOutlet var searchBarView: UISearchBar!

    @IBAction func useCurrentLocation(_ sender: UIButton) {
        performSegue(withIdentifier: "currentLocationSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.searchController = searchController
//        navigationItem.leftBarButtonItem = searchController
//        searchController.searchResultsUpdater = self
        // Do any additional setup after loading the view.
        navigationItem.titleView = searchBarView
        searchBarView.becomeFirstResponder()
        searchCompleter.delegate = self
        recentSearchTitle.text = "Recent Search"
        recentSearchTitle.textColor = .systemBlue
    }
    
    //    func searchBarCancelButtonClicked(UISearchBar)
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            // maybe send back to the main screen?
    }
    //    func searchBarSearchButtonClicked(UISearchBar)
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "searchSegue", sender: self)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchQuery = searchBarView.text!
        print("search bar" + searchBarView.text!)
        
        if searchQuery.count > 3 {
            searchCompleter.queryFragment = searchQuery
        }
        
        if searchQuery.count == 0 {
            searchResults = []
            tableView.reloadData()
        }
        
        if searchResults.isEmpty {
            recentSearchTitle.text = "Recent Search"
            recentSearchTitle.textColor = .systemBlue
        } else {
            recentSearchTitle.text = "Search Result"
            recentSearchTitle.textColor = .black
        }
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        <#code#>
    }
}

extension SearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

extension SearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchCell") as! RecentSearchCell
        
        if searchResults.isEmpty {
            //
        }
        let searchResult = searchResults[indexPath.row]
        cell.update(searchResult: searchResult)
        return cell
    }
    
    
}
