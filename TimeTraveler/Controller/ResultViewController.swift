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
    
//    @IBOutlet weak var tableView: UITableView!
  
//    @IBAction func backButtonClicked(_ sender: UIButton) {
//        navigationController?.popViewController(animated: true)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        setupLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if placesAPIList.count == 0 {
//            getLocationDataHTTP()
//        } else {
//            tableView.reloadData()
//        }
    }
}

private extension ResultViewController {
    func initUI() {
        view.backgroundColor = .white
        tableView = {
            let tableView = UITableView()
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.backgroundColor = .systemBlue
            return tableView
        }()
        
        backButton = {
            let backButton = ActionButton()
            backButton.translatesAutoresizingMaskIntoConstraints = false
            backButton.setTitle("Back", for: .normal)
            backButton.setTitleColor(UIColor.systemBlue , for: .normal)
            backButton.buttonIsClicked {
                self.dismiss(animated: true)
            }
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
                
                if self.placesAPIList.count == 0 {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            catch let error {
                // Error when there is no response or data returned from API
                print("\(String(describing: error.localizedDescription))")
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
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
                    let url = "\(firstImage.prefix!)500x300\(firstImage.suffix!)"
                    self.getImageDataHTTP(with: url, at: index)
                }
            }
            catch let error {
                print("\(String(describing: error.localizedDescription))")
            }
        })
    }
    
    func getImageDataHTTP(with imageURL: String, at index: Int) {
        let url = URL(string: imageURL)!
        let request = URLRequest(url: url)
        
        makeRequest(for: "image data", request: request, onCompletion: { data in
            self.placesAPIList[index].imageData = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
}


extension ResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "detailSegue", sender: placesAPIList[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let DetailVC = segue.destination as? DetailViewController, let selectedPlace = sender as? Place {
            DetailVC.selectedPlace = selectedPlace
        }
    }
}

extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("placeAPILISTCOUNT \(placesAPIList.count)")
        let count = placesAPIList.count
        return count == 0 ? 5 :count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell") as! ResultCell
        let place = placesAPIList[indexPath.row]
        cell.update(location: place, index: indexPath.row)
        return cell
    }
}
