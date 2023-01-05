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
        
    var collectionView: UICollectionView!
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
    
    var likeButton: ActionButton!
    var dismissButton: ActionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        setupSubviews()
        setupLayout()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        scrollView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        likeButton.setImage(UIImage(systemName: shared.checkLikedPlace(id: selectedPlace.id!) ? "heart.fill" : "heart"), for: .normal)
    }
}

private extension DetailViewController {
    func initUI() {
        view.backgroundColor = .white
        
        collectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            let size = UIScreen.main.bounds
            layout.itemSize = CGSize(width: size.width, height: size.height * 0.6)
            layout.scrollDirection = .horizontal
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.isPagingEnabled = true
            collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
            collectionView.alwaysBounceVertical = false
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
        }()
        
        nameLabel = createLabel(with: selectedPlace.name!, size: 30, weight: .bold)
        nameLabel.layer.cornerRadius = 10.0
        
        categoryLabel = createLabel(with: "Category", size: 16, weight: .semibold)
        addressLabel = createLabel(with: "Address", size: 16, weight: .semibold)
        relatedPlaceLabel = createLabel(with: "Related Place", size: 16, weight: .semibold)
        
        categoryText = {
            let categoryText = UITextView()
            if let category = selectedPlace.categories?.first?.name {
                categoryText.text = category
            } else {
                categoryText.text = "None"
            }
            return categoryText
        }()
        addressText = {
            let addressText = UITextView()
            if let address = selectedPlace.address?.formatted_address {
                addressText.text = address
            } else {
                addressText.text = "Not available"
            }
            return addressText
        }()
        
//        relatedPlaceText.text = selectedPlace.
    }
    
    func setupSubviews() {
     
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: CGFloat(0.6)).isActive = true
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        contentView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor, constant: 40).isActive = true
        contentView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor, constant: -40).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -80).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 600).isActive = true
        
        likeButton = {
            let likeButton = ActionButton()
            likeButton.buttonIsClicked {
                let id = self.selectedPlace.id!
                if self.shared.checkLikedPlace(id: id) {
                    self.shared.unlikeAPlace(id: id)
                    likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                } else {
                    self.shared.likeAPlace(id: id)
                    likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                }
            }
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.setTitle("Like", for: .normal)
            likeButton.translatesAutoresizingMaskIntoConstraints = false
            return likeButton
        }()
        dismissButton = {
            let dismissButton = ActionButton()
            dismissButton.buttonIsClicked {
                self.dismiss(animated: true)
            }
            dismissButton.setTitle("Dismiss", for: .normal)
            dismissButton.setTitleColor(UIColor.systemBlue , for: .normal)
            dismissButton.backgroundColor = UIColor(cgColor: CGColor(red: 232/255, green: 232/255, blue: 235/255, alpha: 0.5))
            dismissButton.layer.cornerRadius = 10.0
            dismissButton.layer.masksToBounds = true
            dismissButton.translatesAutoresizingMaskIntoConstraints = false
            return dismissButton
        }()
    }
    
    func setupLayout() {
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryText.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressText.translatesAutoresizingMaskIntoConstraints = false
        relatedPlaceLabel.translatesAutoresizingMaskIntoConstraints = false
//        relatedPlaceText.translatesAutoresizingMaskIntoConstraints = false
        
//        contentView.addSubview(nameLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(categoryText)
        contentView.addSubview(addressLabel)
        contentView.addSubview(addressText)
        contentView.addSubview(relatedPlaceLabel)
//        contentView.addSubview(relatedPlaceText)
        contentView.addSubview(likeButton)
        view.addSubview(dismissButton)
 
        dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension DetailViewController: UIScrollViewDelegate {
//    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
//        <#code#>
//    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        <#code#>
//    }
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//     
//    }
}

extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected a picture")
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
        if let imageUrl = selectedPlace.imageUrl {
            cell.imageView.loadFrom(url: imageUrl)
        }
        return cell
    }
}

