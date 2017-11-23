import UIKit

class ViewerVC: BaseVC {
    
    var pageViewController : UIPageViewController!
    var starIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        
    }
    override func setupPageController() {
        
        self.pageViewController =  UIPageViewController(transitionStyle:.scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController.dataSource = self
        
        let startVC = viewControllerAtIndex(index: starIndex)
        let viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .forward, animated: true, completion: nil)
        self.view.backgroundColor = UIColor.gray
        self.pageViewController.view.backgroundColor = UIColor.gray
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
    }
    
    
    private func setupConstraints() {
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view
            .trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant:0).isActive = true
        pageViewController.view
            .topAnchor.constraint(equalTo:self.view.topAnchor, constant:0).isActive = true
        //
        pageViewController.view
            .leadingAnchor.constraint(equalTo:self.view.leadingAnchor, constant:0).isActive = true
        
        pageViewController.view
            .heightAnchor.constraint(equalToConstant:500).isActive = true
    }
    
    
    
    
    
}




extension ViewerVC{
    
    func viewControllerAtIndex (index : Int) -> ContentVC {
        let vc : ContentVC = ContentVC()
        vc.index = index
        
        return vc
    }
    
    
}

extension ViewerVC:UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! ContentVC
        if(vc.index == 0){
            return nil
        }else{
            return  self.viewControllerAtIndex(index: vc.index - 1)
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! ContentVC
        
        return self.viewControllerAtIndex(index: vc.index + 1)
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}
