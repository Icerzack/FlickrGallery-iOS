import UIKit
import CoreData
import Kingfisher

class MainViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    private var photos: [[String:String]]? {
        didSet{
            collectionView.reloadData()
        }
    }
    
    private var flickrNetworkManager = AFNetworkManager()
    private var coreDataStorageManager = CoreDataStorageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.square.fill"), style: .plain, target: self, action: #selector(openFavouritesViewController))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        parseTopPhotos()
    }
    
    private func parseTopPhotos() {
        flickrNetworkManager.fetchFlickrPhotos { parsedPhotos in
            self.photos = parsedPhotos ?? []
        }
    }
    
    @objc private func openFavouritesViewController(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FavouritesViewController") as? FavouritesViewController
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    private func downloadImage(with urlString : String, completion: @escaping ((UIImage) -> Void)){
        guard let url = URL.init(string: urlString) else {
            return
        }
        let resource = ImageResource(downloadURL: url)
        
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                completion(value.image)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
}


// MARK: CollectionView setup
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PresentationViewController") as? PresentationController
        pc?.photosToDisplay = photos
        pc?.fromWhatIndex = indexPath.item
        navigationController?.pushViewController(pc!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        configureContextMenu(index: indexPath.row)
    }
    
    func configureContextMenu(index: Int) -> UIContextMenuConfiguration {
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            
            let add = UIAction(title: "Добавить к себе", image: UIImage(systemName: "plus.circle.fill"), attributes: []) { [self] _ in
                let name = photos?[index]["name"]
                let imageDataURL = photos?[index]["imageData"]
                downloadImage(with: imageDataURL!) { image in
                    self.coreDataStorageManager.saveData(withName: name!, withPhoto: image.pngData()!)
                }
            }
            return UIMenu(title: "Действия", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [add])
            
        }
        return context
    }
    
}
