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
import SwiftSpinner

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
        
        //Get child number of parent node
         _ = SwiftSpinner.init(title: Constants.Spinner.Title, subTitle: Constants.Spinner.SubTitle)
        FirebaseService().getBadgeCount(closure: { (badgeCount) in
            _ = BadgeAppearnce.init(badgeView: badgeView, badgeText: String(badgeCount), badgeColor: UIColor.blue)
            SwiftSpinner.hide()
        })
        
        cellLabel.text = item.itemName
        return cell
    }
    
    //MARK: - Methods
}
