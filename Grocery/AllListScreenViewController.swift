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
    var itemBadgeCountDict: [String:UInt] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print(itemBadgeCountDict)
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
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allListItem.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if allListItem[indexPath.row].itemName == AllListConstants.Item1 {
            if itemBadgeCountDict[AllListConstants.Item1] == 0 {
                self.performSegue(withIdentifier: Constants.Segue.NewGroceryListIdentifier, sender: nil)
            } else {
                self.performSegue(withIdentifier: Constants.Segue.GroceryList, sender: nil)
            }
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
        
        // Update Badge count from retrieving value from service layer
        switch item.itemName {
        case Constants.Feature.Grocery:
            FirebaseService().getBadgeCount(modalName: Constants.Feature.Grocery,completion: { (badgeCount) in
                self.setBadge(badgeView: badgeView, badgeCount: badgeCount)
                self.itemBadgeCountDict[AllListConstants.Item1] = badgeCount
            })
        case Constants.Feature.Shopping:
            FirebaseService().getBadgeCount(modalName: Constants.Feature.Shopping,completion: { (badgeCount) in
                self.setBadge(badgeView: badgeView, badgeCount: badgeCount)
                self.itemBadgeCountDict[AllListConstants.Item2] = badgeCount
            })
        default:
            print("Selected feature is not valid")
        }
        
        cellLabel.text = item.itemName
        return cell
    }
    
    //MARK: - Methods
    func setBadge(badgeView:UIView, badgeCount:UInt) {
        if badgeCount == 0 {
            _ = BadgeAppearnce.init(badgeView: badgeView, badgeText: String(badgeCount), badgeColor: UIColor.red)
        } else {
            _ = BadgeAppearnce.init(badgeView: badgeView, badgeText: String(badgeCount), badgeColor: UIColor.blue)
        }
        //TODO: - Need to change this logic
        SwiftSpinner.hide()
    }
}
