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

class AnalysisViewController: UIViewController {
    
    // MARK:- Properties
    
    @IBOutlet weak var dismissBtn: UIButton!
    var pickedImages: [UIImage] = [UIImage]()
    var delegate : SegueProtocol?
    
    
    // to be deleted
    @IBOutlet weak var scene: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    let vowels: [Character] = ["a", "e", "i", "o", "u"]
    
    // MARK:- Initialize
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(pickedImages.count)
        
        guard let image = self.pickedImages.popLast() else {
            fatalError("no starting image")
        }
        
        scene.image = image
        guard let ciImage = CIImage(image: image) else {
            fatalError("couldn't convert UIImage to CIImage")
        }
        
        detectScene(image: ciImage)
        
    }
    
    // MARK:- Detect Scene
    // to be deleted
    func detectScene(image: CIImage) {
        answerLabel.text = "detecing scene..."
        
        if #available(iOS 11.0, *) {
            guard let model = try? VNCoreMLModel(for: GoogLeNetPlaces().model) else {
                fatalError("can't load Places ML model")
            }
        } else {
            // Fallback on earlier versions
        }
        
        if #available(iOS 11.0, *) {
            
            guard let model = try? VNCoreMLModel(for: GoogLeNetPlaces().model) else {
                fatalError("can't load Places ML model")
            }
            let request = VNCoreMLRequest(model: model) { [weak self] request, error in
                guard let results = request.results as? [VNClassificationObservation],
                    let topResult = results.first else {
                        fatalError("unexpected result type from VNCoreMLRequest")
                }
                
                let article = (self?.vowels.contains(topResult.identifier.first!))! ? "an" : "a"
                DispatchQueue.main.async {
                    self?.answerLabel.text = "\(Int(topResult.confidence * 100))% it's \(article) \(topResult.identifier)"
                }
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
    
    
    // MARK:- Outlet Action
    
    @IBAction func pressDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            self.delegate?.deleteAllPickedAssets()
        })
    }
    
}
