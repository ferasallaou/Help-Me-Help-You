//
//  VenueViewController.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/20/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import Alamofire

class VenueViewController: UIViewController {

    @IBOutlet weak var venueMap: MKMapView! 
    @IBOutlet weak var categoryLable: UILabel!
    
    @IBOutlet weak var visitPage: UIButton!
    var lableText: String?
    var question: Question?
    var mVenue: Venues?
    var database = Firestore.firestore()
    var confirm: UIBarButtonItem!
    var venueToSave: [String: Any]?
    
    override func viewDidLoad() {
        visitPage.isEnabled = false
        super.viewDidLoad()
        if (mVenue!.lat == 1.00)
        {
            getVenueDetails()
        }else{
            print("Herelaaa")
            visitPage.isEnabled = true
            self.categoryLable.text =  "Category: \((self.mVenue!.category))"
            self.setMapAnnotation(lat: self.mVenue!.lat, lon: self.mVenue!.lng)
        }
        
         confirm = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.addAnswer))
        self.navigationItem.rightBarButtonItem = confirm
        confirm.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = mVenue!.name
        
    }
    
    @objc func addAnswer(){
        confirm.isEnabled = false

        let venueID = mVenue?.id
        let questionRef = database.collection("Questions").document("\((question?.docID)!)")
        
        database.collection("Answers").whereField("questionRef", isEqualTo: questionRef).whereField("venueID", isEqualTo: venueID!).getDocuments {
            (isThere, gotError) in
            
            guard gotError == nil else {
                print("There was an Error checking....")
                return
            }
            
            if isThere!.documents.count < 1 {
                self.database.collection("Answers").addDocument(data: self.venueToSave!) {
                    err in
                    
                    guard err == nil else {
                        let alert = UIAlertController(title: "Error", message: "Error while saving the answer. Try again plz", preferredStyle: UIAlertControllerStyle.alert)
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    FireBaseClient().incrementBy(collection: "Questions", document: self.question!.docID, fieldToInc: "suggestions", database: self.database)
                    self.dismiss(animated: true, completion: nil)
                }
            }else{
                self.dismiss(animated: true, completion: nil)
            }
            
        }

        
    }
    
    @IBAction func vistiPage(_ sender: Any) {
        let urlToOpen = URL(string: mVenue!.url)
        UIApplication.shared.open(urlToOpen!, options: [:], completionHandler: nil)
    }
    
    func getVenueDetails() {
        let venueID = mVenue!.id
        let URL = "\(fourSquare().getVenueDetails)/\(venueID)"
        let parameters = [
            "client_id": fourSquare().clientID,
            "client_secret": fourSquare().clientSecret,
            "v": "20190101",
        ]
        let questionRef = database.collection("Questions").document("\((question?.docID)!)")
        let userRef = database.collection("Users").document("\((Auth.auth().currentUser?.uid)!)")
        
        Alamofire.request(URL, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
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
                        //print("Final is \(venueURL) + \(locationObj!["lat"]) + \(categoryObj[0])")
                        self.venueToSave = [
                            "venueID": self.mVenue!.id,
                            "venueName": self.mVenue!.name,
                            "lat": (locationObj!["lat"])!,
                            "lng": (locationObj!["lng"])!,
                            "url": venueURL,
                            "category": (cat["pluralName"])!,
                            "questionRef": questionRef,
                            "userRef": userRef
                            ]
                        
                        self.categoryLable.text =  "Category: \((self.venueToSave!["category"])!)"
                        self.setMapAnnotation(lat: self.venueToSave!["lat"] as! Double, lon: self.venueToSave!["lng"] as! Double)
                        self.visitPage.isEnabled = true
                        self.mVenue = Venues(id: self.venueToSave!["venueID"] as! String,
                                        name: self.venueToSave!["venueName"] as! String,
                                        lat: self.venueToSave!["lat"] as! Double,
                                        lng: self.venueToSave!["lng"] as! Double,
                                        url: self.venueToSave!["url"] as! String,
                                        category: self.venueToSave!["category"] as! String)
                        self.confirm.isEnabled = true
                        
                    }
                }else{
                let alert = UIAlertController(title: "Error", message: "Couldn't Get Venue details", preferredStyle: UIAlertControllerStyle.alert)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        
    }

}
