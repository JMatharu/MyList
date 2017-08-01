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
    var fabButton = KCFloatingActionButton().createFabButton()
    var fabButton2 = KCFloatingActionButton().createFabButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Enter Name"
        createFABButton(type: "name")

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
            self.fabButton2.removeFromSuperview()
            self.leftBarButton.title = "Cancel"
            self.navigationItem.title = "Enter Name"
            self.createFABButton(type: "name")
//            _ = SwiftSpinner.init(title: Constants.Spinner.Title, subTitle: Constants.Spinner.SubTitle)
//            FirebaseService().getNameOrCategoryFromFirebase(completion: { (names) in
//                for name in names {
//                    if name != "" {
//                        self.nameItems.removeAll()
//                        self.nameItems.append(name)
//                        self.tableView.reloadData()
//                    }
//                }
//                self.leftBarButton.title = "Cancel"
//                self.navigationItem.title = "Enter Name"
//                SwiftSpinner.hide()
//            })
            
        }
    }
    
    @IBAction func done(_ sender: Any) {
        if isCurrentVCNameVC() {
            //TODO Chnage back to 2
            if nameItems.count < 0 {
                let alert = PMAlertController.init(withTitle: "Enter at least 2 names", withDescription: "Please enter minimum 2 names to start")
                alert.addAction(PMAlertAction(title: "Ok", style: .default, action: { 
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                for item in nameItems {
                    //Save this locally
//                    FirebaseService().saveNameOrCategoryToFirebase(type: "name", text: item)
                }
                //refresh table view and title
                tempNameItems = nameItems
                nameItems.removeAll()
                fabButton.removeFromSuperview()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                navigationItem.title = "Enter Category"
                leftBarButton.title = "Back"
                createFABButton(type: "Category")
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
    
    func createFABButton(type: String) {
//        let fabButton = KCFloatingActionButton().createFabButton()
        var alertTitle = ""
        var alertDescription = ""
        if type == "name" {
            alertTitle = "Enter Name"
            alertDescription = "Name you would like to enter"
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
        } else {
            alertTitle = "Enter Category"
            alertDescription = "Category you would like to enter"
            fabButton2.addItem(Constants.FABButton.AddItem, icon: #imageLiteral(resourceName: "add")) { (fabButtonItem) in
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
            self.tableView.addSubview(fabButton2)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isCurrentVCNameVC() {
            return nameItems.count
        } else {
            return categoryItems.count
        }
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
}
