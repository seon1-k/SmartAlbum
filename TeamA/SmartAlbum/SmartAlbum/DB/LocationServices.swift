//
//  LocationServices.swift
//  SmartAlbum
//
//  Created by SeonIl Kim on 2017. 11. 23..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import Foundation
import MapKit
//import Alamofire
import RealmSwift
import Photos

class LocationServices {
    
//    static func getCity(lati: Double, longti:Double, completionHandler: @escaping (String?) -> Void) {
//        Alamofire.request("http://maps.googleapis.com/maps/api/geocode/json?latlng=\(lati), \(longti)&sensor=true").responseJSON { res in
//            switch res.result {
//            case .success:
//                if let value = res.result.value {
//                    if let result = value["result"] {
//
//                    }
//                }
//            case .failure(_):
//                completionHandler(nil)
//            }
//        }
//    }
    
    static func getCitys(loc:[Location], id:String, completion: @escaping (_ citys:[String]?, _ error:String?) -> ()) {
        var citys:[String] = []
        for l in loc {
            let location = CLLocation(latitude: l.latitude, longitude: l.longtitude)
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location) { placemarks, error in
                
                if error == nil {
                    if let placeMark = placemarks?.first {
                        if let city = placeMark.locality {
                            citys.append(city)
                        }
                    }
                }
            }
        }
        
        completion(citys, nil)
    
    }
    
    
    
    static func getCity(completion: @escaping (Bool) -> ()) {
        let realm = try! Realm()
//        let items = realm.objects(Picture.self).filter("location != nil")
        let items = realm.objects(Location.self)
        
        for item in items {
//            let id = item.value(forKey: "id") as! String
//            let asset = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil).firstObject
            
//            if let loc = asset?.location {
//
//            }
            
            let location = CLLocation(latitude: item.value(forKey: "latitude") as! Double, longitude: item.value(forKey: "longtitude") as! Double)
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location) { placemarks, error in
                if error == nil {
                    let placeArray = placemarks
                    var placeMark: CLPlacemark!
                    placeMark = placeArray?[0]
//                    guard let address = placeMark.locality else {
//                        return
//                    }
                    
//                    if let city = placeMark.locality {
//                        try! realm.write {
//                            item.city = address
//                        }
//                    }

                    if placeMark.locality != nil {
                        try! realm.write {
                            item.city = placeMark.locality!
                        }
                    } else if placeMark.subLocality != nil {
                        try! realm.write {
                            item.city = placeMark.subLocality!
                        }
                    } else {
                        try! realm.write {
                            item.city = "error"
                        }
                    }
                }
            }
            completion(true)
        }
            
        
        
//        let location = CLLocation(latitude: CLLocationDegrees(lati), longitude: CLLocationDegrees(longti))
//        let location = CLLocation(latitude: loc.latitude, longitude: loc.longtitude)
//        let geoCoder = CLGeocoder()
//
//        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
//
//            if error == nil {
//                if let placeMark = placemarks?.first {
////                    print(placeMark)
//                    if let city = placeMark.locality {
//                        completion(city, nil)
//                    }
//                }
//            }

//            if error != nil {
//                completion(nil, "error")
//            }
//            if let placeArray = placemarks {
//                if placeArray.count > 0 {
//                    let placeMark: CLPlacemark = placeArray[0]
//                    guard let city = placeMark.locality else {
//                        return
//                    }
//                    //            print("city:\(city)")
//                    completion(city, nil)
//                } else {
//                    completion(nil, "error")
//                }
//            }
//        }

//        let request = VNCoreMLRequest(model: model){ request, error in
//            guard let results = request.results as? [VNClassificationObservation], let topResult = results.first else {
//                fatalError("error in VNCoreMLRequest")
//            }
//
//            if topResult.confidence >= correctValue {
//                completionHandler(topResult.identifier, nil)
//            }
//        }
//
//        let handler = VNImageRequestHandler(ciImage: CIImage(image: image!)!)
//        DispatchQueue.global(qos: .userInteractive).async {
//            do {
//                try handler.perform([request])
//            } catch {
//                print(error)
//                completionHandler(nil, "error")
//            }
//        }
    }
}
