//
//  AllListScreenViewController.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-07-22.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import UIKit
import PMAlertController
import EasyNotificationBadge

private struct AllListConstants {
    static let Item1 = "Grocery"
    static let Item2 = "Shopping"
}

class AllListViewController: UITableViewController, UIAlertViewDelegate {
    
    var allListItem: [AllListItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        let allItemRow1 = AllListItem()
        allItemRow1.itemName = AllListConstants.Item1
        allListItem.append(allItemRow1)
        let allItemRow2 = AllListItem()
        allItemRow2.itemName = AllListConstants.Item2
        allListItem.append(allItemRow2)
        
        super.init(coder: aDecoder)
    }
    
    // MARK: - Button Methods
    @IBAction func addItem(_ sender: Any) {
        let alert = PMAlertController(withDescription: Constants.Alert.AddListAlertDescription)
        alert.addTextField { (textField) in
            textField?.placeholder = Constants.Alert.AddListAlertTextViewPlaceHolder
            textField?.becomeFirstResponder()
        }
        alert.addAction(PMAlertAction(title: Constants.Alert.Ok, style: PMAlertActionStyle.default, action: {
            let textField = alert.textFields.first
            let newItem = AllListItem()
            if let txt = textField?.text {
                if !txt.isEmpty {
                    newItem.itemName = txt
                    self.allListItem.append(newItem)
                    alert.dismiss(animated: true, completion: nil)
                    self.tableView.reloadData()
                    //TODO
                    print("I am Good")
                    alert.dismiss(animated: true, completion: nil)
                } else {
                    print("I am empty")
                    // TODO
                    textField?.placeholder = "jlkajslkaj"
                }
            }
        }))
        alert.addAction(PMAlertAction(title: Constants.Alert.Cancel, style: PMAlertActionStyle.cancel, action: {
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allListItem.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if allListItem[indexPath.row].itemName == AllListConstants.Item1 {
            self.performSegue(withIdentifier: Constants.Segue.GroceryList, sender: nil)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.AllListViewControllerTableCellIdentifier, for: indexPath)
        let cellLabel = cell.viewWithTag(Constants.Identifiers.AllListLabelTagIdentifier) as! UILabel
        let item = allListItem[indexPath.row]
        
        let badgeView = cell.viewWithTag(Constants.Identifiers.AllListBadgeTagIdentifier)!
        BadgeAppearnce().createBadge(badgeView: badgeView, badgeText: "99", badgeColor: UIColor.blue)
        cellLabel.text = item.itemName
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let item = allListItem[indexPath.row]
//        let edit = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: Constants.Identifiers.TableViewRowActionEdit) { (action, indexPath) in
//            let alertEdit = PMAlertController(withDescription: Constants.Alert.AddListAlertEditDescription)
//            alertEdit.addTextField({ (textField) in
//                textField?.becomeFirstResponder()
//                textField?.text = item.itemName
//            })
//            alertEdit.addAction(PMAlertAction(title: Constants.Alert.Ok, style: PMAlertActionStyle.default, action: {
//                let textField = alertEdit.textFields.first
//                if let text = textField?.text {
//                    item.itemName = text
//                }
//                self.dismiss(animated: true, completion: nil)
//                self.tableView.reloadData()
//            }))
//            alertEdit.addAction(PMAlertAction(title: Constants.Alert.Cancel, style: PMAlertActionStyle.cancel, action: { 
//                self.dismiss(animated: true, completion: nil)
//                self.tableView.reloadData()
//            }))
//            self.present(alertEdit, animated: true, completion: nil)
//        }
//        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: Constants.Identifiers.TableViewRowActionDelete) { (action, indexPath) in
//            let alertDelete = PMAlertController(withTitle: Constants.Alert.AddListAlertDeleteTitle, withDescription: Constants.Alert.AddListAlertDeleteDescription)
//            alertDelete.addAction(PMAlertAction(title: Constants.Alert.Ok, style: PMAlertActionStyle.default, action: { 
//                self.allListItem.remove(at: indexPath.row)
//                self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
//            }))
//            alertDelete.addAction(PMAlertAction(title: Constants.Alert.Cancel, style: PMAlertActionStyle.cancel, action: {
//                self.tableView.reloadData()
//            }))
//            self.present(alertDelete, animated: true, completion: nil)
//        }
//        edit.backgroundColor = UIColor.orange
//        delete.backgroundColor = UIColor.red
//        return [edit, delete]
//    }
    
    //MARK: - Methods
}
