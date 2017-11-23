//
//  TestVC.swift
//  SmartAlbum
//
//  Created by SeonIl Kim on 2017. 11. 23..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import UIKit
import Photos
import RealmSwift

class TestVC: UIViewController {
    
    override func viewDidLoad() {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
//        UserDefaults.standard.set(Date(), forKey: "updateDate")
        
//        DBManager.updateData()
        
//        for i in 0..<fetch.count {
//            let item = fetch.object(at: i)
//            print(item.modificationDate)
//        }
        
      //  DBManager.initData()
//
//        DispatchQueue.main.async {
//            print(DBManager.getKeywords())
//            print(DBManager.getKeywords().count)
//        }
        
//        DBManager.groupByCity()
    }
}
