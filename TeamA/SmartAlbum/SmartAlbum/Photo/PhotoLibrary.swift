//
//  PhotoLibrary.swift
//  SmartAlbum
//
//  Created by 진호놀이터 on 2017. 11. 23..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import Foundation
import UIKit
import Photos
enum MediaType{
    case Image
    case Video
    case Default
}

class PhotoLibrary: NSObject{
    
    private var imageManager: PHImageManager = PHImageManager()
    private var requestOption:PHImageRequestOptions = PHImageRequestOptions()
    private var fetchOptions:PHFetchOptions = PHFetchOptions()
    
    func getImageRequestOptions(type:MediaType){
        requestOption.isSynchronous = true
        switch type {
        case .Image:
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            break
        case .Video:
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
        case .Default:
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d ||mediaType = %d ", PHAssetMediaType.video.rawValue,PHAssetMediaType.video.rawValue)
            break
        }
        
        

    }
    func getFetchOptions() -> PHFetchOptions{
      
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        return fetchOptions
    }

    func getPhotoImage(asset:PHAsset,size:CGSize) -> UIImage{
        getImageRequestOptions(type: .Image)
        var resultImage: UIImage = UIImage()
        imageManager.requestImage(for: asset, targetSize:size, contentMode: .aspectFill, options:requestOption , resultHandler: { image, _ in
            resultImage = image!
        })
        return resultImage
    }
    
    
//        func getAlbums() {
//            let options:PHFetchOptions = PHFetchOptions()
//            self.albumsList  = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: options)
//            // 앨범 정보
//            guard let albums = albumsList else{return}
//            for i in 0 ..< albums.count{
//                let collection = albums[i]
//                // . localizedTitle = 앨범 타이틀
//                let title : String = collection.localizedTitle!
//    
//                if(collection.estimatedAssetCount != nil){
//                    // . estimatedAssetCount = 앨범 내 사진 수
//                    let assetsFetchResult: PHFetchResult = PHAsset.fetchAssets(in: collection, options: nil)
//                    print("assetsFetchResult.count=\(assetsFetchResult.count)")
//    
//                    let count : Int = collection.estimatedAssetCount
//                    //  print(count)
//                    print(title)
//                }else{
//                }
//            }
//        }
    
}
