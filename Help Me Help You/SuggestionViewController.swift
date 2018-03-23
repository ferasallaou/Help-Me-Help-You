//
//  SuggestionViewController.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/12/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class SuggestionViewController: UIViewController {
    
    var question: Question?
    var venuesArr: [Venues] = [Venues]()

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var suggestionsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSuggestions()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func cancelSuggestion(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func getSuggestions() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        suggestionsTable.isHidden = true
        
        let ll = "\(question!.cityCoordinates.latitude),\(question!.cityCoordinates.longitude)"
        let parameters: [String: String] = [
            "ll": "\(ll)",
            "radius": "2000",
            "client_id": fourSquare().clientID,
            "client_secret": fourSquare().clientSecret,
            "v": "20190101",
            "limit": "20"
        ]
    
        NetworkClient().getVenus(parameters: parameters){
            (venues, error) in
            
            guard error == nil else {
                let alert = UIAlertController(title: "Error", message: error!, preferredStyle: UIAlertControllerStyle.alert)
                let okBtn = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(okBtn)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            self.venuesArr = venues!
            
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.suggestionsTable.isHidden = false
            self.suggestionsTable.reloadData()
            
        }
        
    
        
    }
    

}
