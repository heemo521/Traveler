//
//  DetailViewController.swift
//  TimeTraveler
//
//  Created by Heemo on 12/29/22.
//

// [] swipable images
import UIKit

class DetailViewController: SuperUIViewController {
    var selectedPlace: Place!
    let shared = UserService.shared
    
    var scrollView = UIScrollView()
    var guideView = UIView()
    var mainImageView: UIImageView!
    var nameLabel: UILabel!
    var relatedPlace: UILabel!
    var addressLabel: UILabel!
    var categoryLabel: UILabel!
    var likeButton: UIButton!
    var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        setupLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        likeButton.setImage(UIImage(systemName: shared.checkLikedPlace(id: selectedPlace.id!) ? "heart.fill" : "heart"), for: .normal)
    }
}

private extension DetailViewController {
    func initUI() {
        nameLabel.text = selectedPlace.name
        nameLabel.layer.cornerRadius = 10.0
        categoryLabel.text = selectedPlace.categories?.first?.name
        addressLabel.text = selectedPlace.address?.formatted_address
        if let imageUrl = selectedPlace.imageUrl {
            mainImageView.loadFrom(url: imageUrl)
        }
    }
    
    func setupScrollView() {
        
    }
    
    func setupLayout() {
        //        var mainImageView: UIImageView!
        //        var nameLabel: UILabel!
        //        var relatedPlace: UILabel!
        //        var addressLabel: UILabel!
        //        var categoryLabel: UILabel!
        //        var likeButton: UIButton!
        //        var dismissButton: UIButton!
    }
    
    @objc func dismissButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc private func likeButtonClicked() {
        let id = selectedPlace.id!
        if shared.checkLikedPlace(id: id) {
          shared.unlikeAPlace(id: id)
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
          shared.likeAPlace(id: id)
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
}
