//
//  CalculateModel.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-09-02.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import Foundation

class CalculateModel {
    
    private var nameList = [String]()
    private var groceryObject:[GroceryItem] = []
    
    convenience init(items: [GroceryItem]) {
        self.init()
        self.groceryObject.append(contentsOf: items)
    }
    
    func getTotalAmountSpent() -> String {
        return "Total Spent 💰 " + CurrencyFormatter().getLocalCurrency(amount: (getTotalAmount() as? NSNumber)!)
    }
    
    func getAllNames(completion:@escaping(String)->()) {
        NameCategorySharedService.sharedInstance.initializeNamesArray { (nameArray) in
            self.nameList = nameArray
            var amountNameString = ""
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = NSLocale.current
            var amountPerName = [String:Int]()
            if self.getAmountSpentByEachNameAsArray().count ==  self.nameList.count {
                amountPerName = self.getAmountSpentByEachNameAsArray()
            } else {
                var tempName = [String]()
                var tempNameAmount = [String]()
                var tempAmount = [Int]()
                
                for name in self.nameList {
                    tempName.append(name)
                }
                for (key, value) in self.getAmountSpentByEachNameAsArray() {
                    tempNameAmount.append(key)
                    tempAmount.append(value)
                }
                for name in tempName {
                    if tempNameAmount.contains(name) {
                        if self.getAmount(dictionary: self.getAmountSpentByEachNameAsArray(), key: name) != -1 {
                            amountPerName.updateValue(self.getAmount(dictionary: self.getAmountSpentByEachNameAsArray(), key: name), forKey: name)
                        }
                        
                    } else {
                        amountPerName.updateValue(0, forKey: name)
                    }
                }
            }
            
            for count in 0..<amountPerName.count {
                if (amountNameString.isEmpty) {
                    amountNameString += nameArray[count] + " spent " + CurrencyFormatter().getLocalCurrency(amount: amountPerName[nameArray[count]]! as NSNumber)
                } else {
                    amountNameString += "\n" + nameArray[count] + " spent " + CurrencyFormatter().getLocalCurrency(amount: amountPerName[nameArray[count]]! as NSNumber)
                }
            }
            completion(amountNameString)
        }
    }
    
    func getAmount(dictionary:[String:Int], key:String) -> Int {
        for (keyInner, value) in dictionary {
            if key == keyInner {
                return value
            }
        }
        return -1
    }
    
    func amountPerHead(completion:@escaping(Double)->()) {
        NameCategorySharedService.sharedInstance.initializeNamesArray { (nameArray) in
            self.nameList = nameArray
            let totalNumberOfPeople = self.getAmountSpentByEachNameAsArray().count
            let amountPerHead = self.getTotalAmount() / Double(totalNumberOfPeople)
            if String(amountPerHead) == "nan" {
                completion(0.0)
            } else {
                completion(amountPerHead)
            }
        }
    }
    
    func brain(completion:@escaping(String) -> ()) {
        var brainCalculation = ""
        amountPerHead { (amountPerHeadAfterClosure) in
            NameCategorySharedService.sharedInstance.initializeNamesArray { (nameArray) in
                self.nameList = nameArray
                for item in self.getAmountSpentByEachNameAsArray() {
                    if brainCalculation.isEmpty {
                        if (amountPerHeadAfterClosure - Double(item.value)) < 0.0 {
                            // negative, this user should get money
                            brainCalculation += item.key + " will get " + CurrencyFormatter().getLocalCurrency(amount: ((amountPerHeadAfterClosure - Double(item.value)) * -1) as NSNumber) + "🌟"
                        } else if (amountPerHeadAfterClosure - Double(item.value)) > 0.0 {
                            // Positive, this user needs to give money
                            brainCalculation += item.key + " will pay " + CurrencyFormatter().getLocalCurrency(amount: (amountPerHeadAfterClosure - Double(item.value)) as NSNumber)
                        } else if (amountPerHeadAfterClosure - Double(item.value)) == 0.0 {
                            // 0 , no give no get
                            brainCalculation += item.key + " neither owe nor pay"
                        }
                    } else {
                        if (amountPerHeadAfterClosure - Double(item.value)) < 0.0 {
                            // negative, this user should get money
                            brainCalculation += "\n" + item.key + " will get " + CurrencyFormatter().getLocalCurrency(amount: ((amountPerHeadAfterClosure - Double(item.value)) * -1) as NSNumber) + "🌟"
                        } else if (amountPerHeadAfterClosure - Double(item.value)) > 0.0 {
                            // Positive, this user needs to give money
                            brainCalculation += "\n" + item.key + " will pay " + CurrencyFormatter().getLocalCurrency(amount: (amountPerHeadAfterClosure - Double(item.value)) as NSNumber)
                        } else if (amountPerHeadAfterClosure - Double(item.value)) == 0.0 {
                            // 0 , no give no get
                            brainCalculation += "\n" + item.key + " neither owe nor pay"
                        }
                    }
                }
                completion(brainCalculation)
            }
        }
    }
    
    private func getTotalAmount() -> Double {
        var totalItem: Double = 0
        for item in groceryObject {
            totalItem += Double(item.amount)!
        }
        return totalItem
    }
    
    private func getAmountSpentByEachNameAsArray() -> [String:Int] {
        var amountPerName = [String:Int]()
        var nameInList = [String]()
        for item in groceryObject {
            if nameList.contains(item.name) {
                if nameInList.contains(item.name) {
                    amountPerName.updateValue(amountPerName[item.name]! + Int(item.amount)!, forKey: item.name)
                } else {
                    nameInList.append(item.name)
                    amountPerName.updateValue(Int(item.amount)!, forKey: item.name)
                }
            }
        }
        return amountPerName
    }
    
}
