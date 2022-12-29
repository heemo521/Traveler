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
// - [x] display search screen
// - [x] display when clicked display list / map view

// [] Update models and refactor some code to be able to make http call and share same data between multiple views using singleton
// [] list/map split view -> to main details page
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
    

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            // maybe send back to the main screen?
        navigationController?.popViewController(animated: true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBarView.text != "" {
            let searchQuery = searchBarView.text
            performSegue(withIdentifier: "searchSegue", sender: searchQuery)
        }
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
}

extension SearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchQuery = searchResults[indexPath.row].title
        performSegue(withIdentifier: "searchSegue", sender: searchQuery)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let SearchResultsVC = segue.destination as? SearchResultsVC, let searchQuery = sender as? String {
            SearchResultsVC.queryString = searchQuery
        }
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
