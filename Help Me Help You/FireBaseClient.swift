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
    
    
    func incrementBy(collection: String, document: String?, fieldToInc:String, database: Firestore)
    {
     
        let docRef = database.collection("\(collection)").document("\(document!)")
        database.runTransaction({ (transaction, error) -> Any? in
            do {
                let refTransactoin = try transaction.getDocument(docRef).data()
                guard var refInfo = refTransactoin else {return nil}
                
                var objectToIncrement = refInfo["\(fieldToInc)"] as! Int
                objectToIncrement += 1
                refInfo["\(fieldToInc)"] = objectToIncrement
                
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
