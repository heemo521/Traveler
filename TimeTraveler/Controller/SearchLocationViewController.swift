//
//  SearchLocationViewController.swift
//  TimeTraveler
//
//  Created by Heemo on 12/24/22.
//

import UIKit

class SearchLocationViewController: UIViewController {

    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapViewSwtich: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func textValueChanged(_ sender: UITextField) {
        print(search.text!)
    }
    
    @IBAction func mapViewToggled(_ sender: UISwitch) {
        // When toggle is on, the tableview should be replaced by map view with a list of places
        print(mapViewSwtich.isOn ? "On" : "Off")
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
