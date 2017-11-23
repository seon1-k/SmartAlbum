//
//  LocationServices.swift
//  SmartAlbum
//
//  Created by SeonIl Kim on 2017. 11. 23..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import Foundation
import MapKit

class LocationServices {
    
    static func getCity(location:CLLocation, completion: @escaping (_ city:String?, _ error:String?) -> ()) {
//        let location = CLLocation(latitude: CLLocationDegrees(lati), longitude: CLLocationDegrees(longti))
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            
            if error == nil {
                if let placeMark = placemarks?.first {
//                    print(placeMark)
                    if let city = placeMark.locality {
                        completion(city, nil)
                    }
                }
            }
            
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
        }
        
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
