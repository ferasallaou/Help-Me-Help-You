//
//  GetUserNameViewController.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/13/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import UIKit
import Firebase

class GetUserNameViewController: UIViewController {
    
    var database: Firestore? = nil
    var ref: DocumentReference? = nil
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var infoLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Firestore.firestore()
        // Do any additional setup after loading the view.
    }


    @IBAction func saveUserName(_ sender: Any) {
        proceedBtn.isEnabled = false
        
        if usernameTextField.text?.isEmpty ?? true {
            Misc().showAlert(title: "Missing Info", message: "Please fill in your name", view: self, btnTitle: "Ok")
            proceedBtn.isEnabled = true
        }else{
            let dataToSave  = [
                "name" : usernameTextField.text!,
                "questions": 0,
                "answers" : 0,
                "score": 0,
                "lastAnswer": Date()
            ] as [String:Any]
            
            let userID = Auth.auth().currentUser?.uid
            database!.collection("Users").document("\(userID!)").setData(dataToSave) {
                err in
                
                guard err == nil else {
                    self.infoLable.text = "There is an Error \(err?.localizedDescription ?? "Saving")"
                    return
                }
                
                let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "mainVC")
                self.present(mainVC!, animated: true, completion: nil)
                
            }
        }
    }
}
