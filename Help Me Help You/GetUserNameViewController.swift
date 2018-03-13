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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func saveUserName(_ sender: Any) {
        proceedBtn.isEnabled = false
        
        if usernameTextField.text?.isEmpty ?? true {
         let alert = UIAlertController(title: "Missing Info", message: "Please fill in your name", preferredStyle: UIAlertControllerStyle.alert)
            let okBtn = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okBtn)
            self.present(alert, animated: true, completion: nil)
            proceedBtn.isEnabled = true
        }else{
            let dataToSave  = [
                "name" : usernameTextField.text!,
                "questions": 0,
                "answers" : 0,
                "score": 0,
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
