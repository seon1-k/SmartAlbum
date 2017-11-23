//
//  Viewer.swift
//  SmartAlbum
//
//  Created by 진호놀이터 on 2017. 11. 23..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import UIKit

protocol pageCallback {
    
}

class Viewer: UIPageViewController {
    var imgView: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        setupUI()
        setupConstraints()
       
        
    }
    private func setupUI(){
        
     //   imgView.contentMode = .scaleAspectFill
    //    self.view.addSubview(imgView)
        
    }
    
  public  func viewControllerAtIndex (index : Int) -> ContentVC {
        let vc : ContentVC = ContentVC()
        vc.index = index
        
        return vc
    }
    
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
    
    private func setupConstraints(){
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.topAnchor.constraint(equalTo:view.topAnchor, constant: 0).isActive = true
        imgView.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: 0).isActive = true
        imgView.widthAnchor.constraint(equalTo:view.widthAnchor, constant: 0).isActive = true
        imgView.heightAnchor.constraint(equalTo:view.heightAnchor, constant: 0).isActive = true
        
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
