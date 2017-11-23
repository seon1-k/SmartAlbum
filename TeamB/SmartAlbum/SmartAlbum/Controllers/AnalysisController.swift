//
//  AnalysisController.swift
//  SmartAlbum
//
//  Created by Seong ho Hong on 2017. 11. 23..
//  Copyright © 2017년 team-b. All rights reserved.
//

import UIKit
import Vision
import CoreML
import RealmSwift

class AnalysisController {
    func getInfo(image: CIImage, completion: @escaping(String, Double) -> Void ) {
        var keyword = String()
        var confidence = Double()
        
        guard let model = try? VNCoreMLModel(for: MobileNet().model) else {
            fatalError("can't load Places ML model")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first else {
                    fatalError(error.debugDescription)
            }
            
            keyword = topResult.identifier
            confidence = Double(topResult.confidence * 100)
            
            completion(keyword, confidence)
        }
        
        
        let handler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print("error")
            }
        }
    }
}

