//
//  LocationServices.swift
//  SmartAlbum
//
//  Created by Seong ho Hong on 2017. 11. 24..
//  Copyright © 2017년 team-b. All rights reserved.
//

import Foundation
import MapKit

class LocationServices {
    
    func getCity(lati:Double, longti:Double, completion: @escaping (String) -> ()) {
        let location = CLLocation(latitude: CLLocationDegrees(lati), longitude: CLLocationDegrees(longti))
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            if error != nil {
                return
            }
            let placeArray = placemarks
            var placeMark: CLPlacemark!
            placeMark = placeArray?[0]
            guard let address = placeMark.locality else {
                return
            }
            completion(address)
        }
    }
}
