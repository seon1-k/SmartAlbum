//
//  Date+Photo.swift
//  SmartAlbum
//
//  Created by 진호놀이터 on 2017. 11. 24..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import Foundation

extension Date {
    
    func getDayOfWeek() -> Int {
        //일요일 1 월요일 2
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: self)
        return weekDay
    }
    
    func getFottatDate(date:Date) -> Date{
        let df : DateFormatter = DateFormatter()
        df.dateFormat = "yy년 MM월 dd일"
        
        let date : Date = df.date(from: "16년 7월 3일")!
   
            return date
    }
}
