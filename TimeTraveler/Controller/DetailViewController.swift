//
//  DetailViewController.swift
//  TimeTraveler
//
//  Created by Heemo on 12/29/22.
//

import UIKit

class DetailViewController: UIViewController {
    var selectedPlace: Place!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = selectedPlace.name
//        mainImageView.image
    }
    


}
