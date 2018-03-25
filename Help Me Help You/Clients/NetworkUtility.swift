//
//  NetworkUtility.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/24/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation
import UIKit
import Reachability

class NetworkUtility{

    let reachability = Reachability()!
    
    func showAlert(title: String,message: String, view: UIViewController, btnTitle: String){
        DispatchQueue.main.async {
          
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "\(btnTitle)", style: .default, handler: nil)
        alert.addAction(okBtn)
        view.present(alert, animated: true, completion: nil)
        }
    }
    
    func checkConnection(view: UIViewController, activity: UIActivityIndicatorView?) {
        reachability.whenUnreachable = {
            _ in
            self.showAlert(title: "No Internet", message: "Failed to connect.", view: view, btnTitle: "Ok")
            if let _ = activity {
                activity?.stopAnimating()
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    
}
