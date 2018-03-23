//
//  NetworkClient.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/23/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation
import Alamofire
import Firebase

class NetworkClient{
    
    func getVenus(parameters: [String:Any], completionHandler: @escaping ([Venues]?, String?) -> Void){
        var venuesArray = [Venues]()
        Alamofire.request(fourSquare().getVenus, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON {
                response in
                
                if let results = response.result.value as? [String: Any]{
                    let statusCode = results["meta"] as? [String: Any]
                    let code = (statusCode!["code"])! as? Int
                    if code == 200 {
                        if let responseObj = results["response"] as? [String: Any], responseObj["totalResults"] as! Int > 0 {
                            let groups = responseObj["groups"] as? [Any]
                            let itemsArr = groups![0] as? [String: Any]
                            let items = itemsArr!["items"] as? [[String:Any]]
                            for singleItem in items! {
                                let singleVenue = singleItem["venue"] as? [String: Any]
                                let venue = Venues(id: singleVenue!["id"] as! String , name: singleVenue!["name"] as! String, lat: 1.00, lng: 1.00, url: "", category:"")
                                venuesArray.append(venue)
                            }
                            
                            completionHandler(venuesArray, nil)
                        }
                        
                        
                        
                    }else{
                        completionHandler(nil, "There was an Error. Please Try again later.")
                        
                    }
                }
        }
    }
    
    
    func getVenueDetails(url: String,parameters: [String: Any], questionRef: DocumentReference, userRef: DocumentReference, mVenue: Venues, completionHandler: @escaping([String: Any]?, String?) -> Void){
        
        Alamofire.request(url, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON {
            (response) in
            
            if let parseResponse = response.result.value as? [String: Any]{
                let statusCode = parseResponse["meta"] as? [String: Any]
                let code = (statusCode!["code"])! as? Int
                
                if code! == 200{
                    let responseObj = (parseResponse["response"]) as? [String: Any]
                    if let venueObject = responseObj!["venue"] as? [String: Any] {
                        let venueURL = (venueObject["canonicalUrl"])!
                        let locationObj = venueObject["location"] as? [String: Any]
                        let categoryObj = venueObject["categories"] as! [[String: Any]]
                        let cat = categoryObj[0]
                        
                        let venueToSave = [
                            "venueID": mVenue.id,
                            "venueName": mVenue.name,
                            "lat": (locationObj!["lat"])!,
                            "lng": (locationObj!["lng"])!,
                            "url": venueURL,
                            "category": (cat["pluralName"])!,
                            "questionRef": questionRef,
                            "userRef": userRef
                        ]
                        

                        completionHandler(venueToSave, nil)
                        
                    }
                }else{
                    completionHandler(nil, "Couldn't Get Venue Details.")
                }
            }
        }
        
    }
    
}
