//
//  CalculateViewController.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-07-28.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import UIKit
import SwiftSpinner

class CalculateViewController: UIViewController {
    
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var amountPerName: UILabel!
    var groceryItems:[GroceryItem] = []
    var nameList = [String]()
    
    override func viewDidLoad() {
        getTotalAmountSpent()
        getAllNames()
    }
    
    override func viewWillLayoutSubviews() {
        //Setup Nav Bar
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: Int(Constants.UIDimentions.NavigationBarHeight)))
        self.view.addSubview(navigationBar)
        let navItem: UINavigationItem
        navItem = UINavigationItem(title: Constants.Titles.Result)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(AddEditItemViewController.done))
        navItem.rightBarButtonItem = doneBarButton
        navigationBar.setItems([navItem], animated: true)
        navigationBar.barTintColor = UIColor.navigationBarColor
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationBar.tintColor = UIColor.white
    }
    
    private func getTotalAmountSpent() {
        var totalItem: Int = 0
        for item in groceryItems {
            totalItem += Int(item.amount)!
        }
        totalAmount.text = "Total Spent 💰 " + CurrencyFormatter().getLocalCurrency(amount: (totalItem as? NSNumber)!)
    }
    
    func getAmountSpentByEachNameAsArray() -> [String:Int] {
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
    
    func done() {
        dismiss(animated: true, completion: nil)
    }
    
    private func getAllNames() {
        NameCategorySharedService.sharedInstance.initializeNamesArray { (nameArray) in
            self.nameList = nameArray
            var amountNameString = ""
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = NSLocale.current
            for count in 0..<self.getAmountSpentByEachNameAsArray().count {
                amountNameString += nameArray[count] + " spent " + CurrencyFormatter().getLocalCurrency(amount: self.getAmountSpentByEachNameAsArray()[nameArray[count]]! as NSNumber) + "\n"
            }
            self.amountPerName.text = amountNameString
            SwiftSpinner.hide()
        }
    }
}
