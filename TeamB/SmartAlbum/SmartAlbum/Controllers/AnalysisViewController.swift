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
    
    // MARK:- Initialize
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(pickedImages.count)
    }
    
    // MARK:- Outlet Action
    
    @IBAction func pressDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            self.delegate?.deleteAllPickedAssets()
        })
    }
    
}
