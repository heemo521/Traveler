//
//  DetailViewController.swift
//  TimeTraveler
//
//  Created by Heemo on 12/29/22.
//

// [] swipable images
import UIKit

class DetailViewController: UIViewController {
    var selectedPlace: Place!
    var shared = UserService.shared
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var likeStatusButton: UIButton!
    @IBOutlet weak var relatedPlace: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBAction func dismissButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = selectedPlace.name
        nameLabel.layer.cornerRadius = 10.0
        categoryLabel.text = selectedPlace.categories?.first?.name
        addressLabel.text = selectedPlace.address?.formatted_address
        if let imageData = selectedPlace.imageData {
            mainImageView.image = UIImage(data: imageData)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if shared.checkLikedPlace(id: selectedPlace.id!) {
            likeStatusButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeStatusButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    @IBAction func likeButtonClicked(_ sender: UIButton) {
        let id = selectedPlace.id!
        if shared.checkLikedPlace(id: id) {
          shared.unlikeAPlace(id: id)
          likeStatusButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
          shared.likeAPlace(id: id)
          likeStatusButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
}
