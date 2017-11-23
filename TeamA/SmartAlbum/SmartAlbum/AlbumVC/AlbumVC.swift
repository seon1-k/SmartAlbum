//
//  AlbumVC.swift
//  SmartAlbum
//
//  Created by 진호놀이터 on 2017. 11. 19..
//  Copyright © 2017년 진호놀이터. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class AlbumVC: UIViewController {
    
    private let layout = UICollectionViewFlowLayout()
    public var allPhotos: PHFetchResult<PHAsset>!
    private let imageManager = PHCachingImageManager()
    private var collectionView: UICollectionView  = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var searchField:UITextField = UITextField()
    
    var searchBtn:UIButton = UIButton(type: UIButtonType.system)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(asset: PHFetchResult<PHAsset>, title:String) {
        self.init()
        self.allPhotos = asset
        self.navigationItem.title = title
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setUpConstraints()
        fetchAllPhotos()
    }
    
    private func setupUI(){
        
        collectionView.register(PictureCell.self, forCellWithReuseIdentifier:PictureCell.indentifier)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchField.borderStyle = .roundedRect
        searchField.layer.borderColor = UIColor.gray.cgColor
        searchField.layer.borderWidth = 1.0
        
        searchBtn.setTitle("찾기", for: .normal)
        searchBtn.titleLabel?.textColor = UIColor.black
        
        let imageView = UIImageView();
        let image = UIImage(named: "search");
        imageView.image = image;
        imageView.frame = CGRect(x: 10, y: 5, width: 20, height: 20)
        searchField.addSubview(imageView)
        let leftView = UIView.init(frame: CGRect(x: 10, y: 0, width: 30, height: 30))
        searchField.leftView = leftView;
        searchField.leftViewMode = UITextFieldViewMode.always
        
        
        view.addSubview(searchField)
        view.addSubview(searchBtn)
        view.addSubview(collectionView)
        
    }
    private func setUpConstraints(){
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        collectionView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo:view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo:view.trailingAnchor).isActive = true
        
    }
    
    private  func fetchAllPhotos() {
        //    let allPhotosOptions = PHFetchOptions()
        //    allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        //    allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        collectionView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension AlbumVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:String(describing: PictureCell.self), for: indexPath) as! PictureCell
        
        cell.contentView.backgroundColor = UIColor.blue
        let asset = allPhotos.object(at: indexPath.item)
        
        cell.representedAssetIdentifier = asset.localIdentifier
        print(asset.localIdentifier)
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            
            cell.pictureImgView.image = image
            
            
            
        })
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:UIScreen.main.bounds.width/4 - 1, height:UIScreen.main.bounds.width/4 - 1)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    
}

