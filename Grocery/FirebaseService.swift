//
//  FirebaseService.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-07-01.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import FirebaseDatabase

class FirebaseService {
    
    fileprivate var firebaseReference: FIRDatabaseReference? = FIRDatabase.database().reference()
    
    func getBadgeCount(closure:@escaping (UInt) -> ()) {
            self.firebaseReference?.child(Constants.Firebase.ParentGroceryRoot).child(self.getUid()).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                closure(snapshot.childrenCount)
        })
    }
    
    private func getUid() -> String {
        var uidAsString = ""
        if let uid = UserDefaults.standard.string(forKey: Constants.UserDefaults.UID) {
            uidAsString = uid
        }
        return uidAsString
    }
}
