import UIKit

class FavouritesViewController: UICollectionViewController {

    private let coreDataStorageManager = CoreDataStorageManager()
    
    private lazy var favouritePhotos: [Photo] = {
        return coreDataStorageManager.getData() as! [Photo]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favouritePhotos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        cell.imageView.image = UIImage(data: favouritePhotos[indexPath.item].imageData!)
        
        return cell
    }
}
