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
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(detectEmmotion),
                                              name: NSNotification.Name(rawValue: "detectEmmotion"), object: nil)
    }
    
    func detectFace(image: CIImage, completion: @escaping(Int) -> Void ) {
        let request = VNDetectFaceRectanglesRequest() { request, error in

            guard let faceResults = request.results as? [VNFaceObservation] else {
                fatalError(error.debugDescription)
            }
            
            completion(faceResults.count)
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
    
    @objc func detectEmmotion(_ notification: NSNotification) {
        if let url = notification.userInfo?["url"] as? String,
            let isVideo = notification.userInfo?["isVideo"] as? Bool,
            let location = notification.userInfo?["location"] as? String,
            let creationDate = notification.userInfo?["creationDate"] as? String,
            let ciImage = notification.userInfo?["ciImage"] as? CIImage {
            
            guard let model = try? VNCoreMLModel(for: CNNEmotions().model) else {
                fatalError("can't load Places ML model")
            }
            
            let request = VNCoreMLRequest(model: model) { request, error in
                guard let results = request.results as? [VNClassificationObservation],
                    let topResult = results.first else {
                        fatalError("unexpected result type from VNCoreMLRequest")
                }
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setData"), object: nil, userInfo: ["url": url, "isVideo": isVideo, "location": location, "creationDate": creationDate, "keyword": topResult.identifier, "confidence": Double(topResult.confidence * 100)])
            }
            
            guard let cgImage = ciImage.cgImage else {
                fatalError("no cgImage")
            }
            
            let handler = VNImageRequestHandler(cgImage: cgImage)
            
            DispatchQueue.global(qos: .utility).async {
                do {
                    try handler.perform([request])
                } catch {
                    print("error")
                }
            }
        }
    }
    
    func getInfo(image: CIImage, completion: @escaping(String, Double) -> Void ) {
        var keywordOfWord = String()
        var confidence = Double()

        guard let model = try? VNCoreMLModel(for: MobileNet().model) else {
            fatalError("can't load Places ML model")
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first else {
                    fatalError(error.debugDescription)
            }

            keywordOfWord = topResult.identifier
            confidence = Double(topResult.confidence * 100)

            let word = keywordOfWord.components(separatedBy: " ")

            completion(word[1], confidence)
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
