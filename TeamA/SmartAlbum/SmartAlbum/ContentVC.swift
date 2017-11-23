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
    }
    
    convenience init(img:UIImage) {
        self.init()
        self.img.image = img
        self.img.backgroundColor = UIColor.red
    }

    override func setupUI() {
        img.contentMode = .scaleAspectFill
        self.view.addSubview(img)
    }
    override func setupContstrains() {
        img.translatesAutoresizingMaskIntoConstraints = false
        img.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        img.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: 0).isActive = true
        img.widthAnchor.constraint(equalTo:view.widthAnchor, constant: 0).isActive = true
        img.heightAnchor.constraint(equalTo:view.heightAnchor, constant: 0).isActive = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
