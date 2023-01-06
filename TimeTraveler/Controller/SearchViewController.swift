//
//  SearchViewController.swift
//  TimeTraveler
//
//  Created by Heemo on 1/2/23.
//

// [] - Refactor & Final Clean up
// [] - OPT: make a swipe gesture to get back to the main page

// [x] - build use core location button
// [x] - get rid of edit button
// [x] - update local search complete result type to address (to filter out only for destination)


import UIKit
import MapKit
import CoreLocation

class SearchViewController: UIViewController {
    let searchBar = UISearchBar()
    var tableView: UITableView!
    var searchLabel: UILabel!
    var useCurrentLocationButton: ActionButton!
    
    let searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var recentSearchList: [RecentSearch] = UserService.shared.getAllRecentSearch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        
        initNavigationBar()
        initUI()
        setupLayout()
        
        searchBar.delegate = self
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address

        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        searchBar.becomeFirstResponder()
    }
}

// MARK: Navigation
private extension SearchViewController {
    func initNavigationBar() {
        searchBar.placeholder = "Search Destination"
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(didTapBackButton))
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func presentResultView(searchQuery: String, useUserLocation: Bool = false) {
        if searchQuery != "" || useUserLocation {
            let ResultVC = ResultViewController()
            ResultVC.queryString = searchQuery.lowercased()
            ResultVC.useUserLocation = useUserLocation
            ResultVC.modalTransitionStyle = .coverVertical
            ResultVC.modalPresentationStyle = .fullScreen
            self.present(ResultVC, animated: true)
        }
    }
}

// MARK: UI
private extension SearchViewController {
    func initUI() {
        view.backgroundColor = .white
        tableView = {
            let tableView = UITableView()
            tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
        }()
        
        searchLabel = {
            let searchLabel = UILabel()
            searchLabel.text = "Recent Search"
            searchLabel.translatesAutoresizingMaskIntoConstraints = false
            return searchLabel
        }()
        
        useCurrentLocationButton = {
            let image = UIImage(systemName: "paperplane.fill")
            let useCurrentLocationButton = ActionButton()
            useCurrentLocationButton.configure(title: "Use Current Location", image: image!, padding: 5.0, configuration: .gray())
            useCurrentLocationButton.buttonIsClicked {
                self.presentResultView(searchQuery: "", useUserLocation: true)
            }
            useCurrentLocationButton.translatesAutoresizingMaskIntoConstraints = false
            return useCurrentLocationButton
        }()
    }
    
    func setupLayout() {
        view.addSubview(useCurrentLocationButton)
        view.addSubview(searchLabel)
        view.addSubview(tableView)
        
        useCurrentLocationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1).isActive = true
        useCurrentLocationButton.trailingAnchor.constraint(equalTo: tableView.trailingAnchor).isActive = true

        searchLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 75).isActive = true
        searchLabel.leadingAnchor.constraint(equalTo: tableView.leadingAnchor).isActive = true
    
        tableView.topAnchor.constraint(equalTo: searchLabel.bottomAnchor, constant: 5).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

// MARK: SearchBar
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchQuery = searchBar.text!

        if searchQuery.count <= 3  {
            searchResults = []
            searchLabel.text = "Recent Search"
            searchLabel.textColor = .systemBlue
        } else {
            searchCompleter.queryFragment = searchQuery
            searchLabel.text = "Search Result"
            searchLabel.textColor = .black
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchQuery = searchBar.text!
        if searchQuery != "" {
            UserService.shared.addRecentSearch(recentSearch: RecentSearch(title: searchQuery, subTitle: ""))
            recentSearchList = UserService.shared.getAllRecentSearch()
            self.tableView.reloadData()
            
            presentResultView(searchQuery: searchQuery)
        }
    }
}
// MARK: MK Local Search
extension SearchViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
}
// MARK: TableView Delegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var searchResult = ""
        if searchResults.isEmpty {
            searchResult = recentSearchList[indexPath.row].title
            
        } else {
            let result = searchResults[indexPath.row]
            searchResult = result.title
            UserService.shared.addRecentSearch(recentSearch: RecentSearch(title: result.title, subTitle: result.subtitle))
            recentSearchList = UserService.shared.getAllRecentSearch()
            self.tableView.reloadData()
        }
        presentResultView(searchQuery: searchResult)
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
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
}

// MARK: TableView Data Source
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.isEmpty ? UserService.shared.numberOfRecentSearch() : searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier) as! SearchCell
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
