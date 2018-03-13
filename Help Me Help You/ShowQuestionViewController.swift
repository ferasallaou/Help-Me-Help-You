//
//  ShowQuestionViewController.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/12/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import UIKit
import Firebase

class ShowQuestionViewController: UIViewController {
    
    var questionID: String? = ""
 
    @IBOutlet weak var showID: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showID.text = questionID

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    



}
