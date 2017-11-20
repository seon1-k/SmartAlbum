//
//  AlbumModel.swift
//  SmartAlbum
//
//  Created by 진형탁 on 2017. 11. 19..
//  Copyright © 2017년 team-b. All rights reserved.
//

import Foundation

class AlbumModel {
    let name: String
    let count: Int
    let asset: NSMutableArray
 
    init(name: String, count: Int, asset: NSMutableArray) {
        self.name = name
        self.count = count
        self.asset = asset
    }
}
