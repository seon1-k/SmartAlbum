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
}
