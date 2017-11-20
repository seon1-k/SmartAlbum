//
//  AllAlbumsViewController.swift
//  SmartAlbum
//
//  Created by 진형탁 on 2017. 11. 20..
//  Copyright © 2017년 team-b. All rights reserved.
//

import UIKit
import Photos

class AllAlbumsViewController: UIViewController {
    
    // MARK:- Properties
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var albumsCollectionView: UICollectionView!
    
    let sectionInsets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    let itemsPerRow: CGFloat = 4
    var albumArray = NSMutableArray()
    
    // MARK:- Initialize

    override func viewDidLoad() {
        super.viewDidLoad()

        albumsCollectionView.delegate = self
        albumsCollectionView.dataSource = self
        
        self.spinner.hidesWhenStopped = true
        self.spinner.startAnimating()
        
        // Get assets from all albums
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                self.getAllAssets()
            case .denied, .restricted:
                print("Not allowed")
                // TODO: Add alertview
                self.spinner.stopAnimating()
            case .notDetermined:
                // TODO: Add alertview
                print("Not determined yet")
                self.spinner.stopAnimating()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK:- Help functions
    
    func getAllAssets() {
        let fetchOptions = PHFetchOptions()
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: fetchOptions)
        // the root of the photo library’s hierarchy of user-created albums and folders
        let topLevelfetchOptions = PHFetchOptions()
        let topLevelUserCollections = PHCollectionList.fetchTopLevelUserCollections(with: topLevelfetchOptions)
        
        var name: String = ""
        
        smartAlbums.enumerateObjects({
            let collection: PHAssetCollection = $0.0
            let result = PHAsset.fetchAssets(in: collection, options: nil)
            let imgArray = NSMutableArray()
            name = collection.localizedTitle! // Album's Title
            
            result.enumerateObjects({ (object, index, stop) -> Void in
                let asset = object
                imgArray.add(self.getAssetThumbnail(asset: asset))
            })
            // Append to albumArray
            if imgArray.count > 0 {
                let newAlbum = AlbumModel(name: name, count: collection.estimatedAssetCount, asset: imgArray)
                self.albumArray.add(newAlbum)
            }
        })
        
        topLevelUserCollections.enumerateObjects({
            if let collection = $0.0 as? PHAssetCollection {
                let imgArray = NSMutableArray()
                let result = PHAsset.fetchAssets(in: collection, options: nil)
                name = collection.localizedTitle!
                
                result.enumerateObjects({ (object, index, stop) -> Void in
                    let asset = object
                    imgArray.add(self.getAssetThumbnail(asset: asset))
                })
                if imgArray.count > 0 {
                    let newAlbum = AlbumModel(name: name, count: collection.estimatedAssetCount, asset: imgArray)
                    self.albumArray.add(newAlbum)
                }
            }
        })
        self.albumsCollectionView.reloadData()
        self.spinner.stopAnimating()
    }
    
    // Convert PHAseet to UIImage
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info) -> Void in
            thumbnail = result!
        })
        
        return thumbnail
    }

}

// MARK:- UICollectionViewDelegate, UICollectionViewDataSource {

extension AllAlbumsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.albumArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let album = self.albumArray[section] as! AlbumModel
        print("count = \(album.asset.count)")
        return album.asset.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let album = self.albumArray[indexPath.section] as! AlbumModel
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AssetCell", for: indexPath) as! AssetCell
        
        cell.thumbnail.image = album.asset.object(at: indexPath.row) as? UIImage
        cell.thumbnail.contentMode = .scaleAspectFill
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("get selected collectionview itemindex \(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let assetHeader: AssetHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AssetHeaderView", for: indexPath) as! AssetHeaderView
        let album = self.albumArray[indexPath.section] as! AlbumModel
        assetHeader.albumTitle.text = album.name
        
        return assetHeader
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AllAlbumsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow+1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}


