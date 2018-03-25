//
//  AskForHelpVC+TextViewExtension.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/12/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation
import  UIKit

extension AskForHelpViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let placeholder = textView.text, placeholder == "Write Your Question" {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let placeholder = textView.text, placeholder == "" {
            textView.text = "Write Your Question"
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            view.endEditing(true)
            return false
        }else{
            return true
        }
    }
}
