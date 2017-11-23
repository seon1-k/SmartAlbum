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
    
    static func initData(assets: [PHAsset], completionHandler: @escaping (Bool) -> Void) {
        let realm = try! Realm()
        
        var items:[Picture] = []
        //        assets.count
        for i in 0..<300 {
            let asset = assets[i]
            let pic = Picture(asset: asset)
            MLHelper.setKeyword(asset.localIdentifier) { (key, error) in
                if error == nil {
                    //                    print("keyword \(i)")
                    pic.flag = 1
                    pic.keyword = key!
                } else {
                    //                    print("error in coreML")
                }
                
                
                items.append(pic)
            }
        }
        
        try! realm.write {
            realm.deleteAll()
            realm.add(items)
            print("add complete")
            //
            UserDefaults.standard.set(Date(), forKey: "updateDate")
            completionHandler(true)
        }
    }
    
    static func initData(assets: PHFetchResult<PHAsset>, completionHandler: @escaping (Bool) -> Void) {
        let assets2 = assets.objects(at: IndexSet(0..<assets.count))
        initData(assets: assets2) { _ in
            completionHandler(true)
        }
    }
    
    static func initData(completionHandler: @escaping (Bool) -> Void) {
        // PHAsset 을 DB에 저장
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let assets:PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: fetchOptions)
        
        initData(assets: assets) { _ in
            completionHandler(true)
        }
       
    }
    
//    static func addLocation(completionHandler: @escaping (Bool) -> Void){
//        let realm = try! Realm()
//        let items = realm.objects(Picture.self).filter("location != nil")
//        print("count:\(items.count)")
//
//        try! realm.write {
//            for item in items {
//                let loc = CLLocation(latitude: (item.location?.latitude)!, longitude: (item.location?.longtitude)!)
//                LocationServices.getCity(location: loc){ (city, error) in
//                    print("city:\(city!)")
//                    item.location?.city = city!
//                }
//            }
//        }
//        print("add location complete")
//        completionHandler(true)
//    }
    
    static func updateData(completionHandler: @escaping (Bool) -> Void) {
        // 사진의 modificationDate 값을 기준으로, 가장 최근에 keyword를 입힌 시점보다 최근에 수정된 이미지 파일은 keyword 업데이트
        // 첫 실행이 아닐 경우 무조건 updateData
//        let realm = try! Realm()
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
        let fetch:PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: fetchOptions)
        
        print("updateDate:\(UserDefaults.standard.value(forKey: "updateDate"))")
        
        var fetchedArray:[PHAsset] = []
        for i in 0..<fetch.count {
            let item = fetch.object(at: i)
            print(item.modificationDate)
            if item.modificationDate! < UserDefaults.standard.value(forKey: "updateDate") as! Date {
//                fetchedArray = Array(fetch)[0..<i]
                fetchedArray = fetch.objects(at: IndexSet(0..<i-1))
                break
            }
            
//            try! realm.write {
//                let pic = Picture(asset: item)
//                realm.add(pic)
//            }
        }
        
        initData(assets: fetchedArray) { _ in
            print("\(fetchedArray.count) of items updated.")
            UserDefaults.standard.set(Date(), forKey: "updateDate")
            completionHandler(true)
        }
//        initData(assets: PHFetchResult<PHAsset>(fetchedArray), completionHandler: <#T##(Bool) -> Void#>)
        
        // 삭제된 사진은 DB에서 지워야함.? -> 일단 보류
        
        
    }
    
//    static func getKeywords() -> [String] {
//        //키워드 값들 목록 반환
//        let realm = try! Realm()
//        let keywords:[String] = Array(Set(realm.objects(Picture.self).value(forKey: "keyword") as! [String]))
//        return keywords
//    }
    
//    static func getLastAsset(_ keyword: String?) -> PHFetchResult<PHAsset> {
//        let realm = try! Realm()
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
//
//        var identifier:String = ""
//        if keyword == nil || keyword == "" {
//            // 분류 안된 것만 리턴
//            identifier = Array(realm.objects(Picture.self).filter("flag == 0")).last?.value(forKey: "id") as! String
//        } else {
//            identifier = Array(realm.objects(Picture.self).filter("keyword == %@", keyword!)).last?.value(forKey: "id") as! String
//        }
//        let fds:PHFetchResult<PHAsset> = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: fetchOptions)
//        return fds
//    }
    
    static func getAssets(_ keyword: String?) -> PHFetchResult<PHAsset> {
        //키워드에 해당하는 PHAsset 불러옴
        
        let realm = try! Realm()
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        var identifiers:[String] = []
        if keyword == nil || keyword == "" {
            // 분류 안된 것만 리턴
            identifiers = Array(realm.objects(Picture.self).filter("flag == 0").value(forKey: "id") as! [String])
        } else {
            identifiers = Array(realm.objects(Picture.self).filter("keyword == %@", keyword!).value(forKey: "id") as! [String])
        }

        let fds:PHFetchResult<PHAsset> = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: fetchOptions)
        return fds
    }
    
    static func getAssets(_ ids:[String]) -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fds:PHFetchResult<PHAsset> = PHAsset.fetchAssets(withLocalIdentifiers: ids, options: fetchOptions)
        return fds
    }
    
    static func getAssetsForSearch(_ keyword: String) -> PHFetchResult<PHAsset> {
        let realm = try! Realm()
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let identifiers:[String] = Array(realm.objects(Picture.self).filter("keyword CONTAIN %@", keyword).value(forKey: "id") as! [String])
        let fds:PHFetchResult<PHAsset> = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: fetchOptions)
        return fds
    }
    
    static func groupByCity() -> (groupKey:[String], groupAssets:[PHFetchResult<PHAsset>])  {
        // 시 단위 그루핑
        let realm = try! Realm()
        let locations = Array(realm.objects(Location.self))
//        print(locations)
        for loc in locations {
            print("city:\(loc)")
        }
        
        return ([], [])
    }
    
    static func groupByKeyWord() -> (groupKey:[String], groupAssets:[PHFetchResult<PHAsset>]) {
        let realm = try! Realm()
        let groupKey:[String] = Array(Set(realm.objects(Picture.self).value(forKey: "keyword") as! [String]))
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        var groupAssets:[PHFetchResult<PHAsset>] = []
        for keyword in groupKey {
            var identifiers:[String] = []
            if keyword == "" {
                // 분류 안된 것만 리턴
                identifiers = Array(realm.objects(Picture.self).filter("flag == 0").value(forKey: "id") as! [String])
            } else {
                identifiers = Array(realm.objects(Picture.self).filter("keyword == %@", keyword).value(forKey: "id") as! [String])
            }
            let fds:PHFetchResult<PHAsset> = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: fetchOptions)
            groupAssets.append(fds)
        }
        
        return (groupKey, groupAssets)
        
    }
    
    static func groupByDate() -> (groupKey:[String], groupAssets:[PHFetchResult<PHAsset>]) {
        // 주 단위
        let realm = try! Realm()
        let items = realm.objects(Picture.self).sorted(byKeyPath: "createDate", ascending: false) //날짜 역순으로 가져온다
        
//        var groups:[[String]] = [] //월단위 이미지 그룹
        var groupAssets:[PHFetchResult<PHAsset>] = []
        var groupKey:[String] = [] // 각 그룹의 기준 날짜
        
        
        var startDate:Date = Date()
        
        var temp:[String] = [] // 각 달의 이미지 id들을 임시로 저장
        for item in items {
//            print(item.value(forKey: "createDate"))
            // 월단위 데이터 저장
            let itemDate = item.createDate //현재 아이템의 시간
            if startDate.isInSameMonth(date: itemDate!) {
                temp.append(item.value(forKey: "id") as! String)
            } else {
                //다음 달로
//                groups.append(temp)
                
                if temp.count != 0 {
                    groupAssets.append(getAssets(temp))
                    groupKey.append(startDate.getMonthString())
                }
                
                startDate = startDate.getPrevMonth()
//                print("temp:\(temp)")
                temp = []
                temp.append(item.value(forKey: "id") as! String)
            }
        }
        return (groupKey, groupAssets)
    }
    
}
