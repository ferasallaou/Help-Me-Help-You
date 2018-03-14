//
//  AskForHelpViewController.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/12/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import UIKit
import MapKit
import Firebase


class AskForHelpViewController: UIViewController {

    
    @IBOutlet weak var sendQuestionBtn: UIButton!
    @IBOutlet weak var questionTextView: UITextView!
    let locationManager = CLLocationManager()
    var userLocation: CLLocationCoordinate2D? = nil
    var database: Firestore? = nil
    var ref: DocumentReference? = nil
    var cityAsString: String? =  nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTextView.delegate = self
        questionTextView.layer.borderColor = UIColor.gray.cgColor
        questionTextView.layer.borderWidth = 1.0
        database = Firestore.firestore()
        getUserLocation() {
            error in
            
            guard error == nil else {
                self.showAlert(title: "Location Error", message: "Couldn't get Location")
                return
            }

            
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        LocationServices().getAdress(userLocation: self.locationManager.location!) {
            (address, error ) in
            
            guard error == nil else {
                print("Couldn't get your address")
                return
            }
            
            if let fullAddress = address, let cityName = fullAddress["City"]{
                self.cityAsString = cityName as? String
            }
        }
    }


    @IBAction func sendUrQuestion(_ sender: Any) {

        
        self.sendQuestionBtn.isEnabled = false
        if let question = questionTextView.text, question != "Write Your Question" || question == "" {
            let dataToSave = [
                "question": question,
                "userid": Auth.auth().currentUser!.uid,
                "cityName": cityAsString!,
                "cityCoordinates": GeoPoint(latitude: (userLocation?.latitude)!, longitude: (userLocation?.longitude)!),
                "postedAt": Date()
                ] as [String : Any]

            ref = database!.collection("Questions").addDocument(data: dataToSave) {
                err in

                guard err == nil else {
                    self.showAlert(title: "Error", message: "Couldn't post your question, Please try again later.")
                    self.sendQuestionBtn.isEnabled = true
                    return
                }

                
                let userID = Auth.auth().currentUser?.uid
                FireBaseClient().incrementBy(collection: "Users", document: "\(userID)", fieldToInc: "questions", database: self.database!)
                
//                let userRef = self.database!.collection("Users").document("\(userID!)")
//
//                self.database!.runTransaction({ (transaction, error) -> Any? in
//                    do {
//                        let userTransactoin = try transaction.getDocument(userRef).data()
//                        guard var userInfo = userTransactoin else {return nil}
//
//                        var newQuestion = userInfo["questions"] as! Int
//                        newQuestion += 1
//                        userInfo["questions"] = newQuestion
//
//                        transaction.setData(userInfo, forDocument: userRef)
//                    }catch{
//                        print("Error in getting Data")
//                    }
//
//
//                    return nil
//                }) { (completionObj, complationErrir) in
//                    //
//                }



                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "showQuestion") as! ShowQuestionViewController
                nextVC.questionID = self.ref?.documentID
                self.present(nextVC, animated: true, completion: nil)
            }
        }else{
            showAlert(title: "Error", message: "Enter Your question ")
        }
    }

}
