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
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUserLocation()
        LocationServices().getAdress(userLocation: locationManager.location!) {
            (address, error ) in
            
            guard error == nil else {
                print("Couldn't get your address")
                return
            }
            
            if let fullAddress = address, let cityName = fullAddress["City"]{
                print(fullAddress)
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
                
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "showQuestion") as! ShowQuestionViewController
                nextVC.questionID = self.ref?.documentID
                self.present(nextVC, animated: true, completion: nil)
            }
        }else{
            showAlert(title: "Error", message: "Enter Your question ")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
