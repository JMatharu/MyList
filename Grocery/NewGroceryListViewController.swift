//
//  NewGroceryListViewController.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-07-31.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import UIKit
import KCFloatingActionButton
import PMAlertController
import SwiftSpinner

class NewGroceryListViewController: UITableViewController {

    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    var nameItems: [String] = []
    var tempNameItems: [String] = []
    var categoryItems: [String] = []
    let fabButton = KCFloatingActionButton().createFabButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Enter Name"
        createFABButton()

    }
    
    @IBAction func cancel(_ sender: Any) {
        if isCurrentVCNameVC() {
            if nameItems.count > 0 {
                let alert = PMAlertController.init(withTitle: "Are you sure?", withDescription: "All saved data on this screen will be removed!")
                alert.addAction(PMAlertAction(title: "Ok", style: .default, action: {
                    //Remode all list
                    self.nameItems.removeAll()
                    self.tempNameItems.removeAll()
                    self.categoryItems.removeAll()
                    self.navigationController?.popViewController(animated: true)
                }))
                alert.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: {
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            //Display nameItems data
            nameItems = tempNameItems
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            self.leftBarButton.title = "Cancel"
            self.navigationItem.title = "Enter Name"
        }
    }
    
    @IBAction func done(_ sender: Any) {
        if isCurrentVCNameVC() {
            if nameItems.count < 2 {
                let alert = PMAlertController.init(withTitle: "Enter at least 2 names", withDescription: "Please enter minimum 2 names to start")
                alert.addAction(PMAlertAction(title: "Ok", style: .default, action: { 
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                //refresh table view and title
                tempNameItems = nameItems
                nameItems.removeAll()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                navigationItem.title = "Enter Category"
                leftBarButton.title = "Back"
            }
        } else {
            if categoryItems.count < 1 {
                let alert = PMAlertController.init(withTitle: "Enter at least 1 category", withDescription: "Please enter minimum 1 category to start")
                alert.addAction(PMAlertAction(title: "Ok", style: .default, action: {
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                FirebaseService().saveNameOrCategoryToFirebase(type: "name", textList: tempNameItems)
                FirebaseService().saveNameOrCategoryToFirebase(type: "category", textList: categoryItems)
                //Save this list locally as well
                saveItems(nItems: tempNameItems, cItems: categoryItems)
                tempNameItems.removeAll()
                categoryItems.removeAll()
                self.performSegue(withIdentifier: Constants.Segue.NewToGroceryList, sender: nil)
            }
        }
    }
    
    func isCurrentVCNameVC() -> Bool {
        if navigationItem.title == "Enter Name" {
            return true
        } else {
            return false
        }
    }
    
    func createFABButton() {
//        let fabButton = KCFloatingActionButton().createFabButton()
        let alertTitle = "Enter Item"
        let alertDescription = "For Name: Enter name of person\nFor Category: Enter category like Movies, Grocery, Gas ..."
        fabButton.addItem(Constants.FABButton.AddItem, icon: #imageLiteral(resourceName: "add")) { (fabButtonItem) in
            let alertVC = PMAlertController.init(withTitle: alertTitle, withDescription: alertDescription)
            alertVC.addTextField({ (textField) in
                textField?.becomeFirstResponder()
            })
            alertVC.addAction(PMAlertAction(title: Constants.Alert.Ok, style: PMAlertActionStyle.default, action: {
                let textField = alertVC.textFields[0]
                if let t = textField.text {
                    if self.isCurrentVCNameVC() {
                        self.nameItems.append(t)
                    } else {
                        self.categoryItems.append(t)
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isCurrentVCNameVC() {
            return nameItems.count
        } else {
            return categoryItems.count
        }
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask)
        return paths[0]
    }
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("NameAndCategory.plist")
    }
    
    func saveItems(nItems: [String], cItems:[String]) {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        for index in 0..<nItems.count {
            archiver.encode(nItems[index], forKey: "NameItem\(index)")
        }
        for index in 0..<cItems.count {
            archiver.encode(cItems[index], forKey: "CategoryItems\(index)")
        }
        archiver.encode(nItems.count, forKey: "NameItems")
        archiver.encode(cItems.count, forKey: "CategoryItems")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.NameCell, for: indexPath)
        var item = ""
        if isCurrentVCNameVC() {
            item = nameItems[indexPath.row]
        } else {
            item = categoryItems[indexPath.row]
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
                if !self.nameItems.isEmpty {
                    self.nameItems.remove(at: indexPath.row)
                } else {
                    self.tempNameItems.remove(at: indexPath.row)
                }
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                self.categoryItems.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        let edit = UITableViewRowAction(style: .normal, title: Constants.Identifiers.TableViewRowActionEdit) { (action, index) in
            let editAlert = PMAlertController(withTitle: "Edit Item", withDescription: "You can edit the item")
            editAlert.addTextField({ (textField) in
                textField?.becomeFirstResponder()
                if self.isCurrentVCNameVC() {
                    if !self.nameItems.isEmpty {
                        textField?.text = self.nameItems[indexPath.row]
                    } else {
                        textField?.text = self.tempNameItems[indexPath.row]
                    }
                } else {
                    textField?.text = self.categoryItems[indexPath.row]
                }
            })
            editAlert.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { 
                editAlert.dismiss(animated: true, completion: nil)
            }))
            editAlert.addAction(PMAlertAction(title: "Ok", style: .default, action: {
                let textField = editAlert.textFields[0]
                if let textFieldText = textField.text {
                    if self.isCurrentVCNameVC() {
                        if !self.nameItems.isEmpty {
                            self.nameItems.remove(at: indexPath.row)
                            self.nameItems.insert(textFieldText, at: indexPath.row)
                        } else {
                            self.tempNameItems.remove(at: indexPath.row)
                            self.tempNameItems.insert(textFieldText, at: indexPath.row)
                        }
                    } else {
                        self.categoryItems.remove(at: indexPath.row)
                        self.categoryItems.insert(textFieldText, at: indexPath.row)
                    }
                }
                self.tableView.reloadData()
            }))
            self.present(editAlert, animated: true, completion: nil)
        }
        
        edit.backgroundColor = UIColor.orange
        delete.backgroundColor = UIColor.red
        return [edit, delete]
    }
}
