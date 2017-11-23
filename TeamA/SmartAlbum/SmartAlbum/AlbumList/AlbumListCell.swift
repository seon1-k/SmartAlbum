//
//  AlbumListCell.swift
//  SmartAlbum
//
//  Created by 진호놀이터 on 2017. 11. 21..
//  Copyright © 2017년 진호놀이터. All rights reserved.
//

import UIKit

class AlbumListCell: UICollectionViewCell {
    static let indentifier:String = String(describing: AlbumListCell.self)
    var albumImgView: UIImageView = UIImageView()
    var titleLbl: UILabel = UILabel()
    var albumCountLbl: UILabel = UILabel()
    // var nameLabel:UILabel = UILabel()
    var representedAssetIdentifier: String!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        
    }
    
    
    
    
    private func setupUI(){
        
        //UI - contentView
        
        // UI - albumView
        albumImgView.contentMode = .scaleAspectFill
        albumImgView.clipsToBounds = true
        albumImgView.layer.cornerRadius = 10
        albumImgView.layer.masksToBounds = true
        // UI - addSubview
        
        
        titleLbl.textAlignment = .left
        titleLbl.font = .systemFont(ofSize: 13)
        
        albumCountLbl.textColor = UIColor.lightGray
        albumCountLbl.font = .systemFont(ofSize: 13)
        contentView.addSubview(albumImgView)
        contentView.addSubview(titleLbl)
        contentView.addSubview(albumCountLbl)
    }
    
    
    
    private func setupConstraints(){
        
        // let  marginGuide = contentView.layoutMarginsGuide
        // Constraints - albumImgView
        albumImgView.translatesAutoresizingMaskIntoConstraints = false
        
        albumImgView.leadingAnchor.constraint(equalTo:contentView.leadingAnchor, constant: 0).isActive = true
        
        albumImgView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1, constant: 0).isActive = true
        albumImgView.topAnchor.constraint(equalTo:contentView.topAnchor).isActive = true
        albumImgView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1
            , constant: 0).isActive = true
        
        // Constraints - titleLbl
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.topAnchor.constraint(equalTo: albumImgView.bottomAnchor).isActive = true
        titleLbl.leadingAnchor.constraint(equalTo: albumImgView.leadingAnchor, constant:
            0).isActive = true
        titleLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:0).isActive = true
        
        albumCountLbl.translatesAutoresizingMaskIntoConstraints = false
        albumCountLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 0).isActive = true
        albumCountLbl.leadingAnchor.constraint(equalTo:titleLbl.leadingAnchor, constant:0).isActive = true
        albumCountLbl.trailingAnchor.constraint(equalTo: titleLbl.trailingAnchor, constant:0).isActive = true
        
    }
    
    
    
    
    
}
