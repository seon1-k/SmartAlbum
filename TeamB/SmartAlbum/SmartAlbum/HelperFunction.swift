//
//  HelperFunction.swift
//  SmartAlbum
//
//  Created by 진형탁 on 2017. 11. 24..
//  Copyright © 2017년 team-b. All rights reserved.
//

import Foundation

func createDate(stringDate: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd"
    return formatter.date(from: stringDate)!
}
