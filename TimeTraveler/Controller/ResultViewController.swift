//
//  SearchResultsVC.swift
//  TimeTraveler
//
//  Created by Heemo on 12/28/22.
//

import UIKit

// [] disable clicking a row until the image has been fetched and received (even if there is no data) and use additional boolean property on Place model
// [] Resize the image to fit in to the cell
// [] Heart should be in white and maybe add a circle?
// [] Fix labels and spacing between the address and name
// [] smaller distance between the back button and the table view

class ResultViewController: SuperUIViewController {
    var tableView: UITableView!
    var backButton: ActionButton!
    
    var useUserLocation: Bool = false
    var queryString: String!
    var placesAPIList = [Place]()
    
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
        view.backgroundColor = .white
        tableView = {
            let tableView = UITableView()
            tableView.backgroundColor = .lightGray
            tableView.register(ResultCell.self, forCellReuseIdentifier: ResultCell.identifier)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
        }()
        
        backButton = {
            let backButton = ActionButton()
            backButton.setTitle("Back", for: .normal)
            backButton.setTitleColor(UIColor.systemBlue , for: .normal)
            backButton.buttonIsClicked {
                self.dismiss(animated: true)
            }
            backButton.translatesAutoresizingMaskIntoConstraints = false
            return backButton
        }()
    }
    
    func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(backButton)
        
        backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -20).isActive = true
    }
}

private extension ResultViewController {
    func getLocationDataHTTP() {
        let defaultFields = "fsq_id,name,geocodes,location,categories,related_places,link"
        
        var queryItems = ["limit": "15", "categories": "16000", "fields": defaultFields]
        
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
                // Error when there is no response or data returned from API
                print("\(String(describing: error.localizedDescription))")
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            }
        })
    }
    
    // MARK: - Fetch image url using the ids of locations from func httpRequest()
    func getImageDetailsHTTP(with locationID: String, at index: Int) {
        let request = buildRequest(for: "get", with: [:], from: "/\(locationID)/photos")!
        
        makeRequest(for: "get image details", request: request, onCompletion: { data in
            do {
                let decoder = JSONDecoder()
                let dataDecoded = try decoder.decode([Image].self, from: data)
                if dataDecoded.count > 0 {
                    for image in dataDecoded {
                        let imageUrl = "\(image.prefix!)500x300\(image.suffix!)"
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


extension ResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presentDetailView(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(200)
    }
    
}

extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = placesAPIList.count
        return count == 0 ? 5 : count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultCell.identifier) as! ResultCell
        if placesAPIList.isEmpty {
            return cell
        }
        let place = placesAPIList[indexPath.row]
        cell.update(location: place, index: indexPath.row)
        return cell
    }
}
