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
    fileprivate var items: [GroceryItem] = []
    fileprivate var itemsKeys: [String] = []
    
    func getBadgeCount(completion:@escaping (UInt) -> ()) {
            self.firebaseReference?.child(Constants.Firebase.ParentGroceryRoot).child(self.getUid()).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                completion(snapshot.childrenCount)
        })
    }
    
    func getAllDataInSingleEvent(modalName:String ,completion:@escaping ([GroceryItem], [String]) -> ()) {
        firebaseReference?.child(Constants.Firebase.ParentGroceryRoot).child(self.getUid()).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount == 0 {
                //Spinner.hide()
            } else {
                guard let snap = snapshot.value as? NSDictionary else { return }
                for(key ,value) in snap {
                    if let item = value as? NSDictionary {
                        switch (modalName)
                        {
                        case Constants.Feature.Grocery:
                            // Need to create grocery object each time, if we use modelobject as argument of this method then it will create copy of same object and will update array with last element everytime
                            let firebaseRow = GroceryItem()
                            firebaseRow.amount = self.getFirebaseChildValueWithKey(Constants.Firebase.ChildAmount, withDictionary: item)
                            firebaseRow.category = self.getFirebaseChildValueWithKey(Constants.Firebase.ChildCategory, withDictionary: item)
                            firebaseRow.name = self.getFirebaseChildValueWithKey(Constants.Firebase.ChildName, withDictionary: item)
                            firebaseRow.store = self.getFirebaseChildValueWithKey(Constants.Firebase.ChildStore, withDictionary: item)
                            firebaseRow.timestamp = self.getFirebaseChildValueWithKey(Constants.Firebase.ChildDate, withDictionary: item)
                            self.items.append(firebaseRow)
                        default:
                            print("Selected feature is not valid")
                        }
                    }
                    
                    if let key = key as? String {
                        self.itemsKeys.append(key)
                    }
                }
                completion(self.items, self.itemsKeys)
            }
        })
    }
    
    private func getUid() -> String {
        var uidAsString = ""
        if let uid = UserDefaults.standard.string(forKey: Constants.UserDefaults.UID) {
            uidAsString = uid
        }
        return uidAsString
    }
    
    private func getFirebaseChildValueWithKey(_ key: String, withDictionary items: NSDictionary) -> String {
        var childItem = ""
        if let item = items.value(forKey: key) as? String {
            childItem = item
        }
        return childItem
    }
}
