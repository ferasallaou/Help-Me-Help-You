//
//  AnswersViewController.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/20/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import UIKit
import Firebase


class AnswersViewController: UIViewController {

    var question: Question?
    var suggestions = [Venues]()
    let database = Firestore.firestore()
    
    
    @IBOutlet weak var questionLable: UITextView!
    @IBOutlet weak var suggestionsTable: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noSuggestionsLable: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        questionLable.text = question!.question
        let myBtn = UIBarButtonItem(title: "Add Suggestion", style: UIBarButtonItemStyle.done, target: self, action: #selector(showSuggestions))
        self.navigationItem.rightBarButtonItem = myBtn
        // Do any additional setup after loading the view.
    }



     @objc func showSuggestions() {
        self.performSegue(withIdentifier: "showSuggestions", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSuggestions" {
            let mainNC = segue.destination as! UINavigationController
            let suggestionVC = mainNC.viewControllers[0] as! SuggestionViewController
            suggestionVC.question = self.question   
        }
        
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NetworkUtility().checkConnection(view: self, activity: activityIndicator)
        suggestions = []
        getSuggestions()
    }
    

    
    func getSuggestions() {
        noSuggestionsLable.isHidden = true
        suggestionsTable.isHidden = true
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        let quesRef = database.collection("Questions").document("\((question?.docID)!)")
        database.collection("Answers").whereField("questionRef", isEqualTo: quesRef).getDocuments(completion: {
            (snapshots, snapshotserror) in
            
            guard snapshotserror == nil else {
                print("There was an Error getting Suggestions")
                return
            }
            
            
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            
            if snapshots!.documents.count < 1 {
              self.noSuggestionsLable.isHidden = false
            }else{
                
                for singleItem in (snapshots?.documents)! {
                    let item = singleItem.data()
                    let venue = Venues(id: item["venueID"] as! String,
                                name: item["venueName"] as! String,
                                lat: item["lat"] as! Double,
                                lng: item["lng"] as! Double,
                                url: item["url"] as! String,
                                category: item["category"] as! String)
                    self.suggestions.append(venue)
                }

            self.suggestionsTable.isHidden = false
            self.suggestionsTable.reloadData()
            }
          
            
            
        })
    }

}
