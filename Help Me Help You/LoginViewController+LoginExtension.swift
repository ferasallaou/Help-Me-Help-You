//
//  LoginViewController+LoginExtension.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/10/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation
import FirebaseAuth

extension LoginViewController {
    
    
    func loginOrSignUp(email: String, password: String, loginSignUpCompletionHandler: @escaping (String?, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) {
            (user, error) in
            
            if let error = error {
                let foramtedError = error as NSError
                if foramtedError.code != 17011 {
                    loginSignUpCompletionHandler(foramtedError.localizedDescription, nil)
                }else {
                    // Proceeding to SignUp.....
                    
                    Auth.auth().createUser(withEmail: email, password: password){
                        (user, error) in
                        
                        guard error == nil else {
                            print("We got an error \(error!.localizedDescription)")
                            return
                        }
                        
                        //print(user)
                    }
                }
            }else{
            loginSignUpCompletionHandler(nil, "OK")
            }
            
            
         
        }
    }
}
