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
    
        Alamofire.request(fourSquare().getVenus, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON {
            response in
            
            if let results = response.result.value as? [String: Any]{
                let statusCode = results["meta"] as? [String: Any]
                let code = (statusCode!["code"])! as? Int
                if code == 200 {
                    if let responseObj = results["response"] as? [String: Any], responseObj["totalResults"] as! Int > 0 {
                        let groups = responseObj["groups"] as? [Any]
                        let itemsArr = groups![0] as? [String: Any]
                        let items = itemsArr!["items"] as? [[String:Any]]
                        for singleItem in items! {
                            let singleVenue = singleItem["venue"] as? [String: Any]
                            let venue = Venues(id: singleVenue!["id"] as! String , name: singleVenue!["name"] as! String, lat: 1.00, lng: 1.00, url: "", category:"")
                            self.venuesArr.append(venue)
                        }
                    }
                    
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.suggestionsTable.isHidden = false
                    self.suggestionsTable.reloadData()
                    
                }else{
                    print("There was an Error connecting to the API")
                    
                }
            }
            
        }

        
    }
    

}
