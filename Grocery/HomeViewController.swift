//
//  HomeViewController.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-08-13.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import Foundation
import UIKit
import PMAlertController

class HomeViewController: UITableViewController {
    
    @IBOutlet weak var addItem: UINavigationItem!
    var homeItems: [HomeModal] = []
    var homeItemsKeys: [String] = []
    
    override func viewDidLoad() {
        self.title = "Home List"
        
        FirebaseService().getHomeListItems { (keys, items) in
            self.homeItems = items
            self.homeItemsKeys = keys
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.HomeListViewControllerTableCellIdentifier, for: indexPath)
        cell.textLabel?.text = homeItems[indexPath.row].itemName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeItems.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "mainListToGroceryList", sender: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let rename = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Rename") { (action, indexPath) in
            // Rename Name of list
        }
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete") { (action, indexPath) in
            let alert = PMAlertController(withTitle: "Are you sure?", withDescription: "This action will Delete current list and its child items!")
            alert.addAction(PMAlertAction(title: "Cancel", style: PMAlertActionStyle.cancel, action: { 
                alert.dismiss(animated: true, completion: nil)
                self.tableView.reloadData()
            }))
            alert.addAction(PMAlertAction(title: "Ok", style: PMAlertActionStyle.default, action: { 
               // remove all nodes
                FirebaseService().deleteHomeListAndItsChildNode(parentNode: self.homeItems[indexPath.row].itemName, itemKey: self.homeItemsKeys[indexPath.row])
                self.homeItemsKeys.remove(at: indexPath.row)
                self.homeItems.remove(at: indexPath.row)
                self.tableView.reloadData()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        return [delete]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainListToGroceryList" {
            let controller = segue.destination as! ListViewController
            if let index = sender as? Int {
                controller.navTitle = homeItems[index].itemName
            }
        }
    }
    
    @IBAction func addItem(_ sender: Any) {
        let alert = PMAlertController(withTitle: "Enter List name", withDescription: "For eg. July List, January List etc..")
        alert.addTextField { (textField) in
            textField?.becomeFirstResponder()
        }
        alert.addAction(PMAlertAction.init(title: "Ok", style: PMAlertActionStyle.default, action: {
            if let text = alert.textFields[0].text {
                if !text.isEmpty {
                    let homeItem = HomeModal()
                    homeItem.itemName = text
                    self.homeItems.append(homeItem)
                    FirebaseService().saveHomeList(item: homeItem.itemName)
                }
            }
            self.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(PMAlertAction.init(title: "Cancel", style: .cancel, action: { 
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
