//
//  ViewController.swift
//  FacialAnalysis
//
//  Created by Seong ho Hong on 2017. 11. 16..
//  Copyright © 2017년 Seong ho Hong. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {
    
    var selectedImage: UIImage? {
        didSet {
            self.blurredImage.image = selectedImage
            self.selectImage.image = selectedImage
        }
    }
    
    var faceImageViews = [VNFaceObservation]()
    
    @IBOutlet weak var blurredImage: UIImageView!
    @IBOutlet weak var selectImage: UIImageView!
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func galleryImagePickButton(_ sender: Any) {
        picker.sourceType = .savedPhotosAlbum
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
