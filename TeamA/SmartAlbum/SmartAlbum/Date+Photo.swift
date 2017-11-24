//
//  Date+Photo.swift
//  SmartAlbum
//
//  Created by 진호놀이터 on 2017. 11. 24..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import Foundation

extension Date {
    
 static   func getFottatDate(date:Date) -> Date{
        let df : DateFormatter = DateFormatter()
        df.dateFormat = "yy년 MM월 dd일"
        
        let date : Date = df.date(from: "16년 7월 3일")!
            return date
    }
}
