//
//  HomeVC.swift
//  TimeTraveler
//
//  Created by Heemo on 12/25/22.
//

import UIKit
import MapKit

class HomeVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var iconLabel: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
 
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
        imageViewContainer.layer.borderWidth = 3
        
        categoryLabel.layer.cornerRadius = 15.0
        
        //        imageViewContainer.clipsToBounds.tr
        categoryLabel.layer.borderColor = UIColor.gray.cgColor
        categoryLabel.layer.borderWidth = 1
        categoryLabel.layer.backgroundColor = UIColor.systemBlue.cgColor
        categoryLabel.textColor = UIColor.white
        
        descriptionLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
    }
    
}
