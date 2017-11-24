//
//  Date+Photo.swift
//  SmartAlbum
//
//  Created by 진호놀이터 on 2017. 11. 24..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import Foundation

extension Date {
    
 static   func getFottatDate(date:Date) -> String{
    let format = DateFormatter()
    format.locale = NSLocale(localeIdentifier: "ko_kr") as Locale!
    format.timeZone = TimeZone(abbreviation: "KST")
    format.dateFormat = "yyyy-MM-dd"
    let dateString = format.string(from: date)
        return dateString
    }
}
