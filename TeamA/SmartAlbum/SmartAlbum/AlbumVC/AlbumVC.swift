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

class AlbumVC: BaseVC {
    var pageViewController : UIPageViewController!
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

    }
    
    override func setupUI(){
        
        collectionView.register(PictureCell.self, forCellWithReuseIdentifier:PictureCell.indentifier)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    override func setupContstrains(){
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        collectionView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo:view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo:view.trailingAnchor).isActive = true
        
    }
    
    private  func fetchAllPhotos() {
       
        collectionView.reloadData()
        
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
      
        
        let asset = allPhotos.object(at: indexPath.item)
          let pageVC = Viewer(asset:asset)
        let currentImg = PhotoLibrary().getPhotoImage(asset: asset, size: CGSize(width: 100, height: 100))
        let contentVC = ContentVC(img: currentImg)
        self.navigationController?.pushViewController(pageVC, animated: false)
      
        self.navigationController?.view.addSubview(pageVC.view)
        pageVC.pageViewController.setViewControllers([contentVC], direction: .forward, animated: true, completion: nil)
       
        
        pageVC.pageCallback = self
        contentVC.index = indexPath.row
        
        
        print(pageVC.view.frame)
        print(contentVC.view.frame)
    }
}

extension AlbumVC: PageCallback{
    func getAfterIndex(index: Int) -> PHAsset {
        
      let beforeAsset = allPhotos.object(at: index)

        return beforeAsset
    }
    
    func getBeforeIndex(index: Int) -> PHAsset {
        let afterAsset = allPhotos.object(at: index)

        return afterAsset
    }
    
}
