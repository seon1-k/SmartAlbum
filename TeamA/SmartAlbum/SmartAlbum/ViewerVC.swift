//
//  Viewer2VC.swift
//  SmartAlbum
//
//  Created by 진호놀이터 on 2017. 11. 24..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import UIKit
import Photos
class ViewerVC: BaseVC {
 private var collectionView: UICollectionView  = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    public var photos: PHFetchResult<PHAsset>!
    private let imageManager = PHCachingImageManager()
    private var selectIndexPath: IndexPath!
    private var scrollFlag : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    convenience init(asset: PHFetchResult<PHAsset>, index:Int) {
        self.init()
        self.photos = asset
        self.selectIndexPath = IndexPath(row: index, section: 0)
    }
    
    override func setupUI() {
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        collectionView.register(PictureCell.self, forCellWithReuseIdentifier:PictureCell.indentifier)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        view.addSubview(collectionView)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }
    
    override func setupContstrains(){
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant:0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo:view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo:view.trailingAnchor).isActive = true
    }
}

extension ViewerVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:String(describing: PictureCell.self), for: indexPath) as! PictureCell
        
        cell.contentView.backgroundColor = UIColor.blue
        let asset = photos.object(at: indexPath.item)
        
        if let date = asset.creationDate{
              navigationItem.title = "\(date)"
        }
      
        imageManager.requestImage(for: asset, targetSize: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            
            cell.pictureImgView.image = image
           
        })
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(scrollFlag == false) {
            collectionView.scrollToItem(at: selectIndexPath, at: .centeredHorizontally, animated: false)
            scrollFlag = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.view.bounds.size
    }

}
