//
//  AnalysisViewController.swift
//  SmartAlbum
//
//  Created by 진형탁 on 2017. 11. 22..
//  Copyright © 2017년 team-b. All rights reserved.
//

import UIKit
import CoreML
import Vision

@available(iOS 11.0, *)
class AnalysisViewController: UIViewController {
    
    // MARK:- Properties
    
    @IBOutlet weak var dismissBtn: UIButton!
    var pickedImages: [UIImage] = [UIImage]()
    var delegate : SegueProtocol?
    
    
    // to be deleted
    @IBOutlet weak var scene: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    let model = MobileNet()
    
    // MARK:- Initialize
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(pickedImages.count)
        
        guard let image = self.pickedImages.last else {
            fatalError("no starting image")
        }
        
        scene.image = image
        predictUsingVision(image: image)
    }
    
    // MARK:- Outlet Action
    
    @IBAction func pressDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            self.delegate?.deleteAllPickedAssets()
        })
    }
    
    // MARK:- Prediction
    
    /*
     This uses the Vision framework to drive Core ML.
     Note that this actually gives a slightly different prediction. This must
     be related to how the UIImage gets converted.
     */
    func predictUsingVision(image: UIImage) {
        guard let visionModel = try? VNCoreMLModel(for: model.model) else {
            fatalError("Someone did a baddie")
        }
        
        let request = VNCoreMLRequest(model: visionModel) { request, error in
            if let observations = request.results as? [VNClassificationObservation] {
                
                // The observations appear to be sorted by confidence already, so we
                // take the top 5 and map them to an array of (String, Double) tuples.
                let top5 = observations.prefix(through: 4)
                    .map { ($0.identifier, Double($0.confidence)) }
                self.show(results: top5)
            }
        }
        
        request.imageCropAndScaleOption = .centerCrop
        
        let handler = VNImageRequestHandler(cgImage: image.cgImage!)
        try? handler.perform([request])
    }
    
    // MARK: - UI stuff
    
    typealias Prediction = (String, Double)
    
    func show(results: [Prediction]) {
        var s: [String] = []
        for (i, pred) in results.enumerated() {
            s.append(String(format: "%d: %@ (%3.2f%%)", i + 1, pred.0, pred.1 * 100))
        }
        
        answerLabel.text = s.joined(separator: "\n\n")
        
        ///////////
        let key: String = (results.first?.0)!
        let prob: Double = Double((results.first?.1)!) * 100
        tmpPredictedAssetArray.append(PredictedAsset(image: self.pickedImages.last!, keyword: key, probability: prob))
    }
    
    func top(_ k: Int, _ prob: [String: Double]) -> [Prediction] {
        precondition(k <= prob.count)
        
        return Array(prob.map { x in (x.key, x.value) }
            .sorted(by: { a, b -> Bool in a.1 > b.1 })
            .prefix(through: k - 1))
    }

}
