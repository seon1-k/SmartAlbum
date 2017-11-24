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
    
    static func initData(assets: [PHAsset], isFirst:Bool, completionHandler: @escaping (Bool) -> Void) {
        let realm = try! Realm()
        
        var items:[Picture] = []
        //        assets.count
        var count = 0
        if assets.count > 300 || isFirst {
            count = 300
        } else {
            count = assets.count
        }
        for i in 0..<count {
            let asset = assets[i]
            let pic = Picture(asset: asset)
            
            
//            if let loc = asset.location {
//                LocationServices.getCity(location: loc) { city, error in
//                    if error == nil {
//                        print("insert city : \(city!)")
//                        try! pic.realm?.write {
//                            pic.city = city!
//                        }
//                    } else {
//                        print("no insert city 1")
//                    }
//                }
//            } else {
//                print("no insert city 2 \(asset.location)")
//            }

            
            // 에러 포인트. 4번 이상 실행하면 에러 안남. coreML 버그인가...
            // [coreml] MLModelAsset: modelWithError: load failed with error Error Domain=com.apple.CoreML Code=0 "Error in declaring network."
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
            if isFirst {
                realm.deleteAll()
            }
            realm.add(items)
            print("add complete")
            //
            UserDefaults.standard.set(Date(), forKey: "updateDate")
            completionHandler(true)
        }
    }
    
    static func initData(assets: PHFetchResult<PHAsset>, isFirst:Bool, completionHandler: @escaping (Bool) -> Void) {
        let assets2 = assets.objects(at: IndexSet(0..<assets.count))
        initData(assets: assets2, isFirst:isFirst) { _ in
            completionHandler(true)
        }
    }
    
    static func initData(isFirst:Bool, completionHandler: @escaping (Bool) -> Void) {
        // PHAsset 을 DB에 저장
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let assets:PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: fetchOptions)
        
        initData(assets: assets, isFirst:isFirst) { _ in
            completionHandler(true)
        }
       
    }
    
    static func updateData(completionHandler: @escaping (Bool) -> Void) {
        // 사진의 modificationDate 값을 기준으로, 가장 최근에 keyword를 입힌 시점보다 최근에 수정된 이미지 파일은 keyword 업데이트
        // 첫 실행이 아닐 경우 무조건 updateData

//        let realm = try! Realm()
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
        let fetchArr:PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: fetchOptions)
        let updateDate = UserDefaults.standard.value(forKey: "updateDate") as? Date
        
        var newFetchArr:[PHAsset] = []
        for i in 0..<fetchArr.count {
            let fetch = fetchArr.object(at: i)
            
            if fetch.modificationDate! < updateDate! {
                if i == 0 {
                    break
                }
                newFetchArr = fetchArr.objects(at: IndexSet(0..<i-1))
                break
            }
        }
        
        initData(assets: newFetchArr, isFirst: false) { _ in
            print("\(newFetchArr.count) of items updated.")
            UserDefaults.standard.set(Date(), forKey: "updateDate")
            completionHandler(true)
        }
        // 삭제된 사진은 DB에서 지워야함.? -> 일단 보류
        
        
    }
    
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
    
//    static func addCity(completionHandler: @escaping ([String]) -> Void) {
//        //DB에 도시 정보 추가
//
//        let realm = try! Realm()
//        try! realm.write {
//            let locations = Array(realm.objects(Location.self))
//            for loc in locations {
//                let lo = CLLocation(latitude: loc.latitude, longitude: loc.longtitude)
//
//                LocationServices.getCity(location: lo) { (city, error) in
//                    loc.city = city!
//                    //                    print("city:\(city!)")
//                }
//            }
//            let citys = Array(Set(realm.objects(Location.self).value(forKey: "city") as! [String]))
//            completionHandler(citys)
//        }
//    }
    
//    static func groupByLocation() -> [Location] {
//
//    }
    
    static func groupByCity() -> (groupKey:[String], groupAssets:[PHFetchResult<PHAsset>])  {
        // 시 단위 그루핑
        let realm = try! Realm()
        
//        addLocation()
        var citys:[String] = []
        var groupAssets:[PHFetchResult<PHAsset>] = []
        
        DispatchQueue.main.async {
            citys = Array(Set(realm.objects(Location.self).value(forKey: "city") as! [String]))
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            
            for city in citys {
                var identifiers:[String] = []
                if city == "" {
                    // 분류 안된 것만 리턴
                    identifiers = Array(realm.objects(Picture.self).filter("location == nil").value(forKey: "id") as! [String])
                } else {
                    identifiers = Array(realm.objects(Picture.self).filter("location.city == %@", city).value(forKey: "id") as! [String])
                }
                
                
                let fds:PHFetchResult<PHAsset> = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: fetchOptions)
                groupAssets.append(fds)
            }
        }
        
//        let ids:[String] = Array(realm.objects(Picture.self).filter("location != nil").value(forKey: "id") as! [String])
//        let locations:[Location] = Array(realm.objects(Location.self))
//
//        let pictures = realm.objects(Picture.self).filter("location != nil")
//        let locations = Array(pictures.value(forKey: "location") as! [Location])
//
//        var citys:[String] = []
//
//        LocationServices.getCitys(loc: locations) { (arr, error) in
//            citys = arr!
//        }
        
//        for loc in locations {
//            LocationServices.getCity(loc: loc) { (city, error) in
//                citys.append(city!)
////                print("citys:\(citys)")
//            }
//        }
        
//        print("citys:\(citys)")
        
//        addCity() { citys in
////            let citys = Array(Set(realm.objects(Location.self).value(forKey: "city") as! [String]))
//            print("citys:\(citys)")
//        }
        
        return (citys, groupAssets)
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
            // 월단위 데이터 저장
            let itemDate = item.createDate //현재 아이템의 시간
            print("itemDate:\(item.createDate)")
            
            if startDate.isInSameMonth(date: itemDate!) {
                temp.append(item.value(forKey: "id") as! String)
            } else {
                //다음 달 아이템이 들어오면
                if temp.count != 0 {
                    groupAssets.append(getAssets(temp))
                    temp = []
                    groupKey.append(startDate.getMonthString())
                }
                
                startDate = startDate.getPrevMonth()
                if startDate.isInSameMonth(date: itemDate!) {
                    temp.append(item.value(forKey: "id") as! String)
                }
            }
        }
        
        if temp.count != 0 {
            groupAssets.append(getAssets(temp))
            groupKey.append(startDate.getMonthString())
        }
        return (groupKey, groupAssets)
    }
    
}
