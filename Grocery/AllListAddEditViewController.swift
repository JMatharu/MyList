//
//  AllListAddEditViewController.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-07-22.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import UIKit

class AllListAddEditViewController: UITableViewController {
    
    @IBOutlet weak var itemTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        updateTableUI()
        addPadding(textField: itemTextField)
    }
    
    //MARK: - Methods
    private func setNavigationBar() {
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: Int(Constants.UIDimentions.NavigationBarHeight)))
        self.view.addSubview(navigationBar)
        let navItem: UINavigationItem
//        if itemToEdit != nil {
//            navItem = UINavigationItem(title: Constants.Titles.EditItem)
//        } else {
//            
//        }
        navItem = UINavigationItem(title: Constants.Titles.AddItem)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(AddEditItemViewController.done))
        navItem.rightBarButtonItem = doneBarButton
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: nil, action: #selector(AddEditItemViewController.cancel))
        navItem.leftBarButtonItem = cancelBarButton
        navigationBar.setItems([navItem], animated: true)
        navigationBar.barTintColor = UIColor.navigationBarColor
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationBar.tintColor = UIColor.white
    }
    
    func updateTableUI() {
        tableView.tableHeaderView = UIView(frame: CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(tableView.bounds.size.width), height: Constants.UIDimentions.NavigationBarHeight))
    }
    
    private func addPadding(textField: UITextField) {
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.UIDimentions.PaddingWidth, height: textField.frame.height))
        textField.leftViewMode = UITextFieldViewMode.always
    }
}
