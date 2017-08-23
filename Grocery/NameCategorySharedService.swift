//
//  NameCategorySharedService.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-08-17.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import Foundation

class NameCategorySharedService {
    private init() {
        
    }
    
    static let sharedInstance = NameCategorySharedService()
    
    func initializeNamesArray(completion:@escaping([String]) -> ()) {
        self.getNameListFromFirebase { (nameList) in
            completion(nameList)
        }
    }
    
    func initializeCategoryArray(completion:@escaping([String]) -> ()) {
        self.getCategoryListFromFirebase { (categoryList) in
            completion(categoryList)
        }
    }
    
    private func getNameListFromFirebase(completion:@escaping ([String]) -> ()) {
        FirebaseService().getNameOrCategoryFromFirebase(type: "name") { (nameDictionary) in
            var namesArrayInner:[String] = []
            for (_, value) in nameDictionary {
                namesArrayInner.append(value)
            }
            completion(namesArrayInner)
        }
    }
    
    private func getCategoryListFromFirebase(completion:@escaping([String]) -> ()) {
        FirebaseService().getNameOrCategoryFromFirebase(type: "category") { (catDictionary) in
            var catArray:[String] = []
            for (_, value) in catDictionary {
                catArray.append(value)
            }
            completion(catArray)
        }
    }
}
