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
    fileprivate var itemsUpdatedKeys: [String] = []
    
    func getBadgeCount(completion:@escaping (UInt) -> ()) {
            self.firebaseReference?.child(Constants.Firebase.ParentGroceryRoot).child(self.getUid()).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                completion(snapshot.childrenCount)
        })
    }
    
    func getAllDataInSingleEvent(modalName:String ,completion:@escaping ([GroceryItem], [String]) -> ()) {
        var items: [GroceryItem] = []
        var itemsKeys: [String] = []
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
                            items.append(firebaseRow)
                        default:
                            print("Selected feature is not valid")
                        }
                    }
                    
                    if let key = key as? String {
                        itemsKeys.append(key)
                    }
                }
                completion(items, itemsKeys)
            }
        })
    }
    
    // pass itemsKeys and groceryItemUpdateKeys
    func getUpdatedDataInSingleEvent(modalName: String, itemsKeys:[String], completion:@escaping([GroceryItem], [String]) -> ()) {
        let innerItems: [GroceryItem] = []
        var innerItemKeys: [String] = []
        firebaseReference?.child(Constants.Firebase.ParentGroceryRoot).child(self.getUid()).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            guard let snap = snapshot.value as? NSDictionary else { return }
            for(key, _) in snap {
                if let key = key as? String {
                    self.itemsUpdatedKeys.append(key)
                }
            }
            
            let newElementCount = self.itemsUpdatedKeys.sorted().count - itemsKeys.sorted().count
            if newElementCount > 0 {
                // get difference , and get those element
                let updatedListCount = self.itemsUpdatedKeys.sorted().count
                for newItemReverseIndex in 1...newElementCount {
                    innerItemKeys.append(self.itemsUpdatedKeys.sorted()[updatedListCount - newItemReverseIndex])
                    
                    // inner firebasecall
                    self.getDifferentElementFromUpdatedList(updatedItemKeys: self.itemsUpdatedKeys, items: innerItems, updatedListCount: updatedListCount, newItemReverseIndex: newItemReverseIndex, completion: { (groceryItem) in
                        completion(groceryItem, innerItemKeys)
                    })
                }
            }
        })
    }
    
    private func getDifferentElementFromUpdatedList(updatedItemKeys: [String], items:[GroceryItem], updatedListCount:Int, newItemReverseIndex: Int, completion:@escaping ([GroceryItem]) -> ()) {
        var itemsAsVar = items
        firebaseReference?.child(Constants.Firebase.ParentGroceryRoot).child(self.getUid()).child(updatedItemKeys.sorted()[updatedListCount - newItemReverseIndex]).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            guard let snap = snapshot.value as? NSDictionary else { return }
            
            let firebaseRow = GroceryItem()
            firebaseRow.amount = self.getFirebaseChildValueWithKey(Constants.Firebase.ChildAmount, withDictionary: snap)
            firebaseRow.category = self.getFirebaseChildValueWithKey(Constants.Firebase.ChildCategory, withDictionary: snap)
            firebaseRow.name = self.getFirebaseChildValueWithKey(Constants.Firebase.ChildName, withDictionary: snap)
            firebaseRow.store = self.getFirebaseChildValueWithKey(Constants.Firebase.ChildStore, withDictionary: snap)
            itemsAsVar.append(firebaseRow)
            completion(itemsAsVar)
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
