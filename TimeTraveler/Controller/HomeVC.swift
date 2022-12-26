//
//  HomeVC.swift
//  TimeTraveler
//
//  Created by Heemo on 12/25/22.
//

import UIKit

class HomeVC: UIViewController {
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel! // 0.25 from the left and 0.25 from the right
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }
}

private extension HomeVC {
    func updateUI() {
        // MARK: - Main Image Container
        
        view.
        imageViewContainer.layer.cornerRadius =
        imageViewContainer.frame.size.width / 2
        imageViewContainer.clipsToBounds = true
        imageViewContainer.layer.borderColor = UIColor.white.cgColor
        imageViewContainer.layer.borderWidth = 3
        
    }
    
}
