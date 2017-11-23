//
//  ContentVC.swift
//  SmartAlbum
//
//  Created by 진호놀이터 on 2017. 11. 23..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import UIKit

class ContentVC: BaseVC {
    public var index: Int!
    var img: UIImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()

     
        // Do any additional setup after loading the view.
    }

    override func setupUI() {
        
        view.backgroundColor = UIColor.blue
    }
    override func setupContstrains() {
        img.translatesAutoresizingMaskIntoConstraints = true
        img.topAnchor.constraint(equalTo:view.topAnchor, constant: 0).isActive = true
        img.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: 0).isActive = true
        img.widthAnchor.constraint(equalTo:view.widthAnchor, constant: 0).isActive = true
        img.heightAnchor.constraint(equalTo:view.heightAnchor, constant: 0).isActive = true
        
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
