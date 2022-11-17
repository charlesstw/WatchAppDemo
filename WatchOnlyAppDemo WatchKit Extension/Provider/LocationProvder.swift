//
//  LocationProvder.swift
//  WatchOnlyAppDemo WatchKit Extension
//
//  Created by Charles Wang on 2022/9/2.
//

import Foundation
import CoreLocation

class LocationProvider {
    private let locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 1000
        return locationManager
    }()
    
}
