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
class PhotoLibrary: NSObject{
    
    private var imageManager: PHCachingImageManager = PHCachingImageManager()
    
    func getPhotoImage(asset:PHAsset,size:CGSize) -> UIImage{
        var resultImage: UIImage = UIImage()
        imageManager.requestImage(for: asset, targetSize:size, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            
            resultImage = image!
            
        })
        
        return resultImage
    }
    
}
