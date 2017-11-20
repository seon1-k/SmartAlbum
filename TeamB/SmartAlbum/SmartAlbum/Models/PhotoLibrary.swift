//
//  PhotoLibrary.swift
//  SmartAlbum
//
//  Created by 진형탁 on 2017. 11. 20..
//  Copyright © 2017년 team-b. All rights reserved.
//

import Foundation
import Photos

class PhotoLibrary {
    fileprivate var imgManager: PHImageManager
    fileprivate var requestOptions: PHImageRequestOptions
    fileprivate var fetchOptions: PHFetchOptions
    fileprivate var fetchResult: PHFetchResult<PHAsset>
    
    init () {
        imgManager = PHImageManager.default()
        requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
    }

    var count: Int {
        return fetchResult.count
    }
    
    func setPhoto(at index: Int, completion block: @escaping (UIImage?)->()) {
        if index < fetchResult.count  {
            // As the size increases, there is an error that the image in the collectionview is not shown.
            // let thumbnailSize = UIScreen.main.bounds.size
            let thumbnailSize = CGSize(width: 100, height: 100)
            imgManager.requestImage(for: fetchResult.object(at: index) as PHAsset, targetSize: thumbnailSize, contentMode: PHImageContentMode.aspectFill, options: requestOptions) { (image, _) in
                block(image)
            }
        } else {
            block(nil)
        }
    }
    
    func getAllPhotos() -> [UIImage] {
        var resultArray = [UIImage]()
        for index in 0..<fetchResult.count {
            imgManager.requestImage(for: fetchResult.object(at: index) as PHAsset, targetSize: UIScreen.main.bounds.size, contentMode: PHImageContentMode.aspectFill, options: requestOptions) { (image, _) in
                
                if let image = image {
                    resultArray.append(image)
                }
            }
        }
        return resultArray
    }
}
