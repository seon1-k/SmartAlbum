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
    static func initData(completionHandler: @escaping (Bool) -> Void) {
        // PHAsset 을 DB에 저장
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let assets:PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: fetchOptions)
        
        let realm = try! Realm()
        
        var items:[Picture] = []
//        assets.count
        for i in 0..<100 {
            let asset = assets.object(at: i)
            let pic = Picture(asset: asset)
            
            MLHelper.setKeyword(asset.localIdentifier) { (key, error) in
//                print("key:\(key!)")
                if error == nil {
//                    print("keyword \(i)")
                    pic.flag = 1
                    pic.keyword = key!
                } else {
//                    print("error in coreML")
                }
//                print("append \(i)")
                items.append(pic)
            }
        }
        
        try! realm.write {
            realm.deleteAll()
            realm.add(items)
            print("add complete")
            
            UserDefaults.standard.set(Date(), forKey: "updateDate")
            completionHandler(true)
        }
    }
    
    static func updateData() {
        // 사진의 modificationDate 값을 기준으로, 가장 최근에 keyword를 입힌 시점보다 최근에 수정된 이미지 파일은 keyword 업데이트
        let realm = try! Realm()
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
        let fetch:PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: fetchOptions)
        
//        print("updateDate:\(UserDefaults.standard.value(forKey: "updateDate"))")
        var count = 0
        for i in 0..<fetch.count {
            let item = fetch.object(at: i)
//            print(item.modificationDate)
            if item.modificationDate! < UserDefaults.standard.value(forKey: "updateDate") as! Date {
                break
            }
            
            try! realm.write {
                let pic = Picture(asset: item)
                realm.add(pic)
            }
            count += 1
        }
        
        // 삭제된 사진은 DB에서 지워야함.? -> 일단 보류
        
        print("new item:\(count)")
        UserDefaults.standard.set(Date(), forKey: "updateDate")
    }
    
    static func getKeywords() -> [String] {
        //키워드 값들 목록 반환
        let realm = try! Realm()
        let keywords:[String] = Array(Set(realm.objects(Picture.self).value(forKey: "keyword") as! [String]))
        return keywords
    }
    
    static func getAssets(_ keyword: String?) -> PHFetchResult<PHAsset> {
        //키워드에 해당하는 PHAsset 불러옴
        
        
        
        let realm = try! Realm()
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        var identifiers:[String] = []
        if keyword == nil {
            // 분류 안된 것만 리턴
            identifiers = Array(realm.objects(Picture.self).filter("flag == 0").value(forKey: "id") as! [String])
        } else {
            identifiers = Array(realm.objects(Picture.self).value(forKey: "id") as! [String])
        }

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
            let itemDate = item.createDate //현재 아이템의 시간
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

