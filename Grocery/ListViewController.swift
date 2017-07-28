//
//  ListViewController.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-06-13.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import UIKit
import SwiftSpinner
import KCFloatingActionButton

class ListViewController: UITableViewController, AddEditItemViewControllerDelegate {
    var groceryItems: [GroceryItem] = []
    var groceryItemKeys: [String] = []
    var groceryItemUpdateKeys: [String] = []
    let heightOfHeader: CGFloat = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create FAB button
        createFABButton()
        
        // Make table cell expand if string is bigger than label size
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = Constants.UIDimentions.EstimatedRowHeightForTableCell
        
        updateDataSourceWithItemsFromFireBase()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.ListViewControllerTableCellIdentifier, for: indexPath)
        
        let item = groceryItems[indexPath.row]
        configureText(for: cell, with: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: Constants.Identifiers.TableViewRowActionEdit, handler: {
            action, index in
            self.performSegue(withIdentifier: Constants.Segue.AddItem, sender: self.groceryItemKeys[indexPath.row])
        })
        let delete = UITableViewRowAction(style: .normal, title: Constants.Identifiers.TableViewRowActionDelete, handler: {
            action, index in
            self.groceryItems.remove(at: indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
            self.updateTitle()
            
            //Delete from firebase
            FirebaseService().removeItemFrmFirebase(modalName: Constants.Feature.Grocery, itemKeys: self.groceryItemKeys, index: indexPath.row)
            
            // Delete from local array
            self.groceryItemKeys.remove(at: indexPath.row)
        })
        edit.backgroundColor = UIColor.orange
        delete.backgroundColor = UIColor.red
        return [edit, delete]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightOfHeader
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed(Constants.XIB.GroceryTableHeader, owner: self, options: nil)?.first as! GroceryTableHeader
        return headerView.contentView
    }
    
    // MARK: - Methods
    func configureText(for cell: UITableViewCell, with item: GroceryItem) {
        let storeLabel = cell.viewWithTag(Constants.Identifiers.StoreTagIdentifier) as! UILabel
        let categoryLabel = cell.viewWithTag(Constants.Identifiers.CategoryTagIdentifier) as! UILabel
        let nameLabel = cell.viewWithTag(Constants.Identifiers.NameTagIdentifier) as! UILabel
        let amountLabel = cell.viewWithTag(Constants.Identifiers.AmountTagIdentifier) as! UILabel
        
        storeLabel.text = item.store
        categoryLabel.text = item.category
        nameLabel.text = item.name
        amountLabel.text = item.amount
    }
    
    func updateTitle() {
        if groceryItems.count > 0 {
            self.title = String(groceryItems.count) + Constants.Titles.Items
        } else {
            self.title = Constants.Titles.NoItem
        }
    }
    
    func createFABButton() {
        let floaty = KCFloatingActionButton()
        floaty.sticky = true
        floaty.openAnimationType = .slideLeft
        floaty.buttonColor = UIColor.FabButtonColor
        floaty.itemButtonColor = UIColor.FabButtonSecendoryColor
        floaty.itemTitleColor = UIColor.FabButtonItemTitleColor
        floaty.itemShadowColor = UIColor.clear
        floaty.addItem(Constants.FABButton.AddItem, icon: #imageLiteral(resourceName: "add")) { (fabButtonItem) in
            self.performSegue(withIdentifier: Constants.Segue.AddItem, sender: nil)
        }
        floaty.addItem(Constants.FABButton.CalculateItem, icon: #imageLiteral(resourceName: "calculate")) { (fabButtonItem) in
            
        }
        
        floaty.buttonImage = #imageLiteral(resourceName: "addItem")
        self.view.addSubview(floaty)
    }
    
    //MARK: - Add Item View Controller delegate
    func addItemViewController(didFinishAdding item: GroceryItem) {
      updateDataSourceWithNewItemFromFireBase()
    }
    
    func addItemViewControllerDidCancel() {
        self.tableView.reloadData()
    }
    
    func addItemViewController(didFinishEditing item: GroceryItem) {
        if let index = groceryItems.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        self.tableView.reloadData()
    }
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Identifiers.AddItemSegue {
            let controller = segue.destination as! AddEditItemViewController
            controller.delegate = self
            controller.itemToEdit = sender as? GroceryItem
        }
    }
    
    // MARK: - Firebase
    func getFirebaseChildValueWithKey(_ key: String, withDictionary items: NSDictionary) -> String {
        var childItem = ""
        if let item = items.value(forKey: key) as? String {
            childItem = item
        }
        return childItem
    }
    
    func updateDataSourceWithItemsFromFireBase() {
        
        // Spinner
        _ = SwiftSpinner.init(title: Constants.Spinner.Title, subTitle: Constants.Spinner.SubTitle)
        
        // Get all items from service level
        FirebaseService().getAllDataInSingleEvent(modalName: Constants.Feature.Grocery) { (groceryItem, groceryItemKeys) in
            self.groceryItems = groceryItem
            self.groceryItemKeys = groceryItemKeys
            
            // Sorting groceryItem array by timestamp
            self.groceryItems.sort(by: { Int($0.0.timestamp)! < Int($0.1.timestamp)!})
            //Reload table after getting the new item from firebase cloud
            self.tableView.reloadData()
            //Update title depending on items in datasource
            self.updateTitle()
            //Stop Spinner
            SwiftSpinner.hide()
        }
}
    
    func updateDataSourceWithNewItemFromFireBase() {
        // Spinner
        _ = SwiftSpinner.init(title: Constants.Spinner.TitleAfterUpdate)
        
        FirebaseService().getUpdatedDataInSingleEvent(modalName: Constants.Feature.Grocery, itemsKeys: self.groceryItemKeys) { (gItems, gItemsKeys) in
            self.groceryItems.append(contentsOf: gItems)
            self.groceryItemKeys.append(contentsOf: gItemsKeys)
            self.tableView.reloadData()
            self.updateTitle()
            SwiftSpinner.hide()
        }

    }
}

