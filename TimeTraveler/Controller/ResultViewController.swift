//
//  SearchResultsVC.swift
//  TimeTraveler
//
//  Created by Heemo on 12/28/22.
//

import UIKit

class ResultViewController: SuperUIViewController {
    var queryString: String! = "Red Rock"
    var placesAPIList = [Place]()
  
    var tableView: UITableView!
    var backButton: ActionButton!
  
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

private extension ResultViewController {
    func initUI() {
        view.backgroundColor = .white
        tableView = {
            let tableView = UITableView()
            tableView.backgroundColor = .systemBlue
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
        
        backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -50).isActive = true
    }
}

private extension ResultViewController {
    func getLocationDataHTTP() {
        let defaultFields = "fsq_id,name,geocodes,location,categories,related_places,link"
        let queryItems = ["near" : queryString!.lowercased(),"limit": "25", "categories": "16000", "fields": defaultFields]
        
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
                
                if let firstImage = dataDecoded.first {
                    let imageUrl = "\(firstImage.prefix!)500x300\(firstImage.suffix!)"
                    self.placesAPIList[index].imageUrl = imageUrl
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
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
//        performSegue(withIdentifier: "detailSegue", sender: placesAPIList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(200)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let DetailVC = segue.destination as? DetailViewController, let selectedPlace = sender as? Place {
//            DetailVC.selectedPlace = selectedPlace
//        }
//    }
}

extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("placeAPILISTCOUNT \(placesAPIList.count)")
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
