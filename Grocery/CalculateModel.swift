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
    
    func getTotalAmountSpent(groceryItems: [GroceryItem]) -> String {
        var totalItem: Int = 0
        for item in groceryItems {
            totalItem += Int(item.amount)!
        }
        return "Total Spent 💰 " + CurrencyFormatter().getLocalCurrency(amount: (totalItem as? NSNumber)!)
    }
    
    func getAllNames(groceryItems: [GroceryItem], completion:@escaping(String)->()) {
        NameCategorySharedService.sharedInstance.initializeNamesArray { (nameArray) in
            self.nameList = nameArray
            var amountNameString = ""
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = NSLocale.current
            for count in 0..<self.getAmountSpentByEachNameAsArray(groceryItems: groceryItems).count {
                amountNameString += nameArray[count] + " spent " + CurrencyFormatter().getLocalCurrency(amount: self.getAmountSpentByEachNameAsArray(groceryItems: groceryItems)[nameArray[count]]! as NSNumber) + "\n"
            }
            completion(amountNameString)
        }
    }
    
    private func getAmountSpentByEachNameAsArray(groceryItems: [GroceryItem]) -> [String:Int] {
        var amountPerName = [String:Int]()
        var nameInList = [String]()
        for item in groceryItems {
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
