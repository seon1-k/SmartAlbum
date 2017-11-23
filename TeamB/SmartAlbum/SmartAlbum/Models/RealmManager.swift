//
//  RealmManager.swift
//  SmartAlbum
//
//  Created by 진형탁 on 2017. 11. 23..
//  Copyright © 2017년 team-b. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

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
    
    // Delete local database
    func deleteDatabase() {
        try! realm.write({
            realm.deleteAll()
        })
    }
    
    // Save array of objects to database
    func saveObjects(objs: [Object]) {
        try! realm.write({
            // If update = true, objects that are already in the Realm will be
            // updated instead of added a new.
            realm.add(objs, update: true)
        })
    }
    
    // Get an array as Results<object>?
    func getObjects(type: Object.Type) -> Results<Object>? {
        return realm.objects(type)
    }
    
}
