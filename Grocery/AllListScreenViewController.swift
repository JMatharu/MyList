//
//  AllListScreenViewController.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-07-22.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import UIKit
import PMAlertController

class AllListViewController: UITableViewController {
    
    var allListItem: [AllListItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let allItemRow1 = AllListItem()
        allItemRow1.itemName = "Grocery"
        allListItem.append(allItemRow1)
        let allItemRow2 = AllListItem()
        allItemRow2.itemName = "Shopping"
        allListItem.append(allItemRow2)
    }
    
    // MARK: - Button Methods
    
    @IBAction func addItem(_ sender: Any) {
        let alert = PMAlertController(withDescription: Constants.Alert.AddListAlertDescription)
        alert.addTextField { (textField) in
            textField?.placeholder = Constants.Alert.AddListAlertTextViewPlaceHolder
            textField?.becomeFirstResponder()
        }
        alert.addAction(PMAlertAction(title: Constants.Alert.Ok, style: PMAlertActionStyle.default, action: {
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(PMAlertAction(title: "Cancel", style: PMAlertActionStyle.cancel, action: { 
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allListItem.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.AllListViewControllerTableCellIdentifier, for: indexPath)
        let cellLabel = cell.viewWithTag(Constants.Identifiers.AllListLabelTagIdentifier) as! UILabel
        let item = allListItem[indexPath.row]
        cellLabel.text = item.itemName
        return cell
    }
}
