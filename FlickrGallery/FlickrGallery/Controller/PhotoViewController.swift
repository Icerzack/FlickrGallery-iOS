import UIKit

class PhotoViewController: UIViewController {

    var imageURL: String!
    var labelText: String!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.kf.setImage(with: URL(string: imageURL))
        label.text = labelText
    }

}
