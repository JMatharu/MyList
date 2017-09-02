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
    @IBOutlet weak var amountPerHead: UILabel!
    var groceryItems:[GroceryItem] = []
    
    override func viewDidLoad() {
        totalAmount.text = CalculateModel.init(items: groceryItems).getTotalAmountSpent()
        CalculateModel.init(items: groceryItems).brain()
        amountPerHead.text = "Total amount per head 💸 " + String(CalculateModel.init(items: groceryItems).amountPerHead())
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
    
    func done() {
        dismiss(animated: true, completion: nil)
    }
    
    private func getAllNames() {
        CalculateModel.init(items: groceryItems).getAllNames { (amountName) in
            self.amountPerName.text = amountName
            SwiftSpinner.hide()
        }
    }
}
