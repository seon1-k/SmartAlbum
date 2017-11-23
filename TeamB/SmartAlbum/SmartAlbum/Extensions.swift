//
//  Extensions.swift
//  SmartAlbum
//
//  Created by 진형탁 on 2017. 11. 24..
//  Copyright © 2017년 team-b. All rights reserved.
//

import Foundation
import Photos

extension UIImageView {
    
    func imageFromAssetURL(assetURL: String) {
        
        let asset = PHAsset.fetchAssets(withLocalIdentifiers: [assetURL], options: nil)
        //let asset = PHAsset.fetchAssets(withBurstIdentifier: assetURL, options: nil)

        guard let result = asset.firstObject else { return }

        let imageManager = PHImageManager.default()
        
        imageManager.requestImage(for: result, targetSize: CGSize(width: 200, height: 200), contentMode: PHImageContentMode.aspectFill, options: nil) { (image, _) -> Void in
            if let image = image {
                self.image = image
            }
        }
    }
}
