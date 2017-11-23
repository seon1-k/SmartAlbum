//
//  Viewer.swift
//  SmartAlbum
//
//  Created by 진호놀이터 on 2017. 11. 23..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import UIKit
import Photos
protocol PageCallback {
    func getBeforeIndex(index:Int) -> PHAsset
    func getAfterIndex(index:Int) -> PHAsset
}

class Viewer: BaseVC {
    
    var pageCallback: PageCallback?
    var pageViewController : UIPageViewController!
    var selectAsset:PHAsset!
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(asset:PHAsset){
        self.init()
        selectAsset = asset
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageController()
        setupConstraints()
        setupUI()
    }
    
    override func setupUI() {
        guard let date = selectAsset.creationDate else {
            return
        }
        navigationItem.title = "\(date)"
        self.navigationController?.navigationBar.prefersLargeTitles = false

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
            .heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1).isActive = true
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
            
            let beforeAsset =  self.pageCallback?.getBeforeIndex(index: vc.index - 1)
            let beforeImg = PhotoLibrary().getPhotoImage(asset: beforeAsset!, size: CGSize(width: 100, height: 100))
            let before = viewControllerAtIndex(index: vc.index - 1)
           before.img.image = beforeImg
            return  before
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! ContentVC
        print(self.pageCallback)
        let afterAsset =  self.pageCallback?.getBeforeIndex(index:vc.index + 1)
          let afterImg = PhotoLibrary().getPhotoImage(asset: afterAsset!, size: CGSize(width: 100, height: 100))
        let afterVC = viewControllerAtIndex(index:vc.index + 1)
        afterVC.img.image = afterImg
   
        return afterVC
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 5
    }
    
}



