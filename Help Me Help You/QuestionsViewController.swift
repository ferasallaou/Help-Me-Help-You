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
        var userReference: DocumentReference
    }
    
    // Outlets
    @IBOutlet weak var refreshDataBtn: UIBarButtonItem!
    @IBOutlet weak var refreshLocationBtn: UIBarButtonItem!
    @IBOutlet weak var questionTable: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noQuestionsLable: UILabel!
    
    
    var question: [questionDT] = [questionDT]()
    var ref : DocumentReference? = nil
    var database : Firestore? = nil
    var userCity: String? = nil
    let customLocation = LocationManager()
    var questionID : String?
    
    override func viewDidLoad() {
        question = []
        super.viewDidLoad()
        database = Firestore.firestore()
        customLocation.getAdress() {
            (address, error) in
            
            guard error == nil else {
                print("Coudln't get Your City")
                return
            }
            
            if let cityAsString = address {
                self.userCity = cityAsString as? String
            }
            
            self.navigationController?.navigationBar.topItem?.title = self.userCity
            if let foundCity = self.userCity {
                self.getQuestions()
            }else{
                print("No City Yet! ")
            }
        }
        
        // Do any additional setup after loading the view.
    }


    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
    }
    
    
   
    @IBAction func refreshData(_ sender: Any) {
        getQuestions()
    }
    
    @IBAction func refreshLocation(_ sender: Any) {

        customLocation.getAdress() {
            (address, error) in
            
            guard error == nil else {
                print("Couldn't get new Address :( ")
                return
            }
            

            if let cityAsString = address {
                self.userCity = cityAsString
            }
            
            self.navigationController?.navigationBar.topItem?.title = self.userCity

            self.getQuestions()
            
        }
        
    }

    
    func getQuestions() {
        self.noQuestionsLable.isHidden = true
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        questionTable.isHidden = true
        self.refreshDataBtn.isEnabled = false
        self.refreshLocationBtn.isEnabled = false
        
        let query = self.database!.collection("Questions").whereField("cityName", isEqualTo: self.userCity!)
        
        query.getDocuments { (documents, error) in
            guard error == nil else {
                print("Error Getting Data")
                return
            }
            
            self.question = []
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.refreshLocationBtn.isEnabled = true
            self.refreshDataBtn.isEnabled = true
            if (documents?.documents.count)! < 1 {
                self.noQuestionsLable.isHidden = false
            }else{
                for singleDoc in (documents?.documents)! {
                    let singleObject = singleDoc.data()
                    let newQuest = questionDT(cityCoordinates: singleObject["cityCoordinates"] as! GeoPoint, cityName: singleObject["cityName"] as! String, postedAt: singleObject["postedAt"] as! Date, question: singleObject["question"] as! String, userid: singleObject["userid"] as! String, docID: singleDoc.documentID, userReference: singleObject["userReference"] as! DocumentReference)
                    self.question.append(newQuest)
                }
                
                self.questionTable.isHidden = false
                self.questionTable.reloadData()
            }
         
            
         
            
        }
    }

}
