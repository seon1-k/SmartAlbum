//
//  DBManager.swift
//  SmartAlbum
//
//  Created by SeonIl Kim on 2017. 11. 23..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

//
//  DBManager.swift
//  SceneDetector
//
//  Created by SeonIl Kim on 2017. 11. 23..
//  Copyright © 2017년 Ray Wenderlich. All rights reserved.
//

import Foundation
import RealmSwift
import Photos

class DBManager {
    
    static func initData(assets: [PHAsset]) {
        // PHAsset 을 DB에 저장
        let realm = try! Realm()
        
        var items:[Picture] = []
        
        for asset in assets {
            let pic = Picture()
            pic.id = asset.localIdentifier
            pic.date = asset.creationDate
            
//            let location = asset.location
//            pic.locX = Double((location?.coordinate.latitude)!)
//            pic.locY = Double((location?.coordinate.longitude)!)
            
            let loc = Location()
            loc.latitude = Double(asset.location?.coordinate.latitude)
            loc.latitude = Double(asset.location?.coordinate.latitude)
            
            
            
            pic.flag = 0
            pic.keyword = ""
            items.append(pic)
        }
        
        try! realm.write {
            realm.deleteAll()
            realm.add(items)
        }
    }
    
    static func groupByDate() {
        // 주 단위
        let realm = try! Realm()
        let items = realm.objects(Picture.self).sorted(byKeyPath: "date", ascending: false) //날짜 역순으로 가져온다
        
        var groups:[[Picture]] = [] //일주일 단위 이미지 그룹
        var groupDate:[Date] = [] // 각 그룹의 기준 날짜
        
        var startDate:Date = Date()
        
        var i = 0
        for item in items {
            // 7일간의 데이터 저장
            let itemDate = item.date //현재 아이템의 시간
            if startDate.isInSameWeek(date: itemDate!) {
                groups[i].append(item)
            } else {
                //다음 주로
                groupDate[i] = startDate
                
                i += 1
                
            }
        }
    }
}

extension Date {
    func isInSameWeek(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .weekOfYear)
    }
    func isInSameMonth(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .month)
    }
    func isInSameYear(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .year)
    }
    func isInSameDay(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .day)
    }
    var isInThisWeek: Bool {
        return isInSameWeek(date: Date())
    }
    var isInToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
}

