//
//  Viewer.swift
//  SmartAlbum
//
//  Created by 진호놀이터 on 2017. 11. 23..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import UIKit

protocol PageCallback {
    func getBeforeIndex(index:Int) -> UIImage
    func getAfterIndex(index:Int) -> UIImage
}

class Viewer: BaseVC {
    
    var pageCallback: PageCallback?
    var pageViewController : UIPageViewController!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageController()
        setupConstraints()
        
    }
    
    override func setupPageController() {
        
        self.pageViewController =  UIPageViewController(transitionStyle:.scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController.dataSource = self
        
        let startVC = viewControllerAtIndex(index: 0)
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
    
extension Viewer{
    
    func viewControllerAtIndex (index : Int) -> ContentVC {
        let vc : ContentVC = ContentVC()
        vc.index = index
        
        return vc
    }
    
}

extension Viewer:UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! ContentVC
        if(vc.index == 0){
            return nil
        }else{
            
            let beforeImg =  self.pageCallback?.getBeforeIndex(index: vc.index - 1)
            let before = viewControllerAtIndex(index: vc.index - 1)
           before.img.image = beforeImg
            return  before
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! ContentVC
        print(self.pageCallback)
        let afterImg =  self.pageCallback?.getBeforeIndex(index:vc.index + 1)
        let afterVC = viewControllerAtIndex(index:vc.index + 1)
        afterVC.img.image = afterImg
   
        return afterVC
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}



