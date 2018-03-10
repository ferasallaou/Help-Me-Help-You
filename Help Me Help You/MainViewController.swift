//
//  MainViewController.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/7/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseAuth

class MainViewController: UIViewController {
    
    var userHandler: AuthStateDidChangeListenerHandle?
    
    @IBAction func loginBtn(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
            try Auth.auth().signOut()
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginVC")
                self.present(loginVC!, animated: true, completion: nil)
            }catch let error as NSError{
                print("Logout errro \(error.localizedDescription)")
                
            }
            
        }
    }
    @IBOutlet weak var login: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let userHandler = userHandler {
        Auth.auth().removeStateDidChangeListener(userHandler)
        }
        
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userHandler = Auth.auth().addStateDidChangeListener {
            (auth, user) in
            
            guard user != nil else {
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginVC")
                self.present(loginVC!, animated: true, completion: nil)
                return
            }
            
            print(user?.email)

        }
    }

}

