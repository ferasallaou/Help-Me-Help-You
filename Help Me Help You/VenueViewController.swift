//
//  VenueViewController.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/20/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import UIKit
import Firebase

class VenueViewController: UIViewController {

    @IBOutlet weak var lable: UILabel!
    var lableText: String?
    var question: Question?
    var venue: Venues?
    var database = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        let test = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.addAnswer))
        self.navigationItem.rightBarButtonItem = test
        
        
        // Do any additional setup after loading the view.
    }

    @objc func addAnswer(){
        let questionRef = database.collection("Questions").document("\((question?.docID)!)")
        let userRef = database.collection("Users").document("\((Auth.auth().currentUser?.uid)!)")
        let venueID = venue?.id
        let postedAt = Date()
        let venueName = venue?.name
        
        let dataToSave = [
            "questionRef": questionRef,
            "userRef": userRef,
            "venueID": venueID!,
            "venueName": venueName!,
            "postedAt": postedAt
        ] as [String: Any]
        
        database.collection("Answers").addDocument(data: dataToSave) {
            err in
            
            guard err == nil else {
                let alert = UIAlertController(title: "Error", message: "Error while saving the answer. Try again plz", preferredStyle: UIAlertControllerStyle.alert)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
        self.dismiss(animated: true, completion: nil)
        }
        
    }

}
