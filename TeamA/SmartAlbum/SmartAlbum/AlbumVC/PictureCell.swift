//
//  PictureCell.swift
//  SmartAlbum
//
//  Created by 진호놀이터 on 2017. 11. 19..
//  Copyright © 2017년 진호놀이터. All rights reserved.
//

import UIKit

class PictureCell: UICollectionViewCell {
      static let indentifier: String = String(describing: PictureCell.self)
    var representedAssetIdentifier: String!
    let pictureImgView: UIImageView = UIImageView()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        
    }
    private func setupUI(){
        
        contentView.addSubview(pictureImgView)
        pictureImgView.contentMode = .scaleAspectFill
        pictureImgView.clipsToBounds = true
        
    }
    private func setupConstraints(){
        
        pictureImgView.translatesAutoresizingMaskIntoConstraints = false
        pictureImgView.topAnchor.constraint(equalTo:contentView.topAnchor).isActive = true
        pictureImgView.bottomAnchor.constraint(equalTo:contentView.bottomAnchor).isActive = true
        pictureImgView.leadingAnchor.constraint(equalTo:contentView.leadingAnchor).isActive = true
        pictureImgView.trailingAnchor.constraint(equalTo:contentView.trailingAnchor).isActive = true
        pictureImgView.heightAnchor.constraint(equalToConstant: self.contentView.frame.height).isActive = true
    }
    
    
}
