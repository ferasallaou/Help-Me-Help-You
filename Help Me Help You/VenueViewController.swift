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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var visitPage: UIButton!
    var lableText: String?
    var question: Question?
    var mVenue: Venues?
    var database = Firestore.firestore()
    var confirm: UIBarButtonItem!
    var venueToSave: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        visitPage.isEnabled = false
        activityIndicator.isHidden = true
        if (mVenue!.lat == 1.00) {
            getVenueDetails()
        } else {
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
                    
                    FireBaseClient().incrementBy(collection: "Questions", document: self.question!.docID, fieldToInc: "suggestions", database: self.database, scoreObject: false)
                    let userID = Auth.auth().currentUser?.uid
                    FireBaseClient().incrementBy(collection: "Users", document: userID!, fieldToInc: "answers", database: self.database, scoreObject: true)
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
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        NetworkClient().getVenueDetails(url: URL, parameters: parameters, questionRef: questionRef, userRef: userRef, mVenue: mVenue!) { 
            (venue, error) in
            
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            
            guard error == nil else {
                let alert = UIAlertController(title: "Error", message: error!, preferredStyle: UIAlertControllerStyle.alert)
                let okBtn = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(okBtn)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            
            self.venueToSave = venue
            
            self.categoryLable.text =  "Category: \((self.venueToSave!["category"])!)"
            self.setMapAnnotation(lat: self.venueToSave!["lat"] as! Double, lon: self.venueToSave!["lng"] as! Double)
            self.visitPage.isEnabled = true
            self.confirm.isEnabled = true
            
        }
        
        
    }
    
}
