//
//  MainViewController+Extension.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/21/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation
import UIKit

extension MainViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = questions[indexPath.row]
       let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")
        cell?.textLabel?.text = item.question
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = questions[indexPath.row]
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "showQuestion") as! AnswersViewController
        nextVC.question = item
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
}
