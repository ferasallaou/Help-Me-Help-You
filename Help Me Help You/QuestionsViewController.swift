//
//  QuestionsViewController.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/14/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import UIKit
import Firebase

class QuestionsViewController: UIViewController{

    struct questionDT {
        var cityCoordinates: GeoPoint
        var cityName: String
        var postedAt: Date
        var question: String
        var userid: String
        var docID: String
    }
    
    
    @IBOutlet weak var questionTable: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var question: [questionDT] = [questionDT]()
    var ref : DocumentReference? = nil
    var database : Firestore? = nil
    var userCity: String? = nil
    let customLocation = LocationManager()
    
    override func viewDidLoad() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        questionTable.isHidden = true
        question = []
        super.viewDidLoad()
        database = Firestore.firestore()
        customLocation.getAdress() {
            (address, error) in
            
            guard error == nil else {
                print("Coudln't get Your City")
                return
            }
            
            if let cityAsString = address!["City"] {
                self.userCity = cityAsString as? String
            }
            
            let query = self.database!.collection("Questions").whereField("cityName", isEqualTo: self.userCity!)
            
            query.getDocuments { (documents, error) in
                guard error == nil else {
                    print("Error Getting Data")
                    return
                }
                
                for singleDoc in (documents?.documents)! {
                    let singleObject = singleDoc.data()
                    let newQuest = questionDT(cityCoordinates: singleObject["cityCoordinates"] as! GeoPoint, cityName: singleObject["cityName"] as! String, postedAt: singleObject["postedAt"] as! Date, question: singleObject["question"] as! String, userid: singleObject["userid"] as! String, docID: singleDoc.documentID)
                    self.question.append(newQuest)
                }
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.questionTable.isHidden = false
                
                self.questionTable.reloadData()
                
            }
            
        }
        
        // Do any additional setup after loading the view.
    }


    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        


        
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
