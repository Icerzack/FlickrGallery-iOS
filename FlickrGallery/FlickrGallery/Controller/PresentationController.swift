import UIKit

class PresentationController: UIPageViewController {
    
    var photosToDisplay: [[String:String]]!
    var fromWhatIndex: Int!
    
    private lazy var orderedViewControllers: [UIViewController] = {
        var out: [UIViewController] = []
        for photo in photosToDisplay{
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PhotoViewController") as? PhotoViewController
            vc?.imageURL = photo["imageData"]
            vc?.labelText = photo["name"]
            out.append(vc!)
        }
        return out
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        let viewControllerToDisplay = orderedViewControllers[fromWhatIndex]
        setViewControllers([viewControllerToDisplay], direction: .forward, animated: true, completion: nil)
    }
}

extension PresentationController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
}
