//
//  NameCategoryListViewController.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-08-07.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import UIKit
import KCFloatingActionButton
import PMAlertController
import SwiftSpinner

class NameCategoryListViewController: UITableViewController {
    
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    var nameValue:[String] = []
    var nameKeys:[String] = []
    var nameDictionary:[String:String] = [:]
    var initialDictionaryKeys:[String] = []
    
    var nameInitialValue:[String] = []
    var nameInitialKeys:[String] = []
    var nameInitialDictionary:[String:String] = [:]
    
    var catValue:[String] = []
    var catKeys:[String] = []
    var catDictionary:[String:String] = [:]
    var initialCatDictionaryKeys:[String] = []
    
    override func viewDidLoad() {
        navigationItem.title = "Enter Name"
        createFABButton()
        updateListFromFirebase()
    }
    
    //MARK: - Table Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isCurrentVCNameVC() {
            return nameValue.count
        } else {
            return catValue.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.NameCell, for: indexPath)
        var item = ""
        if isCurrentVCNameVC() {
            item = nameValue[indexPath.row]
        } else {
            item = catValue[indexPath.row]
        }
        let label = cell.viewWithTag(Constants.Identifiers.NameListTagIdentifier) as! UILabel
        label.text = item
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: Constants.Identifiers.TableViewRowActionDelete) { (action, index) in
            if self.isCurrentVCNameVC() {
                self.nameValue.remove(at: index.row)
                self.nameDictionary.removeValue(forKey: self.nameKeys[index.row])
                self.nameKeys.remove(at: index.row)
            } else {
                self.catValue.remove(at: index.row)
                self.catDictionary.removeValue(forKey: self.catKeys[index.row])
                self.catKeys.remove(at: index.row)
            }
            self.tableView.reloadData()
        }
        delete.backgroundColor = UIColor.red
        return [delete]
    }
    
    //MARK: - IBAction
    @IBAction func done(_ sender: Any) {
        if initialDictionaryKeys.count > nameDictionary.count {
            print("Something is removed")
        } else if initialDictionaryKeys.count < nameDictionary.count {
            print("Something is added")
        } else if initialDictionaryKeys.count == nameDictionary.count {
            print("All same")
        }
        
        if isCurrentVCNameVC() {
            if self.nameDictionary.count < 2 {
                let alert = PMAlertController.init(withTitle: "Enter at least 2 names", withDescription: "Please enter minimum 2 names to start")
                alert.addAction(PMAlertAction(title: "Ok", style: .default, action: {
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                //refresh table view and title
                FirebaseService().saveNameOrCategoryToFirebase(type: "name", textList: self.nameDictionary)
                self.initialDictionaryKeys.removeAll()
                self.initialDictionaryKeys = self.nameKeys
                nameValue.removeAll()
                nameDictionary.removeAll()
                nameKeys.removeAll()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                navigationItem.title = "Category Item"
                leftBarButton.title = "Back"
            }
        } else {
            if self.catDictionary.count < 1 {
                let alert = PMAlertController.init(withTitle: "Enter at least 1 category", withDescription: "Please enter minimum 1 category to start like Movies, Grocery, Gas ...")
                alert.addAction(PMAlertAction(title: "Ok", style: .default, action: {
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                //refresh table view and title
                FirebaseService().saveNameOrCategoryToFirebase(type: "category", textList: self.catDictionary)
                self.initialCatDictionaryKeys.removeAll()
                self.initialCatDictionaryKeys = self.catKeys
                catValue.removeAll()
                catDictionary.removeAll()
                catKeys.removeAll()
                self.performSegue(withIdentifier: Constants.Segue.NewToGroceryList, sender: nil)
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        if isCurrentVCNameVC() {
            var isNewItemAdded:Bool = false
            var isItemDeleted:Bool = false
            for itemKey in nameKeys {
                if !initialDictionaryKeys.contains(itemKey) {
                    isNewItemAdded = true
                }
            }
            
            if initialDictionaryKeys.count > nameKeys.count {
                isItemDeleted = true
            }
            
            if isNewItemAdded || isItemDeleted {
                let alert = PMAlertController.init(withTitle: "Are you sure?", withDescription: "All added/removed items will not be saved permanently!\nPress 'Ok' to save changes and exit!\nPress 'Cancel' to not save changes and exit!\nPress 'Dismiss' to dismiss alert")
                alert.addAction(PMAlertAction(title: "Ok", style: .default, action: {
                    self.navigationController?.popViewController(animated: true)
                    FirebaseService().saveNameOrCategoryToFirebase(type: "name", textList: self.nameDictionary)
                }))
                alert.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: {
                    alert.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                }))
                alert.addAction(PMAlertAction(title: "Dismiss", style: .cancel, action: {
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            updateListFromFirebase()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            self.leftBarButton.title = "Cancel"
            self.navigationItem.title = "Enter Name"
        }
    }
    
    //MARK: - Methods
    private func createFABButton() {
        let fabButton = KCFloatingActionButton().createFabButton()
        let alertTitle = "Enter Information"
        fabButton.addItem(Constants.FABButton.AddItem, icon: #imageLiteral(resourceName: "add")) { (fabButtonItem) in
            let alertVC = PMAlertController.init(withTitle: alertTitle, withDescription: "")
            alertVC.addTextField({ (textField) in
                textField?.becomeFirstResponder()
            })
            alertVC.addTextField({ (initialTextField) in
                
            })
            if self.isCurrentVCNameVC() {
                alertVC.textFields[0].placeholder = "Enter Name"
                alertVC.textFields[1].placeholder = "Enter Name Initials"
            } else {
                alertVC.textFields[0].placeholder = "Enter Category"
                alertVC.textFields[1].isHidden = true
            }
            alertVC.addAction(PMAlertAction(title: Constants.Alert.Ok, style: PMAlertActionStyle.default, action: {
                let textField = alertVC.textFields[0]
                let initialTextField = alertVC.textFields[1]
                var isFirstTextFieldEmpty:Bool = true
                if let t = textField.text {
                    if !(t == "") {
                        isFirstTextFieldEmpty = false
                        if self.isCurrentVCNameVC() {
                            self.nameDictionary[String(self.nameValue.count)] = t
                            self.nameKeys.append(String(self.nameValue.count))
                            self.nameValue.append(t)
                        } else {
                            self.catDictionary[String(self.catValue.count)] = t
                            self.catKeys.append(String(self.catValue.count))
                            self.catValue.append(t)
                        }
                    }
                }
                if let nameInitials = initialTextField.text {
                    if !(nameInitials == "" && isFirstTextFieldEmpty) {
                        self.nameInitialDictionary[textField.text!] = nameInitials
                        self.nameInitialKeys.append(String(self.nameInitialValue.count))
                        self.nameInitialValue.append(nameInitials)
                    }
                }
                alertVC.dismiss(animated: true, completion: nil)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }))
            alertVC.addAction(PMAlertAction(title: Constants.Alert.Cancel, style: PMAlertActionStyle.default, action: {
                alertVC.dismiss(animated: true, completion: nil)
            }))
            self.present(alertVC, animated: true, completion: nil)
        }
        self.tableView.addSubview(fabButton)
    }

    private func updateListFromFirebase() {
        // Spinner
        _ = SwiftSpinner.init(title: Constants.Spinner.Title, subTitle: Constants.Spinner.SubTitle)
        FirebaseService().getNameOrCategoryFromFirebase(type: "name") { (nameDictionary) in
            for(key, value) in nameDictionary {
                if !(key == "" && value == "") {
                    self.nameDictionary = nameDictionary
                    self.nameValue.append(value)
                    self.nameKeys.append(key)
                    self.initialDictionaryKeys.append(key)
                }
            }
            self.tableView.reloadData()
            SwiftSpinner.hide()
        }
        FirebaseService().getNameOrCategoryFromFirebase(type: "category") { (catDictionary) in
            for(key, value) in catDictionary {
                if !(key == "" && value == "") {
                    self.catDictionary = catDictionary
                    self.catValue.append(value)
                    self.catKeys.append(key)
                    self.initialCatDictionaryKeys.append(key)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    private func isCurrentVCNameVC() -> Bool {
        if navigationItem.title == "Enter Name" {
            return true
        } else {
            return false
        }
    }
}
