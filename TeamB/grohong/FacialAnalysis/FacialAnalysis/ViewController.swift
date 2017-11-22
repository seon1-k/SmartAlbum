//
//  ViewController.swift
//  FacialAnalysis
//
//  Created by Seong ho Hong on 2017. 11. 16..
//  Copyright © 2017년 Seong ho Hong. All rights reserved.
//

import UIKit
import Vision
import AVFoundation

class ViewController: UIViewController {
    
    var selectedImage: UIImage? {
        didSet {
            self.blurredImage.image = selectedImage
            self.selectImage.image = selectedImage
        }
    }
    
    @IBOutlet weak var emotionLabel: UILabel!
    var faceImageInfo = [VNFaceObservation]()
    var faceImages = [UIImageView]()
    var selectedFace: UIImage?
    
    @IBOutlet weak var blurredImage: UIImageView!
    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var faceScrollView: UIScrollView!
    
    let picker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        picker.delegate = self
    }
    
    func detectFaces(image: CIImage) {
        
        let request = VNDetectFaceRectanglesRequest() { request, error in
            guard let faceResults = request.results as? [VNFaceObservation] else {
                fatalError("unexpected result type from VNCoreMLRequest")
            }
            
            DispatchQueue.main.async {
                self.displayUI(facesInfo: faceResults)
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
    
    func detectEmotion(image: CGImage) {
        emotionLabel.text = "detection emotion...."
        
        guard let model = try? VNCoreMLModel(for: CNNEmotions().model) else {
            fatalError("can't load Places ML model")
        }
        
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first else {
                    fatalError("unexpected result type from VNCoreMLRequest")
            }
            
            DispatchQueue.main.async {
                self?.emotionLabel.text = "\(Int(topResult.confidence * 100))%: \(topResult.identifier)"
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: image)
        
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print("error")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func galleryImagePickButton(_ sender: Any) {
        picker.sourceType = .savedPhotosAlbum
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    func displayUI(facesInfo: [VNFaceObservation]){
        if let faceImage = self.selectedImage {
            let imageRect = AVMakeRect(aspectRatio: faceImage.size, insideRect: self.selectImage.bounds)
            for (index, face) in facesInfo.enumerated() {
                let w = face.boundingBox.size.width * imageRect.width
                let h = face.boundingBox.size.height * imageRect.height
                let x = face.boundingBox.origin.x * imageRect.width
                let y = imageRect.maxY - (face.boundingBox.origin.y * imageRect.height) - h
                
                let layer = CAShapeLayer()
                layer.frame = CGRect(x: x, y: y, width: w, height: h)
                layer.borderColor = UIColor.red.cgColor
                layer.borderWidth = 1
                self.selectImage.layer.addSublayer(layer)
                
                let w2 = face.boundingBox.size.width * faceImage.size.width
                let h2 = face.boundingBox.size.height * faceImage.size.height
                let x2 = face.boundingBox.origin.x * faceImage.size.width
                let y2 = (1 - face.boundingBox.origin.y) * faceImage.size.height - h2
                let cropRect = CGRect(x: x2 * faceImage.scale, y: y2 * faceImage.scale, width: w2 * faceImage.scale, height: h2 * faceImage.scale)
                
                if let faceCgImage = faceImage.cgImage?.cropping(to: cropRect) {
                    let faceUiImage = UIImage(cgImage: faceCgImage, scale: faceImage.scale, orientation: .up)
                    let faceImage = UIImageView(frame: CGRect(x: 90*index, y: 0, width: 80, height: 80))
                    faceImage.image = faceUiImage
                    faceImage.isUserInteractionEnabled = true
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleFaceImageViewTap(_:)))
                    faceImage.addGestureRecognizer(tap)
                    
                    self.faceImages.append(faceImage)
                    self.faceScrollView.addSubview(faceImage)
                }
            }
            
            self.faceScrollView.contentSize = CGSize(width: 90*faceImages.count - 10, height: 80)
        }
    }

}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       picker.dismiss(animated: true, completion: nil)
        
        guard let uiImage = info[UIImagePickerControllerEditedImage] as? UIImage else {
            fatalError("unexpeted error pick picture")
        }
        self.selectedImage = uiImage
        
        guard let ciImage = CIImage(image: uiImage) else {
            fatalError("couldn't convert UIImage to CIImage")
        }
        detectFaces(image: ciImage)
    }
}

extension ViewController: UINavigationControllerDelegate {
    @objc func handleFaceImageViewTap(_ sender: UITapGestureRecognizer) {
        if let tappedImageView = sender.view as? UIImageView {
            self.detectEmotion(image: (tappedImageView.image?.cgImage)!)
        }
    }
}
