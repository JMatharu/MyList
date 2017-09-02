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
            for count in 0..<self.getAmountSpentByEachNameAsArray().count {
                amountNameString += nameArray[count] + " spent " + CurrencyFormatter().getLocalCurrency(amount: self.getAmountSpentByEachNameAsArray()[nameArray[count]]! as NSNumber) + "\n"
            }
            completion(amountNameString)
        }
    }
    
    func amountPerHead() -> Double {
        let totalNumberOfPeople = groceryObject.count
        let amountPerHead = getTotalAmount() / Double(totalNumberOfPeople)
        return amountPerHead
    }
    
    func brain() {
        let amountPerHead = self.amountPerHead()
        print(amountPerHead)
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
