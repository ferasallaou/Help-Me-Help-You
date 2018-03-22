//
//  LocationManager.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/14/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation
import MapKit
import Alamofire

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var mUserLocation: CLLocation!
    var cityAsString: String? = nil
    var currentLocation: CLLocation!
    let googleMapsApi = googleMaps()
    var isAuth = false
    let authStatus = CLLocationManager.authorizationStatus()
    let inUse = CLAuthorizationStatus.authorizedWhenInUse
    let always = CLAuthorizationStatus.authorizedAlways
    
    func getUserLocation(){
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        
            let isLocationAuth = CLLocationManager.authorizationStatus()
            if isLocationAuth != .authorizedAlways && isLocationAuth != .authorizedWhenInUse {
                print( "This app needs to use Location Service, Please grant the permissions.")
            }else if !CLLocationManager.locationServicesEnabled(){
                print("Location Service is Disabled.")
            }else{
                isAuth = true
                locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
                locationManager.distanceFilter = 1000.0  // In meters.
                locationManager.delegate = self
                locationManager.startUpdatingLocation()
                mUserLocation = locationManager.location
            }

    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Did change")
        switch status{
        case .authorizedAlways, .authorizedWhenInUse:
            print("author")
            break
        case .denied, .notDetermined, .restricted:
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("HIT ME")
        if let tryUserLocation = locations.last {
            mUserLocation = CLLocation(latitude: tryUserLocation.coordinate.latitude, longitude: tryUserLocation.coordinate.longitude)
        }else{
            // set it to Where Magic Happend :))
            mUserLocation = CLLocation(latitude: 37.332, longitude: -122.01)
        }
        
        
        
     
    }
    
    func getAdress(completion: @escaping (_ address: String?, _ error: Error?) -> ()) {

        getUserLocation()
        if self.authStatus == inUse || self.authStatus == always {
            
            self.currentLocation = mUserLocation
            
            //let geoCoder = CLGeocoder()

            let latlng = "\(self.currentLocation.coordinate.latitude),\(self.currentLocation.coordinate.longitude)"
            let url = "\(googleMaps().APIUrl)+\(latlng)&key=\(googleMaps().APIKey)"
            Alamofire.request(url).responseJSON() {
                response in
            
                if let result = response.result.value as? [String: Any], let addressComp = result["results"] as? NSArray {
                    if let addressObject = addressComp.value(forKey: "address_components") as? NSArray, let cityArray = addressObject[0] as? NSArray{
                        if let getCity = cityArray[3] as? [String:Any], let cityName = getCity["short_name"] {
                            completion(cityName as! String, nil)
                        }
                    }

                }
            }   
        }
        
    }
    
    func getAuthStatus() -> Bool{
        if self.authStatus == inUse || self.authStatus == always {
            return true
        }else {
            return false
        }
    }
    
    
    func showAlert(title: String,message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okBtn)

        //present(alert, animated: true, completion: nil)
        
    }
    
}
