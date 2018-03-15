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
    
    let customLocationManager = LocationManager()
    var database: Firestore? = nil
    var ref: DocumentReference? = nil
    var cityName: String!
    var userLocation : CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTextView.delegate = self
        questionTextView.layer.borderColor = UIColor.gray.cgColor
        questionTextView.layer.borderWidth = 1.0
        database = Firestore.firestore()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.sendQuestionBtn.isEnabled = false
        self.sendQuestionBtn.titleLabel?.text = "Getting City Name...."
        customLocationManager.getAdress() {
            (address, error) in
            
            guard error == nil else {
                print("An Error getting Cicty")
                return
            }
            
            self.sendQuestionBtn.isEnabled = true
            self.sendQuestionBtn.titleLabel?.text = "Send your question"
            
            if let stringCity = address!["City"] {
                self.cityName = stringCity as! String
            }
            
            self.userLocation = self.customLocationManager.mUserLocation
            
        }
       
    }


    @IBAction func sendUrQuestion(_ sender: Any) {
        self.sendQuestionBtn.isEnabled = false
        if let question = questionTextView.text, question != "Write Your Question" || question == "" {
            let dataToSave = [
                "question": question,
                "userid": Auth.auth().currentUser!.uid,
                "cityName": cityName,
                "cityCoordinates": GeoPoint(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
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
                FireBaseClient().incrementBy(collection: "Users", document: "\(userID!)", fieldToInc: "questions", database: self.database!)
                


                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "showQuestion") as! ShowQuestionViewController
                nextVC.questionID = self.ref?.documentID
                self.present(nextVC, animated: true, completion: nil)
            }
        }else{
            showAlert(title: "Error", message: "Enter Your question ")
            self.sendQuestionBtn.isEnabled = true
        }
    }

}
