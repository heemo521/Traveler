//
//  SearchResultsVC.swift
//  TimeTraveler
//
//  Created by Heemo on 12/28/22.
//

import UIKit

// [] Refactor & Final Clean up

// [x] Add a filter - create a enum for limit & sort for filter // add it to user configuration
// [x] Fetch correct image size based on the imageview's frame width & height
// [x] Fix labels and spacing between the address and name`
// [x] Resize the image to fit in to the cell
// [x] smaller distance between the back button and the table view
// [x] Heart should be in white and maybe add a circle?

class ResultViewController: SuperUIViewController {
    // MARK: Views
    var tableView: UITableView!
    var backButton: ActionButton!
    var filterContainer: UIView!
    var openNowFilterButton: UIButton!
    var sortFilterButton = UIButton()
    var limitFilterButton = UIButton()
    private var placesAPIList = [Place]()
    
    // MARK: State
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
        initUI()
        setupLayout()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if placesAPIList.count == 0 {
            sortBy = sortFilterButton.menu?.selectedElements.first?.title
            searchLimit = limitFilterButton.menu?.selectedElements.first?.title
            getLocationDataHTTP()
        } else {
            tableView.reloadData()
        }
    }
}

// MARK: Navigation
private extension ResultViewController {
    @objc private func presentDetailView(index: Int) {
        guard placesAPIList.count > 0 else { return }
        let DetailVC = DetailViewController()
        DetailVC.selectedPlace = placesAPIList[index]
        DetailVC.modalTransitionStyle = .flipHorizontal
        DetailVC.modalPresentationStyle = .fullScreen
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
        
        backButton = {
            let backButton = ActionButton()
            backButton.configure(title: "Back", padding: 10, configuration: .gray())
            var configuration = backButton.configuration
            configuration?.buttonSize = .large
            configuration?.baseForegroundColor = hightlightColor
            backButton.configuration = configuration
            backButton.buttonIsClicked {
                self.dismiss(animated: true)
            }
            backButton.translatesAutoresizingMaskIntoConstraints = false
            return backButton
        }()
        
        filterContainer = {
            let filterContainer = UIView()
            filterContainer.translatesAutoresizingMaskIntoConstraints = false
            return filterContainer
        }()
     
        sortFilterButton = {
            let closure =  { (action: UIAction) in
                self.sortBy = action.title
                self.placesAPIList = []
                self.getLocationDataHTTP()
            }
            let sortFilterButton = ActionButton(primaryAction: nil)
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
                config.title = button.isHighlighted ? "Change" : "Sort"
                config.subtitle = button.menu?.selectedElements.first?.title
                config.titleAlignment = .center
                config.baseForegroundColor = hightlightColor
                config.baseBackgroundColor = hightlightColor
                button.configuration = config
            }
            sortFilterButton.translatesAutoresizingMaskIntoConstraints = false
            return sortFilterButton
        }()
        
        limitFilterButton = {
            let closure =  { (action: UIAction) in
                self.searchLimit = action.title
                self.placesAPIList = []
                self.getLocationDataHTTP()
            }
            let limitFilterButton = ActionButton(primaryAction: nil)
            limitFilterButton.menu = UIMenu(children: [
                UIAction(title:"5", handler: closure),
                UIAction(title:"10", state: .on, handler: closure),
                UIAction(title:"25", handler: closure),
                UIAction(title: "50", handler: closure)
            ])
            limitFilterButton.showsMenuAsPrimaryAction = true
            limitFilterButton.changesSelectionAsPrimaryAction = true

            limitFilterButton.configurationUpdateHandler = {
                [unowned self] button in
                var config = UIButton.Configuration.plain()
                config.title = button.isHighlighted ? "Change" : "Limit"
                config.subtitle = button.menu?.selectedElements.first?.title
                config.titleAlignment = .center
                config.baseForegroundColor = hightlightColor
                config.baseBackgroundColor = hightlightColor
                button.configuration = config
            }
            limitFilterButton.translatesAutoresizingMaskIntoConstraints = false
            return limitFilterButton
        }()
        
        openNowFilterButton = {
            let openFilterAction = UIAction(title: "Open Now", handler: { _ in
                self.openNow = !self.openNow
                self.placesAPIList = []
                self.getLocationDataHTTP()
            })
            var configuration = UIButton.Configuration.plain()
            configuration.baseForegroundColor = hightlightColor
            configuration.baseBackgroundColor = hightlightColor
            let openNowFilterButton = UIButton(configuration: configuration, primaryAction: openFilterAction)
            openNowFilterButton.changesSelectionAsPrimaryAction = true
            openNowFilterButton.translatesAutoresizingMaskIntoConstraints = false
            return openNowFilterButton
        }()
    }
    
    func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(backButton)
        view.addSubview(filterContainer)
        filterContainer.addSubview(openNowFilterButton)
        filterContainer.addSubview(limitFilterButton)
        filterContainer.addSubview(sortFilterButton)
        
        filterContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        filterContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        filterContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        filterContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
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
        tableView.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -10).isActive = true
        
        backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

// MARK: - HTTP
private extension ResultViewController {
    func getLocationDataHTTP() {
        let defaultFields = "fsq_id,name,geocodes,location,categories,related_places,link"
        
        var queryItems = ["limit": searchLimit!, "sort": sortBy!, "open_now": String(openNow), "categories": "16000", "fields": defaultFields]
    
        if useUserLocation {
            let (lat, lng) = UserService.shared.getLastUserLocation()
            queryItems["ll"] = "\(lat),\(lng)"
        } else {
            queryItems["near"] = queryString!.lowercased()
        }
        
        let request = buildRequest(for: "get", with: queryItems, from: "/search")!
        
        makeRequest(for: "data request type", request: request, onCompletion: { data in
            do {
                let decoder = JSONDecoder()
                let dataDecoded = try decoder.decode(Response.self, from: data)
                self.placesAPIList = dataDecoded.results
    
                for (index, place) in self.placesAPIList.enumerated() {
                    self.getImageDetailsHTTP(with: place.id!, at: index)
                }
                    
                DispatchQueue.main.async {
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
    
    func getImageDetailsHTTP(with locationID: String, at index: Int) {
        let request = buildRequest(for: "get", with: [:], from: "/\(locationID)/photos")!
        
        makeRequest(for: "get image details", request: request, onCompletion: { data in
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
    
}

// MARK: TableView Data Source
extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = placesAPIList.count
        return count == 0 ? 5 : count
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
