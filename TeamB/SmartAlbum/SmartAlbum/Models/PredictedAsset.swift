//
//  PredictedAsset.swift
//  SmartAlbum
//
//  Created by 진형탁 on 2017. 11. 22..
//  Copyright © 2017년 team-b. All rights reserved.
//

import Foundation
import UIKit


class PredictedAsset {
    
    var image: UIImage?
    var keyword: String?
    var probability: Double?

    init(image: UIImage, keyword: String, probability: Double) {
        self.image = image
        self.keyword = keyword
        self.probability = probability
    }
    
    
//    var identifier: String?
//    var location: String?
//    var creationDate: String?
    
}
