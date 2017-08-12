//
//  FirebaseService.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-07-01.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import FirebaseDatabase
import SwiftSpinner

class FirebaseService {
    
    fileprivate var firebaseReference: FIRDatabaseReference? = FIRDatabase.database().reference()
    fileprivate var itemsUpdatedKeys: [String] = []
    
    func getBadgeCount(modalName:String ,completion:@escaping (UInt) -> ()) {
        switch modalName {
        case Constants.Feature.Grocery:
            self.firebaseReference?.child(self.getUid()).child(Constants.Firebase.ParentGroceryRoot).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                completion(snapshot.childrenCount)
            })
        default:
            completion(0)
        }
    }
    
    func getAllDataInSingleEvent(modalName:String ,completion:@escaping ([GroceryItem], [String]) -> ()) {
        var items: [GroceryItem] = []
        var itemsKeys: [String] = []
        firebaseReference?.child(self.getUid()).child(Constants.Firebase.ParentGroceryRoot).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount == 0 {
                //Stop Spinner
                SwiftSpinner.hide()
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
        switch modalName {
        case Constants.Feature.Grocery:
            firebaseReference?.child(self.getUid()).child(Constants.Firebase.ParentGroceryRoot).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
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
        default:
            print("Selected feature is not valid")
        }
        
    }
    
    func removeItemFrmFirebase(modalName: String, itemKeys: [String], index: Int) {
        switch modalName {
        case Constants.Feature.Grocery:
            firebaseReference?.child(self.getUid()).child(Constants.Firebase.ParentGroceryRoot).child(itemKeys[index]).removeValue()
        default:
            print("Selected feature is not valid")
        }
    }
    
    //Remove this method while removing NewGroceryListVC
    func saveNameOrCategoryToFirebase(type:String, text: String) {
        if type == "name" {
            firebaseReference?.child(self.getUid()).child(Constants.Firebase.ChildNameList).childByAutoId().setValue(text)
        } else {
            firebaseReference?.child(self.getUid()).child(Constants.Firebase.ChildCategoryList).childByAutoId().setValue(text)
        }
    }
    //-------
    
    func saveNameOrCategoryToFirebase(type:String, textList: [String:String]) {
        getAllKeysInNameAndCategory(type: type) { (keyList) in
            var localKeyList:[String] = []
            for(key, value) in textList {
                // When new item is added this IF block is used
                localKeyList.append(key)
                if keyList.contains(key) {
                    //                    print("Yes i am existing")
                } else {
                    //                    print("I am new with value: \(value)")
                    if type == "name" {
                        self.firebaseReference?.child(self.getUid()).child(Constants.Firebase.ChildNameList).childByAutoId().setValue(value)
                    } else {
                        self.firebaseReference?.child(self.getUid()).child(Constants.Firebase.ChildCategoryList).childByAutoId().setValue(value)
                    }
                }
            }
            //When any key is deleted
            //Find difference between keyList and textList and then delete from firebase if item is not in textList and is there in keyList
            if keyList.count == 1 && keyList[0] == "" {
                return
            }
            for item in keyList {
                if localKeyList.contains(item) {
                    print("I am avaliable in both places")
                } else {
                    print("I am not avaliable in firebase \(item)")
                    if type == "name" {
                        self.firebaseReference?.child(self.getUid()).child(Constants.Firebase.ChildNameList).child(item).removeValue()
                    } else {
                        self.firebaseReference?.child(self.getUid()).child(Constants.Firebase.ChildCategoryList).child(item).removeValue()
                    }
                }
            }
        }
    }
    
    private func getAllKeysInNameAndCategory(type:String, completion:@escaping([String])->()) {
        if type == "name" {
            firebaseReference?.child(self.getUid()).child(Constants.Firebase.ChildNameList).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.childrenCount == 0 {
                    completion([""])
                }
                guard let snap = snapshot.value as? NSDictionary else { return }
                var keyList:[String] = []
                for(key,_) in snap {
                    if let k = key as? String {
                        keyList.append(k)
                    }
                }
                completion(keyList)
            })
        } else {
            firebaseReference?.child(self.getUid()).child(Constants.Firebase.ChildCategoryList).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.childrenCount == 0 {
                    completion([""])
                }
                guard let snap = snapshot.value as? NSDictionary else { return }
                var keyList:[String] = []
                for(key,_) in snap {
                    if let k = key as? String {
                        keyList.append(k)
                    }
                }
                completion(keyList)
            })
        }
    }
    
    func deleteNameOrCategoryFromFirebase(type:String, itemKey:String) {
        if type == "name" {
            firebaseReference?.child(self.getUid()).child(Constants.Firebase.ChildNameList).child(itemKey).removeValue()
        } else {
            firebaseReference?.child(self.getUid()).child(Constants.Firebase.ChildCategoryList).child(itemKey).removeValue()
        }

    }
    
    func getNameOrCategoryFromFirebase(type:String, completion:@escaping([String:String])->()) {
        var names:[String] = []
        var nameKeys:[String] = []
        var nameDictionary:[String:String] = [:]
        var categories:[String] = []
        var categoriesKeys:[String] = []
        var categoryDictionary:[String:String] = [:]
        switch type {
        case "name":
            firebaseReference?.child(self.getUid()).child(Constants.Firebase.ChildNameList).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let snap = snapshot.value as? NSDictionary else {
                    completion(["":""])
                    return
                }
                for(key, value) in snap {
                    if let name = value as? String {
                        names.append(name)
                    }
                    if let key = key as? String {
                        nameKeys.append(key)
                    }
                }
                for index in 0..<names.count {
                    nameDictionary.updateValue(names[index], forKey: nameKeys[index])
                }
                completion(nameDictionary)
            })
        case "category":
            firebaseReference?.child(self.getUid()).child(Constants.Firebase.ChildCategoryList).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let snap = snapshot.value as? NSDictionary else {
                    completion(["":""])
                    return
                }
                for(key, value) in snap {
                    if let category = value as? String {
                        categories.append(category)
                    }
                    if let key = key as? String {
                        categoriesKeys.append(key)
                    }
                }
                for index in 0..<categories.count {
                    categoryDictionary.updateValue(categories[index], forKey: categoriesKeys[index])
                }
                completion(categoryDictionary)
            })
        default:
            print("Not a valid type.....")
        }
    }
    
    func saveGroceryList(dictionaryOfData:[String:String]) {
        firebaseReference?.child(self.getUid()).child(Constants.Firebase.ParentGroceryRoot).childByAutoId().setValue(dictionaryOfData)
    }
    
    func saveEditedGroceryList(key:String, dictionaryOfData:[String:String]) {
        firebaseReference?.child(self.getUid()).child(Constants.Firebase.ParentGroceryRoot).child(key).setValue(dictionaryOfData)
    }
    
    private func getDifferentElementFromUpdatedList(updatedItemKeys: [String], items:[GroceryItem], updatedListCount:Int, newItemReverseIndex: Int, completion:@escaping ([GroceryItem]) -> ()) {
        var itemsAsVar = items
        firebaseReference?.child(self.getUid()).child(Constants.Firebase.ParentGroceryRoot).child(updatedItemKeys.sorted()[updatedListCount - newItemReverseIndex]).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
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
