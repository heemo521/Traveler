//
//  SearchBarViewController.swift
//  TimeTraveler
//
//  Created by Heemo on 12/24/22.
//

import UIKit

class SearchLocationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var mapViewSwitch: UISwitch!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func searchTextChanged(_ sender: UITextField) {
        print(searchTextField.text!)
    }
}

private extension SearchLocationViewController {
    func updateUI() {}

    
    @IBAction func mapViewToggle(_ sender: UISwitch) {
        print("Toggled")
    }
    
//    func httpRequest(with query: String) {
//        let categories:[buildURLRequest.Categories] = [.historic, .nationalPark]
//        let combinedCategories = categories.map({$0.rawValue}).joined(separator: ",")
//        let request = buildURLRequest.build(for: "get", with: ["near" : query, "categories": combinedCategories])
//
//        if let request = request {
//            URLSession.shared.dataTask(with: request) { (data, response, error) in
//                if error == nil {
//                    guard let data = data else {
//                        print("Failed to receive data \(String(describing: error?.localizedDescription))")
//                        return
//                    }
//                    do {
//                        let decoder = JSONDecoder()
//                        let dataDecoded = try decoder.decode(Response.self, from: data)
////                        self.fetchedLocationList = dataDecoded.results
////                        print("decodedData: \(dataDecoded.results.first!.name!)")
////                        DispatchQueue.main.async {
////                            self.tableView.reloadData()
////                        }
////
//                    }
//                    catch let error {
//                        print("\(String(describing: error.localizedDescription))")
//                    }
//                } else {
//                    print("Error from request \(String(describing: error?.localizedDescription))")
//                }
//
//            }.resume()
//        }
//
//    }
}

extension SearchLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
