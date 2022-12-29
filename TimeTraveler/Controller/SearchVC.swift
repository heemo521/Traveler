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

class SearchVC: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recentSearchTitle: UILabel!
    @IBOutlet var searchBarView: UISearchBar!
    let searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var currentLocation: LocationAnnotation!
    var recentSearchList: [RecentSearch]!
    @IBOutlet weak var editButton: UIButton!
    
    @IBAction func useCurrentLocationClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "useCurrentLocationSegue", sender: currentLocation)
    }
    
    @IBAction func editButtonClicked(_ sender: Any) {
        tableView.isEditing.toggle()
        navigationController?.isNavigationBarHidden = tableView.isEditing
        editButton.setTitle( tableView.isEditing ? "Done" : "Edit", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBarView
        searchBarView.becomeFirstResponder()
        searchCompleter.delegate = self
        recentSearchTitle.text = "Recent Search"
        recentSearchTitle.textColor = .systemBlue
        recentSearchList = UserService.shared.getAllRecentSearch()
        editButton.isHidden = recentSearchList.isEmpty
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        recentSearchList = UserService.shared.getAllRecentSearch()
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchQuery = searchBarView.text!

        if searchQuery.count <= 3  {
            editButton.isHidden = recentSearchList.isEmpty
            searchResults = []
            recentSearchTitle.text = "Recent Search"
            recentSearchTitle.textColor = .systemBlue
            tableView.reloadData()
        } else {
            editButton.isHidden = true
            searchCompleter.queryFragment = searchQuery
            recentSearchTitle.text = "Search Result"
            recentSearchTitle.textColor = .black
        }
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }
}

extension SearchVC: MKLocalSearchCompleterDelegate, UITableViewDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchQuery = searchBarView.text!
        if searchQuery != "" {
            UserService.shared.addRecentSearch(recentSearch: RecentSearch(title: searchQuery, subTitle: ""))
            recentSearchList = UserService.shared.getAllRecentSearch()
            self.tableView.reloadData()
            performSegue(withIdentifier: "searchSegue", sender: searchQuery)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchResults.isEmpty {
            let searchResult = recentSearchList[indexPath.row]
            performSegue(withIdentifier: "searchSegue", sender: searchResult)
        } else {
            let searchResult = searchResults[indexPath.row]
            UserService.shared.addRecentSearch(recentSearch: RecentSearch(title: searchResult.title, subTitle: searchResult.subtitle))
            recentSearchList = UserService.shared.getAllRecentSearch()
            self.tableView.reloadData()
            performSegue(withIdentifier: "searchSegue", sender: searchResult)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return searchResults.isEmpty
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return searchResults.isEmpty ? .delete : .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteSearchTitle = recentSearchList[indexPath.row].title
            UserService.shared.removeRecentSearch(recentSearch: RecentSearch(title: deleteSearchTitle, subTitle: ""))
            recentSearchList = UserService.shared.getAllRecentSearch()
            tableView.deleteRows(at: [indexPath], with: .fade)
            editButton.isHidden = recentSearchList.isEmpty
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let SearchResultsVC = segue.destination as? ResultsVC, let searchQuery = sender as? String {
            SearchResultsVC.queryString = searchQuery
        }
    }
}

extension SearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResults.isEmpty {
            return UserService.shared.numberOfRecentSearch()
        }
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchCell") as! RecentSearchCell
        
        if searchResults.isEmpty {
            let recentSearch = recentSearchList[indexPath.row]
            cell.update(location: recentSearch)
        } else {
            let searchResult = searchResults[indexPath.row]
            cell.update(searchResult: searchResult)
        }
        
        return cell
    }
}
