//
//  LoginViewController.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/10/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginSignupBtn: UIButton!
    @IBOutlet weak var responseLable: UILabel!
    let database = Firestore.firestore()
    let customLocation =  LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customLocation.presentAuth()
        Misc().checkConnection(view: self)
        // Do any additional setup after loading the view.
    }


    
    @IBAction func loginBtn(_ sender: Any) {
        responseLable.text = ""
        loginSignupBtn.isEnabled = false
        checkLoginField()
    }
    
    func checkLoginField() {
        if emailTextField.text?.isEmpty ?? true {
            responseLable.text = "Please Fill in Your login Credentials"
            loginSignupBtn.isEnabled = true
            return
        }
        
        if passwordTextField.text?.isEmpty ?? true{
            responseLable.text = "Please Fill in Your login Credentials"
            loginSignupBtn.isEnabled = true
            return
        }
        

        self.loginOrSignUp(email: emailTextField.text!, password: passwordTextField.text!) {
            (error, userSatus) in
            
            guard error == nil else {
                self.responseLable.text = "\(error!)"
                self.loginSignupBtn.isEnabled = true
                return
            }
            
            let userID = Auth.auth().currentUser?.uid
            self.database.collection("Users").document("\(userID!)").getDocument(completion: { (gotUser, noUser) in
                
                guard noUser == nil else {
                    print("Error Checking User Info")
                    return
                }
                
                if let _ = gotUser?.data() {
                    self.dismiss(animated: true, completion: nil)
                }else{
                    let userNameVC = self.storyboard?.instantiateViewController(withIdentifier: "userNameVC")
                    self.present(userNameVC!, animated: true, completion: nil)
                    return
                }
            })
            
            
            
        }
        
        
    }

}
