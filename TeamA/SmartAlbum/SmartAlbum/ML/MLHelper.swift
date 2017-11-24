//
//  MLHelper.swift
//  SmartAlbum
//
//  Created by SeonIl Kim on 2017. 11. 23..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import Foundation
import CoreML
import Photos
import Vision

class MLHelper {
    
    static let imageSize:CGSize = CGSize(width: 300, height: 300) //분석을 위해 가져올 이미지 크기
    static let correctValue:Float = 0.5 //이 수치 이상일 경우 키워드를 입력함
    
    static func setKeyword(_ localIdentifier: String, completionHandler: @escaping (_ key:String?, _ error:String?) -> Void){
        //이미지에게 키워드 할당.
        //파라미터는 asset의 localidentifier
        //오류가 있거나, 일치하는 키워드가 없으면 공백 반환
        
        var image:UIImage?
        let asset:PHAsset = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil).firstObject!
        PHCachingImageManager().requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFit, options: nil, resultHandler: { img, _ in
            image = img
        })
        if image == nil {
            completionHandler(nil, "error")
        }
        
        
        guard let model = try? VNCoreMLModel(for: MobileNet().model) else {
            fatalError("cannot load model")
        }
        let request = VNCoreMLRequest(model: model){ request, error in
            guard let results = request.results as? [VNClassificationObservation], let topResult = results.first else {
                fatalError("error in VNCoreMLRequest")
            }
            
            if topResult.confidence >= correctValue {
                let keywords = topResult.identifier.components(separatedBy: ",")
                completionHandler(keywords.first, nil)
            }  else {
                completionHandler(nil, "error")
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: CIImage(image: image!)!)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
                completionHandler(nil, "error")
            }
        }
    }
}

