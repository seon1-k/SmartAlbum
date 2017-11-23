//
//  RealmManager.swift
//  SmartAlbum
//
//  Created by Seong ho Hong on 2017. 11. 24..
//  Copyright © 2017년 team-b. All rights reserved.
//

import Foundation
import RealmSwift

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        
        return array
    }
}

class RealmManager {
    let realm = try! Realm()
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(setDB),
                                               name: NSNotification.Name(rawValue: "setData"), object: nil)
    }
    
    @objc func setDB(_ notification: NSNotification) {
        let realm = try! Realm()

        try! realm.write {
            if let url = notification.userInfo?["url"] as? String,
                let isVideo = notification.userInfo?["isVideo"] as? Bool,
                let location = notification.userInfo?["location"] as? String,
                let creationDate = notification.userInfo?["creationDate"] as? String,
                let keyword = notification.userInfo?["keyword"] as? String,
                let confidence = notification.userInfo?["confidence"] as? Double {
                
                let analysisAsset = AnalysisAsset(url: url, isVideo: isVideo, location: location, creationDate: creationDate, keyword: keyword, confidence: confidence)
                
                realm.add(analysisAsset, update: true)
            }
        }
    }
    
    func getObjects(type: Object.Type) -> Results<Object>? {
        return realm.objects(type)
    }
}
