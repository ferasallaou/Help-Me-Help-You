//
//  LoginViewController.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/10/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var responseLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        responseLable.text = ""
     checkLoginField()
    }
    
    func checkLoginField() {
        //print(emailTextField.text!)
        if emailTextField.text?.isEmpty ?? true {
            responseLable.text = "Please Fill in Your login Credentials"
            return
        }
        
        if passwordTextField.text?.isEmpty ?? true{
            responseLable.text = "Please Fill in Your login Credentials"
        }
        
        self.loginOrSignUp(email: emailTextField.text!, password: passwordTextField.text!) {
            (error, userSatus) in
            
            guard error == nil else {
                self.responseLable.text = "\(error!)"
                return
            }
            
            
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }

}
