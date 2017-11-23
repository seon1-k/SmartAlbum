//
//  AlbumDataModel.swift
//  SmartAlbum
//
//  Created by 진호놀이터 on 2017. 11. 21..
//  Copyright © 2017년 진호놀이터. All rights reserved.
//

import UIKit
import RealmSwift

class AlbumDataModel: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var createDate: Date = Date()
    //    dynamic var uuid: String = UUID().uuidString
    let photos: List<Photo> = List<Photo>()
    
    //    override class func primaryKey() -> String? {
    //        return "uuid"
}

class Photo: Object {
    @objc dynamic var createDate: Date = Date()
    @objc dynamic var image: Data = Data()
}





