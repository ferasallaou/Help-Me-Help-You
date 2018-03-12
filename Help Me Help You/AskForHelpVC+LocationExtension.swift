//
//  AskForHelpVC+LocationExtension.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/12/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation
import MapKit

extension AskForHelpViewController: CLLocationManagerDelegate{
    
    
    func getUserLocation() {
            locationManager.requestWhenInUseAuthorization()
            let isLocationAuth = CLLocationManager.authorizationStatus()
            if isLocationAuth != .authorizedAlways && isLocationAuth != .authorizedWhenInUse {
                showAlert(title: "Location Service", message: "This app needs to use Location Service, Please grant the permissions.")
            }else if !CLLocationManager.locationServicesEnabled(){
                showAlert(title: "Location Service", message: "Location Service is Disabled.")
            }else{
                locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
                locationManager.distanceFilter = 100.0  // In meters.
                locationManager.delegate = self
                locationManager.startUpdatingLocation()
            }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let tryUserLocation = locations.last {
            
            userLocation = tryUserLocation.coordinate
        }else{
            // set it to Where Magic Happend :))
            userLocation = CLLocationCoordinate2D(latitude: 37.332, longitude: -122.01)
        }

    }
    
    
    func showAlert(title: String,message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okBtn)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
}
