//
//  SearchResultsVC.swift
//  TimeTraveler
//
//  Created by Heemo on 12/28/22.
//

import UIKit

class ResultViewController: UIViewController {
    // MARK: Views
    var tableView: UITableView!
    var filterContainer: UIView!
    var openNowFilterButton = UIButton()
    var sortFilterButton = UIButton()
    var limitFilterButton = UIButton()
    
    // MARK: State
    var resultViewControllerIsVisible = false
    
    private var placesAPIList = [Place]()
    
    private var fetchingSort: Bool? {
        didSet {
            sortFilterButton.setNeedsUpdateConfiguration()
        }
    }
    private var fetchingLimit: Bool? {
        didSet {
            limitFilterButton.setNeedsUpdateConfiguration()
        }
    }
    
    private var fetchingOpenNow: Bool? {
        didSet {
            openNowFilterButton.setNeedsUpdateConfiguration()
        }
    }
    
    var useUserLocation: Bool = false
    var queryString: String!
    var sortBy: String!
    var searchLimit: String!
    var openNow: Bool = false
    
    var mainBackgroundColor: UIColor = .systemBackground
    var contentBackgroundColor: UIColor = .secondarySystemBackground
    var hightlightColor: UIColor = .systemPurple
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchingSort = false
        fetchingLimit = false
        fetchingOpenNow = false
        
        initUI()
        setupLayout()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resultViewControllerIsVisible = true
        
        if placesAPIList.count == 0 {
            sortBy = sortFilterButton.menu?.selectedElements.first?.title
            searchLimit = limitFilterButton.menu?.selectedElements.first?.title
            httpGetPlacesData()
        } else {
            tableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resultViewControllerIsVisible = false
    }
}

// MARK: Navigation
private extension ResultViewController {
    @objc private func presentDetailView(index: Int) {
        guard placesAPIList.count > 0 else { return }
        let DetailVC = DetailViewController()
        DetailVC.selectedPlace = placesAPIList[index]
        DetailVC.modalPresentationStyle = .fullScreen
        DetailVC.modalTransitionStyle = .crossDissolve
        self.present(DetailVC, animated: true)
    }
}

// MARK: UI
private extension ResultViewController {
    func initUI() {
        view.backgroundColor = mainBackgroundColor
        tableView = {
            let tableView = UITableView()
            tableView.backgroundColor = .tertiarySystemBackground
            tableView.register(ResultCell.self, forCellReuseIdentifier: ResultCell.identifier)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
        }()
    
        filterContainer = {
            let filterContainer = UIView()
            filterContainer.translatesAutoresizingMaskIntoConstraints = false
            return filterContainer
        }()
     
        sortFilterButton = {
            let closure =  { (action: UIAction) in
                self.sortBy = action.title
                self.fetchingSort = true
                self.httpGetPlacesData()
            }
            let sortFilterButton = UIButton(primaryAction: nil)
            sortFilterButton.menu = UIMenu(children: [
                UIAction(title:"Relevance", state: .on, handler: closure),
                UIAction(title:"Rating", handler: closure),
                UIAction(title:"Distance", handler: closure),
            ])
            sortFilterButton.showsMenuAsPrimaryAction = true
            sortFilterButton.changesSelectionAsPrimaryAction = true
            
            sortFilterButton.configurationUpdateHandler = {
                [unowned self] button in
                var config = UIButton.Configuration.plain()
                config.title = button.isHighlighted ? "Sort By" : "Sort"
                config.subtitle = button.menu?.selectedElements.first?.title
                config.titleAlignment = .center
                config.baseForegroundColor = hightlightColor
                config.baseBackgroundColor = hightlightColor
                config.showsActivityIndicator = self.fetchingSort!
                config.imagePadding = 5.0
                button.configuration = config
            }
            sortFilterButton.translatesAutoresizingMaskIntoConstraints = false
            return sortFilterButton
        }()
        
        limitFilterButton = {
            let closure =  { (action: UIAction) in
                self.searchLimit = action.title
                self.fetchingLimit = true
                self.httpGetPlacesData()
            }
            let limitFilterButton = UIButton(primaryAction: nil)
            limitFilterButton.menu = UIMenu(children: [
                UIAction(title: "5", handler: closure),
                UIAction(title: "10", state: .on, handler: closure),
                UIAction(title: "25", handler: closure),
                UIAction(title: "35", handler: closure),
                UIAction(title: "50", handler: closure)
            ])
            limitFilterButton.showsMenuAsPrimaryAction = true
            limitFilterButton.changesSelectionAsPrimaryAction = true

            limitFilterButton.configurationUpdateHandler = {
                [unowned self] button in
                var config = UIButton.Configuration.plain()
                config.title = "Limit"
                config.subtitle = button.menu?.selectedElements.first?.title
                config.titleAlignment = .center
                config.baseForegroundColor = hightlightColor
                config.baseBackgroundColor = hightlightColor
                config.showsActivityIndicator = self.fetchingLimit!
                config.imagePadding = 5.0
                button.configuration = config
            }
            limitFilterButton.translatesAutoresizingMaskIntoConstraints = false
            return limitFilterButton
        }()
        
        openNowFilterButton = {
            let openFilterAction = UIAction(title: "Open Now", handler: { _ in
                self.openNow = !self.openNow
                self.fetchingOpenNow = true
                self.httpGetPlacesData()
            })
            var configuration = UIButton.Configuration.plain()
            configuration.baseForegroundColor = hightlightColor
            configuration.baseBackgroundColor = hightlightColor
            let openNowFilterButton = UIButton(configuration: configuration, primaryAction: openFilterAction)
            
            openNowFilterButton.configurationUpdateHandler = {
                [unowned self] button in
                var config = button.configuration
                config?.showsActivityIndicator = self.fetchingOpenNow!
                config?.imagePadding = 5.0
                button.configuration = config
                
            }
            openNowFilterButton.changesSelectionAsPrimaryAction = true
            openNowFilterButton.translatesAutoresizingMaskIntoConstraints = false
            return openNowFilterButton
        }()
    }
    
    func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(filterContainer)
        
        filterContainer.addSubview(openNowFilterButton)
        filterContainer.addSubview(limitFilterButton)
        filterContainer.addSubview(sortFilterButton)
        
        filterContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        filterContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        filterContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        filterContainer.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        openNowFilterButton.centerYAnchor.constraint(equalTo: filterContainer.centerYAnchor).isActive = true
        openNowFilterButton.leadingAnchor.constraint(equalTo: filterContainer.leadingAnchor, constant: 10).isActive = true
        
        limitFilterButton.centerYAnchor.constraint(equalTo: openNowFilterButton.centerYAnchor).isActive = true
        limitFilterButton.leadingAnchor.constraint(equalTo: openNowFilterButton.trailingAnchor, constant: 10).isActive = true
        limitFilterButton.widthAnchor.constraint(equalTo: sortFilterButton.widthAnchor).isActive = true
        
        sortFilterButton.leadingAnchor.constraint(equalTo: limitFilterButton.trailingAnchor, constant: 10).isActive = true
        sortFilterButton.centerYAnchor.constraint(equalTo: filterContainer.centerYAnchor).isActive = true
        sortFilterButton.trailingAnchor.constraint(equalTo: filterContainer.trailingAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: filterContainer.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

// MARK: - HTTP
extension ResultViewController {
    func httpGetPlacesData() {
        let defaultFields = "fsq_id,name,geocodes,location,categories,related_places,link"
        
        var queryItems = ["limit": searchLimit!, "sort": sortBy!, "open_now": String(openNow), "categories": "16000", "fields": defaultFields]
    
        if useUserLocation {
            let (lat, lng) = UserService.shared.getLastUserLocation()
            queryItems["ll"] = "\(lat),\(lng)"
        } else {
            queryItems["near"] = queryString!.lowercased()
        }
        
        let request = HTTPRequest.buildRequest(for: "get", with: queryItems, from: "/search")!
        
        HTTPRequest.makeRequest(for: "data request type", request: request, onCompletion: { data in
            do {
                let decoder = JSONDecoder()
                let dataDecoded = try decoder.decode(Response.self, from: data)
                self.placesAPIList = dataDecoded.results
    
                for (index, place) in self.placesAPIList.enumerated() {
                    self.httpGetImageData(with: place.id!, at: index)
                }
                    
                DispatchQueue.main.async {
                    if self.fetchingLimit == false {
                        self.scrollToTop()
                    }
                    
                    self.fetchingLimit = false
                    self.fetchingSort = false
                    self.fetchingOpenNow = false
                    if self.placesAPIList.count == 0 {
                        self.dismiss(animated: true)
                    } else {
                        self.tableView.reloadData()
                    }
                }
            }
            catch let error {
                print("\(String(describing: error.localizedDescription))")
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            }
        })
    }
    
    func httpGetImageData(with locationID: String, at index: Int) {
        let request = HTTPRequest.buildRequest(for: "get", with: [:], from: "/\(locationID)/photos")!
        
        HTTPRequest.makeRequest(for: "get image details", request: request, onCompletion: { data in
            do {
                let decoder = JSONDecoder()
                let dataDecoded = try decoder.decode([Image].self, from: data)
            
                if dataDecoded.count > 0 {
                    let height = "\(Int(ResultCell.rowHeight) * 2)"
                    for image in dataDecoded {
                        let imageUrl = "\(image.prefix!)\(height)x\(height)\(image.suffix!)"
                        self.placesAPIList[index].imageUrls.append(imageUrl)
                    }
                }
                
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
            catch let error {
                print("\(String(describing: error.localizedDescription))")
            }
        })
    }
}

// MARK: TableView Delegate
extension ResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presentDetailView(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ResultCell.rowHeight
    }
    
    func scrollToTop() {
        let topRow = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: topRow, at: .top, animated: true)
    }
}

// MARK: TableView Data Source
extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = placesAPIList.count
        return count == 0 ? 2 : count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultCell.identifier) as! ResultCell
        cell.backgroundColor = ResultCell.backgroundColor
        
        if placesAPIList.isEmpty {
            return cell
        }
        let place = placesAPIList[indexPath.row]
        cell.update(location: place, index: indexPath.row)
        return cell
    }
}
