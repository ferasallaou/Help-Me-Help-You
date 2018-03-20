//
//  AnswersViewController.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/20/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import UIKit

class AnswersViewController: UIViewController {

    var question: Question?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }



    @IBAction func showSuggestions(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSuggestions" {
            let mainNC = segue.destination as! UINavigationController
            let suggestionVC = mainNC.viewControllers[0] as! SuggestionViewController
            suggestionVC.question = self.question   
        }
        
    }


}
