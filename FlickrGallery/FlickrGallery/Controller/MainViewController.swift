//
//  ViewController.swift
//  FlickrGallery
//
//  Created by Max Kuznetsov on 26.06.2022.
//

import UIKit
import CoreData
import Kingfisher

class MainViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
        
    var photos: [[String:String]]? {
        didSet{
            collectionView.reloadData()
        }
    }
    
    var flickrNetworkManager = NetworkManager()
    var coreDataStorageManager = CoreDataStorageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func parseTopPhotos() {
        flickrNetworkManager.fetchFlickrPhotos { parsedPhotos in
            self.photos = parsedPhotos ?? []
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        parseTopPhotos()
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        let imageURL = URL(string: (photos?[indexPath.item]["imageData"])!)
        
        cell.imageView.kf.setImage(with: imageURL)
        
        return cell
    }
    
    
}
