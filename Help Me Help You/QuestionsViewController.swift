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

    
    // Outlets
    @IBOutlet weak var refreshDataBtn: UIBarButtonItem!
    @IBOutlet weak var refreshLocationBtn: UIBarButtonItem!
    @IBOutlet weak var questionTable: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noQuestionsLable: UILabel!
    
    
    
    var question: [Question] = [Question]()
    var ref : DocumentReference? = nil
    var database : Firestore? = nil
    var userCity: String? = nil
    let customLocation = LocationManager()
    var questionID : String?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userHandler: AuthStateDidChangeListenerHandle?
    
    
    
    override func viewDidLoad() {
        question = []
        super.viewDidLoad()
        database = Firestore.firestore()
        
        questionID = nil
        Misc().checkConnection(view: self)
        // Do any additional setup after loading the view.
    }


    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        userHandler = Auth.auth().addStateDidChangeListener {
            (auth, user) in
            
            guard user != nil else {
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginVC")
                self.present(loginVC!, animated: true, completion: nil)
                return
            }
            
        self.questionID = self.appDelegate.sharedData.value(forKey: "postedQuestionID") as? String
            self.getQuestions()
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let userHandler = userHandler {
            Auth.auth().removeStateDidChangeListener(userHandler)
        }
        appDelegate.sharedData.set(nil, forKey: "postedQuestionID")
        questionID = nil

    }
    
   
    @IBAction func refreshData(_ sender: Any) {
        getQuestions()
    }
    
    @IBAction func refreshLocation(_ sender: Any) {
        self.getQuestions()        
    }

    
    func getQuestions() {
        self.noQuestionsLable.isHidden = true
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        questionTable.isHidden = true
        self.refreshDataBtn.isEnabled = false
        self.refreshLocationBtn.isEnabled = false
        
        customLocation.locationManager.requestWhenInUseAuthorization()
        customLocation.getAdress() {
            (address, error) in
            
            
            guard error == nil else {
                Misc().showAlert(title: "Oops", message: "Couldn't get new Address :( ", view: self, btnTitle: "Ok")
                return
            }
            
            
            if let cityAsString = address {
                self.userCity = cityAsString
            }
            
            self.navigationController?.navigationBar.topItem?.title = self.userCity
            let query = self.database!.collection("Questions").whereField("cityName", isEqualTo: self.userCity!).order(by: "score", descending: true)
            query.getDocuments { (documents, error) in
                guard error == nil else {
                    Misc().showAlert(title: "Oops", message: "Error Getting Data \(error!.localizedDescription) ", view: self, btnTitle: "Ok")
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
                        let newQuest = Question.init(cityCoordinates: singleObject["cityCoordinates"] as! GeoPoint, cityName: singleObject["cityName"] as! String, postedAt: singleObject["postedAt"] as! Date, question: singleObject["question"] as! String, userid: singleObject["userid"] as! String, docID: singleDoc.documentID, userReference: singleObject["userReference"] as! DocumentReference, suggestions: singleObject["suggestions"] as! Int)
                        self.question.append(newQuest)
                    }
                    
                    self.questionTable.isHidden = false
                    self.questionTable.reloadData()
                }
            }
        }
    }
}
