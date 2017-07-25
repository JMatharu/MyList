//
//  FirebaseService.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-07-01.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import FirebaseDatabase

class MyListFirebase {
    
    var firebaseReference: FIRDatabaseReference? = FIRDatabase.database().reference()
    
    func getBadgeCount(closure:@escaping (UInt) -> ()) {
        var uidAsString = ""
        if let uid = UserDefaults.standard.string(forKey: Constants.UserDefaults.UID) {
            uidAsString = uid
        }
            self.firebaseReference?.child(Constants.Firebase.ParentGroceryRoot).child(uidAsString).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                closure(snapshot.childrenCount)
        })
    }
}
