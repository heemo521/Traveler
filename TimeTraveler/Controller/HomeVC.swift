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
    @IBOutlet weak var guideView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        scalingAnimation()
//        imageViewContainer.translatesAutoresizingMaskIntoConstraints = false
        // Do any additional setup after loading the view.
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        scalingAnimation()
    }
}

private extension HomeVC {
//    func viewOrientationChange() {
//
//    }
    func scalingAnimation() {
        if UIDevice.current.orientation.isLandscape {
            print("lanscape")
            UIView.animate(withDuration: 0.6, animations: {
                self.imageViewContainer.transform = CGAffineTransform.identity
            }, completion: { _ in
                UIView.animate(withDuration: 0.6, animations: {
                    self.imageViewContainer.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                })
            })
        } else {
//          imageViewContainer.widthAnchor.constraint(equalToConstant: 150).isActive = false
            print("portrait")
            UIView.animate(withDuration: 0.6, animations: {
                self.imageViewContainer.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            }, completion: { _ in
                UIView.animate(withDuration: 0.6, animations: {
                     self.imageViewContainer.transform = CGAffineTransform.identity
                })
            })
        }
    }
    
    func updateUI() {
        // MARK: - Main Image Container
        
        imageViewContainer.layer.cornerRadius = imageViewContainer.frame.width / 2
        imageViewContainer.clipsToBounds = true
        imageViewContainer.layer.borderColor = UIColor.gray.cgColor
        imageViewContainer.layer.borderWidth = 1
        
    }
    
}
