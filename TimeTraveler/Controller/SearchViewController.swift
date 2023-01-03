//
//  SearchViewController.swift
//  TimeTraveler
//
//  Created by Heemo on 12/26/22.
//

import UIKit
import MapKit
import CoreLocation
// [x] unselect row
// [] use current location button
// [x] save recent search on the system

class SearchViewController: UIViewController, UISearchBarDelegate {
    let searchBar = UISearchBar()
    let tableView = UITableView()
//    @IBOutlet weak var tableView: UITableView!
    var searchLabel: UILabel!
//    @IBOutlet weak var recentSearchTitle: UILabel!
//    @IBOutlet var searchBarView: UISearchBar!
    let searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var currentLocation: LocationAnnotation!
    var recentSearchList: [RecentSearch] = UserService.shared.getAllRecentSearch()
    
//    @IBOutlet weak var editButton: UIButton!
    var editButton: ActionButton = {
        let button = ActionButton()
        button.setTitle("Edit", for: .normal)
        return button
    }()
    
//    @IBAction func useCurrentLocationClicked(_ sender: UIButton) {
//        performSegue(withIdentifier: "useCurrentLocationSegue", sender: currentLocation)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchCompleter.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem?.title = ""
        
        editButton.buttonIsClicked {
            self.tableView.isEditing.toggle()
            self.navigationController?.isNavigationBarHidden = self.tableView.isEditing
            self.editButton.setTitle( self.tableView.isEditing ? "Done" : "Edit", for: .normal)
        }
    
        searchLabel.text = "Recent Search"
        searchLabel.textColor = .systemBlue
        editButton.isHidden = recentSearchList.isEmpty
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        searchBar.becomeFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchQuery = searchBar.text!

        if searchQuery.count <= 3  {
            editButton.isHidden = recentSearchList.isEmpty
            searchResults = []
            searchLabel.text = "Recent Search"
            searchLabel.textColor = .systemBlue
            tableView.reloadData()
        } else {
            editButton.isHidden = true
            searchCompleter.queryFragment = searchQuery
            searchLabel.text = "Search Result"
            searchLabel.textColor = .black
        }
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }
}

extension SearchViewController: MKLocalSearchCompleterDelegate, UITableViewDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchQuery = searchBar.text!
        if searchQuery != "" {
            UserService.shared.addRecentSearch(recentSearch: RecentSearch(title: searchQuery, subTitle: ""))
            recentSearchList = UserService.shared.getAllRecentSearch()
            self.tableView.reloadData()
//            performSegue(withIdentifier: "searchSegue", sender: searchQuery)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchResults.isEmpty {
            let searchResult = recentSearchList[indexPath.row]
//            performSegue(withIdentifier: "searchSegue", sender: searchResult.title)
        } else {
            let searchResult = searchResults[indexPath.row]
            UserService.shared.addRecentSearch(recentSearch: RecentSearch(title: searchResult.title, subTitle: searchResult.subtitle))
            recentSearchList = UserService.shared.getAllRecentSearch()
            self.tableView.reloadData()
//            performSegue(withIdentifier: "searchSegue", sender: searchResult.title)
        }
        tableView.deselectRow(at: indexPath, animated: true)
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
        if let SearchResultVC = segue.destination as? ResultViewController, let searchQuery = sender as? String {
            SearchResultVC.queryString = searchQuery.lowercased()
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResults.isEmpty {
            return UserService.shared.numberOfRecentSearch()
        }
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchCell
        
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
