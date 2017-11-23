//
//  AnalysisAsset.swift
//  SmartAlbum
//
//  Created by 진형탁 on 2017. 11. 23..
//  Copyright © 2017년 team-b. All rights reserved.
//

import Foundation
import Realm

class AnalysisAsset: RLMObject {
    dynamic var url = ""
    dynamic var location = ""
    dynamic var creationDate = ""
    dynamic var keyword = ""

    override class func primaryKey() -> (String!) {
        return "url"
    }
    
    override init() {
        super.init()
    }
    
    init(url: String, location: String, creationDate: String, keyword: String) {
        super.init()
        
        self.url = url
        self.location = location
        self.creationDate = creationDate
        self.keyword = keyword
    }
}
