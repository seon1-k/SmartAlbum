//
//  AnalysisAsset.swift
//  SmartAlbum
//
//  Created by 진형탁 on 2017. 11. 23..
//  Copyright © 2017년 team-b. All rights reserved.
//

import Foundation
import RealmSwift

class AnalysisAsset: Object {

    
    // MARK: - Property
    dynamic var url = String()
    dynamic var location = String()
    dynamic var creationDate = String()
    dynamic var keyword: String = String()
    dynamic var confidence: Double = Double()
    dynamic var isVideo: Bool = false
    
    // MARK: - Init
    override static func primaryKey() -> String? {
        return "url"
    }
    
    convenience init(url: String,isVideo: Bool, location: String, creationDate: String, keyword: String, confidence: Double) {
        self.init()
        
        self.url = url
        self.location = location
        self.creationDate = creationDate
        self.keyword = keyword
        self.confidence = confidence
        self.isVideo = isVideo
    }
    
}
