//
//  MediaCell.swift
//  SmartAlbum
//
//  Created by 진호놀이터 on 2017. 11. 23..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import UIKit

class MediaCell: UICollectionViewCell {
     static let indentifier:String = String(describing: MediaCell.self)
    var imgView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        
    }
    
    
    
    
    
    private func setupUI(){
        
    
        contentView.addSubview(imgView)
    }
    private func setupConstraints(){
        
            imgView.topAnchor.constraint(equalTo:contentView.topAnchor, constant:0).isActive = true
            imgView.leadingAnchor.constraint(equalTo:contentView.leadingAnchor, constant: 0).isActive = true
            imgView.widthAnchor.constraint(equalTo:contentView.widthAnchor, constant:0).isActive = true
            imgView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: 0).isActive = true
        
        
    }
    
}
