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
        
    var collectionView = UICollectionView()
    var mainImageView: UIImageView!
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    var nameLabel: UILabel!
    var categoryLabel: UILabel!
    var categoryText: UITextView!
    var addressLabel: UILabel!
    var addressText: UITextView!
    var relatedPlaceLabel: UILabel!
    var relatedPlaceText: UITextView!
    
    var likeButton: UIButton!
    var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        setupLayout()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        likeButton.setImage(UIImage(systemName: shared.checkLikedPlace(id: selectedPlace.id!) ? "heart.fill" : "heart"), for: .normal)
    }
}

private extension DetailViewController {
    func initUI() {
        view.backgroundColor = .white
        
        nameLabel = createLabel(with: selectedPlace.name!, size: 30, weight: .bold)
        nameLabel.layer.cornerRadius = 10.0
        
        categoryLabel = createLabel(with: "Category", size: 16, weight: .semibold)
        categoryText.text = selectedPlace.categories?.first?.name ?? "None"
        addressLabel = createLabel(with: "Address", size: 16, weight: .semibold)
        addressText.text = selectedPlace.address?.formatted_address ?? "Not available"
        relatedPlaceLabel = createLabel(with: "Related Place", size: 16, weight: .semibold)
//        relatedPlaceText.text = selectedPlace.
    }
    
    func setupSubviews() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        collectionView.backgroundColor = .blue
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: CGFloat(0.6)).isActive = true
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        contentView.backgroundColor = .green
        contentView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor, constant: 40).isActive = true
        contentView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor, constant: -40).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -80).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 600).isActive = true
    }
    
    func setupLayout() {
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryText.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressText.translatesAutoresizingMaskIntoConstraints = false
        relatedPlaceLabel.translatesAutoresizingMaskIntoConstraints = false
        relatedPlaceText.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.translatesAutoresizingMaskIntoConstraints = false

//        contentView.addSubview(nameLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(categoryText)
        contentView.addSubview(addressLabel)
        contentView.addSubview(addressText)
        contentView.addSubview(relatedPlaceLabel)
        contentView.addSubview(relatedPlaceText)
        contentView.addSubview(likeButton)
        contentView.addSubview(dismissButton)
 
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

extension DetailViewController: UICollectionViewDelegate {
    
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}
extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
}
