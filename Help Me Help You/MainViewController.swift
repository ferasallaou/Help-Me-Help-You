//
//  MainViewController.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/7/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import UIKit
import Alamofire
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
        customLocationManager.getUserLocation() 
         database = Firestore.firestore()

        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserInfo()
        getQuestions()
    }

    
    func getQuestions() {
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
        let about = UIAlertController(title: "About", message: appDescription, preferredStyle: UIAlertControllerStyle.alert)
        let gotItBtn = UIAlertAction(title: "Got It", style: UIAlertActionStyle.default, handler: nil)
        about.addAction(gotItBtn)
        self.present(about, animated: true, completion: nil)
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginVC")
                self.present(loginVC!, animated: true, completion: nil)
            }catch let error as NSError{
                print("Logout error \(error.localizedDescription)")
            }
        }
    }
    

}

