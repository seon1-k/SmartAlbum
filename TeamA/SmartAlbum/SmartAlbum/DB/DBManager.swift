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

import MapKit

class DBManager {
    static func initData(assets: PHFetchResult<PHAsset>) {
        // PHAsset 을 DB에 저장
        let realm = try! Realm()
        
        var items:[Picture] = []
//        assets.count
        for i in 0..<100 {
            let asset = assets.object(at: i)
            let pic = Picture()
            pic.id = asset.localIdentifier
            pic.date = asset.creationDate
            
            let loc = Location()
            if let lati = asset.location?.coordinate.latitude, let longti = asset.location?.coordinate.longitude {
                loc.latitude = lati
                loc.longtitude = longti
            }
//            if let location = asset.location {
//                print("location \(i)")
//                LocationServices.getCity(location: location) { (city, error) in
//                    if error == nil {
////                        loc.city = city!
//                        print("city \(i):\(city!)")
//                    }
//                }
//            }
            pic.location = loc
            
            MLHelper.setKeyword(pic.id) { (key, error) in
                if error == nil {
                    print("keyword \(i)")
//                        :\(key!)")
                    pic.flag = 1
                    pic.keyword = key!
                } else {
                    print("error in coreML")
                }
            }
            
            items.append(pic)
        }
        
        try! realm.write {
            realm.deleteAll()
            realm.add(items)
            print("add complete")
        }
    }
    
    static func getKeywords() -> [String] {
        //키워드 값들 목록 반환
        let realm = try! Realm()
        let keywords:[String] = Array(Set(realm.objects(Picture.self).value(forKey: "keyword") as! [String]))
        return keywords
    }
    
    static func getAssets(_ keyword: String) -> PHFetchResult<PHAsset> {
        //키워드에 해당하는 PHAsset 불러옴
        
        let realm = try! Realm()
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let identifiers:[String] = Array(realm.objects(Picture.self).value(forKey: "id") as! [String])

        let fds:PHFetchResult<PHAsset> = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: fetchOptions)
        return fds
    }
    
    static func groupByCity() {
        // 시 단위 그루핑
        let realm = try! Realm()
        let locations = Array(realm.objects(Location.self))
//        print(locations)
        for loc in locations {
            print("city:\(loc)")
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

