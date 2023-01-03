//
//  TempSearchViewController.swift
//  TimeTraveler
//
//  Created by Heemo on 1/2/23.
//

import UIKit
import MapKit
import CoreLocation

class TempSearchViewController: UIViewController {
    let searchBar = UISearchBar()
    var tableView: UITableView!
    var searchLabel: UILabel!
    var editButton: ActionButton!
    let searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var currentLocation: LocationAnnotation!
    var recentSearchList: [RecentSearch] = UserService.shared.getAllRecentSearch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        
        initNavigationBar()
        initUI()
        setupLayout()
        
        searchBar.delegate = self
        searchCompleter.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        searchBar.becomeFirstResponder()
    }
    
}

// MARK: Navigation
private extension TempSearchViewController {
    func initNavigationBar() {
        searchBar.placeholder = "Search Destination"
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(didTapBackButton))
    }
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: UI
private extension TempSearchViewController {
    func initUI() {
        view.backgroundColor = .white
        tableView = {
            let tableView = UITableView()
            tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
            return tableView
        }()
        
        searchLabel = {
            let searchLabel = UILabel()
            searchLabel.translatesAutoresizingMaskIntoConstraints = false
            searchLabel.text = "Recent Search"
            return searchLabel
        }()
        
        editButton = {
            let button = ActionButton()
            button.buttonIsClicked {
                self.tableView.isEditing.toggle()
                self.navigationController?.isNavigationBarHidden = self.tableView.isEditing
                self.editButton.setTitle( self.tableView.isEditing ? "Done" : "Edit", for: .normal)
            }
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Edit", for: .normal)
            button.setTitleColor(UIColor.systemBlue, for: .normal)
            return button
        }()
//        editButton.isHidden = recentSearchList.isEmpty
    }
    
    func setupLayout() {
        view.addSubview(searchLabel)
        view.addSubview(editButton)
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        searchLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 75).isActive = true
        searchLabel.leadingAnchor.constraint(equalTo: tableView.leadingAnchor).isActive = true
       
        editButton.centerYAnchor.constraint(equalTo: searchLabel.centerYAnchor).isActive = true
        editButton.trailingAnchor.constraint(equalTo: tableView.trailingAnchor).isActive = true

        tableView.topAnchor.constraint(equalTo: searchLabel.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

    }
}

extension TempSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchQuery = searchBar.text!
        print(searchQuery)

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
}

extension TempSearchViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchQuery = searchBar.text!
        if searchQuery != "" {
            UserService.shared.addRecentSearch(recentSearch: RecentSearch(title: searchQuery, subTitle: ""))
            recentSearchList = UserService.shared.getAllRecentSearch()
            self.tableView.reloadData()
//            performSegue(withIdentifier: "searchSegue", sender: searchQuery)
        }
    }
}

extension TempSearchViewController: UITableViewDelegate {
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
            navigationController?.isNavigationBarHidden = !recentSearchList.isEmpty
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension TempSearchViewController: UITableViewDataSource {
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