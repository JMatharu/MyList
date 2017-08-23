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
    var groceryItems:[GroceryItem] = []
    override func viewDidLoad() {
        getTotalAmountSpent()
        getAmountSpentByEachName()
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
        totalAmount.text = String(totalItem)
    }
    
    func getAmountSpentByEachName() {
        for item in groceryItems {
            if item.name == "Jagdeep" {
                print(item.amount)
            }
        }
    }
    
    func done() {
        dismiss(animated: true, completion: nil)
    }
}
