//
//  MainViewController.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/7/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MainViewController: UIViewController {
    
    @IBOutlet weak var mainLable: UILabel!
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var noQuestionsLable: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var questions = [Question]()
    let customLocationManager = LocationManager()
    var database: Firestore!
  

    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        customLocationManager.getUserLocation() 
         database = Firestore.firestore()

        // Do any additional setup after loading the view, typically from a nib.
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserInfo()
        getQuestions()
        NetworkUtility().checkConnection(view: self, activity: activityIndicator)
    }

    
    func getQuestions() {
        questions = []
        self.noQuestionsLable.isHidden = true
        self.mainTable.isHidden = true
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        database.collection("Questions").whereField("userid", isEqualTo: (Auth.auth().currentUser?.uid)!).order(by: "postedAt", descending: true).getDocuments {
            (userDocs, userErr) in
            
            guard userErr == nil else {
                print("There was an Error! \(String(describing: userErr?.localizedDescription))")
                return
            }
            
            if (userDocs?.documents.count)! > 0 {
                for singleItem in userDocs!.documents
                {
                    let item = singleItem.data()
                    let userRef = self.database.collection("Users").document("\((Auth.auth().currentUser?.uid)!)")
                    let question = Question(cityCoordinates: item["cityCoordinates"] as! GeoPoint,
                                    cityName: item["cityName"] as! String,
                                    postedAt: item["postedAt"] as! Date,
                                    question: item["question"] as! String,
                                    userid: item["userid"] as! String,
                                    docID: singleItem.documentID,
                                    userReference: userRef,
                                    suggestions: item["suggestions"] as! Int)
                    
                    
                    self.mainTable.isHidden = false
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    
                    self.questions.append(question)
                    self.mainTable.reloadData()
                }
            }else{
                self.mainTable.isHidden = true
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.noQuestionsLable.isHidden = false
            }
        }
    }
    
    func getUserInfo() {
        
        let userID = Auth.auth().currentUser?.uid
        database.collection("Users").document("\(userID!)").getDocument { (userSnapShot, userError) in
            
            guard userError == nil else {
                print("There was an Error getting User's Data")
                return
            }
            
            let userData = userSnapShot?.data()
            self.mainLable.text = "\((userData!["name"])!) \n Score: \((userData!["score"])!) \n Total Questions: \((userData!["questions"])!) \n Total Answers: \((userData!["answers"])!)"
        }
    }
    
    @IBAction func aboutBtn(_ sender: Any) {
        let appDescription = "Help Me Help You is an App designed to help using real locations with one idea, the more you help people, the more your chance of getting help. And in case you are wondering, the App just covers your city in an attempt to give authentic answers."
        NetworkUtility().showAlert(title: "About", message: appDescription, view: self, btnTitle: "Got It")
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                self.tabBarController?.selectedIndex = 0
            }catch{
                NetworkUtility().showAlert(title: "Oops", message: "Error Logging Out", view: self, btnTitle: "Ok")
            }
        }
    }
    

}

