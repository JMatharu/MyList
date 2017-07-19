//
//  ListViewController.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-06-13.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftSpinner

class ListViewController: UITableViewController, AddEditItemViewControllerDelegate {
    var groceryItems: [GroceryItem] = []
    var groceryItemKeys: [String] = []
    var groceryItemUpdateKeys: [String] = []
    let heightOfHeader: CGFloat = 40
    var firebaseReference: FIRDatabaseReference?
    var dataBaseHandler: FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make table cell expand if string is bigger than label size
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = Constants.UIDimentions.EstimatedRowHeightForTableCell
        
        // Firebase reference
        firebaseReference = FIRDatabase.database().reference()
        
        updateDataSourceWithItemsFromFireBase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.setHidesBackButton(true, animated: false)
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
            //self.firebaseReference = FIRDatabase.database().reference()
            self.firebaseReference?.child(Constants.Firebase.ParentGroceryRoot).child(self.groceryItemKeys[indexPath.row]).removeValue()
            
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
        let storeLabel = cell.viewWithTag(Constants.Identifiers.StoreIdentifier) as! UILabel
        let categoryLabel = cell.viewWithTag(Constants.Identifiers.CategoryIdentifier) as! UILabel
        let nameLabel = cell.viewWithTag(Constants.Identifiers.NameIdentifier) as! UILabel
        let amountLabel = cell.viewWithTag(Constants.Identifiers.AmountIdentifier) as! UILabel
        
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
        SwiftSpinner.setTitleFont(UIFont.spinnerFont)
        SwiftSpinner.show(Constants.Spinner.Title).addTapHandler({
            SwiftSpinner.hide()
        }, subtitle: Constants.Spinner.SubTitle)
        
        firebaseReference?.child(Constants.Firebase.ParentGroceryRoot).observeSingleEvent(of: .value, with: { (snapshot) in
            // This code block is async block
            if snapshot.childrenCount == 0 {
                SwiftSpinner.hide()
                return
            } else {
                guard let snap = snapshot.value as? NSDictionary else {
                    return
                }
                
                for (key, value) in snap {
                    if let item = value as? NSDictionary {
                        let firebaseRow = GroceryItem()
                        firebaseRow.amount = self.getFirebaseChildValueWithKey(Constants.Firebase.ChildAmount, withDictionary: item)
                        firebaseRow.category = self.getFirebaseChildValueWithKey(Constants.Firebase.ChildCategory, withDictionary: item)
                        firebaseRow.name = self.getFirebaseChildValueWithKey(Constants.Firebase.ChildName, withDictionary: item)
                        firebaseRow.store = self.getFirebaseChildValueWithKey(Constants.Firebase.ChildStore, withDictionary: item)
                        self.groceryItems.append(firebaseRow)
                    }
                    if let key = key as? String {
                        // Save keys to groceryItemKeys array
                        self.groceryItemKeys.append(key)
                    }
                }
            }
            //Reload table after getting the new item from firebase cloud
            self.tableView.reloadData()
            //Update title depending on items in datasource
            self.updateTitle()
            //Stop Spinner
            SwiftSpinner.hide()
        })
    }
    
    func updateDataSourceWithNewItemFromFireBase() {
        // Spinner
        SwiftSpinner.setTitleFont(UIFont.spinnerFont)
        SwiftSpinner.show(Constants.Spinner.Title).addTapHandler({
            SwiftSpinner.hide()
        })
        
        firebaseReference?.child(Constants.Firebase.ParentGroceryRoot).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            guard let snap = snapshot.value as? NSDictionary else {
                return
            }
            
            for(key, _) in snap {
                if let key = key as? String {
                    self.groceryItemUpdateKeys.append(key)
                }
            }
            
            let newElementCount = self.groceryItemUpdateKeys.sorted().count - self.groceryItemKeys.sorted().count
            if newElementCount > 0 {
                // get difference , and get thoes element
                let updatedListCount = self.groceryItemUpdateKeys.sorted().count
                for newItemReverseIndex in 1...newElementCount {
                    self.groceryItemKeys.append(self.groceryItemUpdateKeys.sorted()[updatedListCount - newItemReverseIndex])
                    self.firebaseReference?.child(Constants.Firebase.ParentGroceryRoot).child(self.groceryItemUpdateKeys.sorted()[updatedListCount - newItemReverseIndex]).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshotInner) in
                        guard let snapInner = snapshotInner.value as? NSDictionary else {
                            return
                        }
                        
                        let firebaseRow = GroceryItem()
                        firebaseRow.amount = self.getFirebaseChildValueWithKey(Constants.Firebase.ChildAmount, withDictionary: snapInner)
                        firebaseRow.category = self.getFirebaseChildValueWithKey(Constants.Firebase.ChildCategory, withDictionary: snapInner)
                        firebaseRow.name = self.getFirebaseChildValueWithKey(Constants.Firebase.ChildName, withDictionary: snapInner)
                        firebaseRow.store = self.getFirebaseChildValueWithKey(Constants.Firebase.ChildStore, withDictionary: snapInner)
                        self.groceryItems.append(firebaseRow)
                        
                        self.tableView.reloadData()
                        self.updateTitle()
                        SwiftSpinner.hide()
                    })
                }
            }
            self.groceryItemUpdateKeys.removeAll()
        })
    }
}

