//
//  SuggestionVC+Extension.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/20/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation
import UIKit

extension SuggestionViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venuesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")
        let item = venuesArr[indexPath.row]
        
        cell?.textLabel?.text = item.name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = venuesArr[indexPath.row]
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "VenueVC") as! VenueViewController
        nextVC.mVenue = item
        nextVC.question = self.question
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    
}
