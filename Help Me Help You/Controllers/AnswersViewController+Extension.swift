//
//  AnswersViewController+Extension.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/21/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import UIKit

extension AnswersViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = suggestions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")
        cell?.textLabel?.text = item.name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = suggestions[indexPath.row]
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "VenueVC") as! VenueViewController
        nextVC.mVenue = item
        nextVC.question = self.question
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
}
