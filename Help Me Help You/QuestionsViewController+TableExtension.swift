//
//  QuestionsViewController+TableExtension.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/14/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation
import UIKit


extension QuestionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell")
        let item = question[indexPath.row]
    
        
        cell?.textLabel?.text = item.question
        cell?.detailTextLabel?.text = "By \(item.userid) - On \(item.postedAt)"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let item = question[indexPath.row]
        if let qID = questionID, item.docID == qID{    
            cell.setSelected(true, animated: true)
            questionID = nil
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = question[indexPath.row]
        let getUserDetails = item.userReference
        getUserDetails.getDocument { (returnedDoc, returnedErr) in
        
            guard returnedErr == nil else {
                print("Error getting User Info")
                return
            }
            
            let fullname = (returnedDoc!["name"])!
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "showQuestion") as! ShowQuestionViewController
            nextVC.questionID = "\(item.docID) && \(item.question) ++ \(fullname)"
            self.navigationController!.pushViewController(nextVC, animated: true)
        }
        
        
    }
    
    
}
