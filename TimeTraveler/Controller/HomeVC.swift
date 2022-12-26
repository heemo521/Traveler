//
//  HomeVC.swift
//  TimeTraveler
//
//  Created by Heemo on 12/25/22.
//

import UIKit

class HomeVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }
}

private extension HomeVC {
    func updateUI() {
        // MARK: - Main Image Container
        
        imageViewContainer.translatesAutoresizingMaskIntoConstraints = false
        imageViewContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
//        imageViewContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 100).isActive = true
        imageViewContainer.widthAnchor.constraint(equalToConstant: 300).isActive = true
        imageViewContainer.heightAnchor.constraint(equalToConstant: 300).isActive = true
        imageViewContainer.layer.cornerRadius =
        imageViewContainer.frame.size.width / 2
        imageViewContainer.clipsToBounds = true
        imageViewContainer.layer.borderColor = UIColor.white.cgColor
        imageViewContainer.layer.borderWidth = 3
        
    }
    
}
