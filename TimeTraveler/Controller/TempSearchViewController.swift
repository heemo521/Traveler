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
    let tableView = UITableView()
    var searchLabel: UILabel!
    var editButton: ActionButton!
    let searchCompleter = MKLocalSearchCompleter()
    let searchResults = [MKLocalSearchCompletion]()
    var currentLocation: LocationAnnotation!
    var recentSearchList: [RecentSearch] = UserService.shared.getAllRecentSearch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchCompleter.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        initNavigationBar()
        initUI()
        setupLayout()
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
        self.dismiss(animated: true)
        print("hello button is clicked")
    }
}

// MARK: UI
private extension TempSearchViewController {
    func initUI() {
        view.backgroundColor = .white
        searchLabel = {
            let searchLabel = UILabel()
            searchLabel.translatesAutoresizingMaskIntoConstraints = false
            searchLabel.text = "Recent Search"
            return searchLabel
        }()
        
        editButton = {
            let button = ActionButton()
            button.buttonIsClicked {
                print("edit button is clicked")
            }
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Edit", for: .normal)
            button.setTitleColor(UIColor.systemBlue, for: .normal)
            return button
        }()
    }
    
    func setupLayout() {
        view.addSubview(searchLabel)
        view.addSubview(editButton)
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        searchLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 75).isActive = true
        searchLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
       
        editButton.centerYAnchor.constraint(equalTo: searchLabel.centerYAnchor).isActive = true
        editButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true

        tableView.topAnchor.constraint(equalTo: searchLabel.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: searchLabel.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: editButton.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

    }
}

extension TempSearchViewController: MKLocalSearchCompleterDelegate {
    
}

extension TempSearchViewController: UISearchBarDelegate {
    
}

extension TempSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

extension TempSearchViewController: UITableViewDelegate {
    
}
