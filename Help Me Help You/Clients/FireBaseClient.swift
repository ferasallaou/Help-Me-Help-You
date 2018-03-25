//
//  FireBaseClient.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/13/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation
import Firebase



class FireBaseClient {
    
    
    func incrementBy(collection: String, document: String?, fieldToInc:String, database: Firestore, scoreObject: Bool?)
    {
     
        let docRef = database.collection("\(collection)").document("\(document!)")
        database.runTransaction({ (transaction, error) -> Any? in
            do {
                let refTransactoin = try transaction.getDocument(docRef).data()
                guard var refInfo = refTransactoin else {return nil}
                
                var objectToIncrement = refInfo["\(fieldToInc)"] as! Int
                
                objectToIncrement += 1
                refInfo["\(fieldToInc)"] = objectToIncrement
                
                if let _ = scoreObject {
                    if scoreObject! {
                        var currentScore = refInfo["score"] as! Int
                        currentScore += 10
                        let lastAnswer = refInfo["lastAnswer"] as! Date
                        let currentDate = Date()
                        let comparision = currentDate.compare(lastAnswer).rawValue
                        let comparisionInWeeks = comparision/7
                        if comparisionInWeeks != 0 {
                            currentScore = currentScore/comparisionInWeeks
                        }
                        refInfo["score"] = currentScore
                        refInfo["lastAnswer"] = Date()
                    }
                }
                
                transaction.setData(refInfo, forDocument: docRef)
            }catch{
                print("Error in getting Data")
            }
            
            
            return nil
        }) { (completionObj, complationErrir) in
            //
        }
    }
    
}
