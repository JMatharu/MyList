//
//  ListViewController.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-06-13.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ListViewController: UITableViewController, AddEditItemViewControllerDelegate {
    var groceryItems: [GroceryItem] = []
    let heightOfHeader: CGFloat = 40
    var firebaseReference: FIRDatabaseReference?
    var dataBaseHandler: FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make table cell expand if string is bigger than label size
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = Constants.UIDimentions.EstimatedRowHeightForTableCell
        updateDataSourceWithNewItemFromFireBase()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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
            self.performSegue(withIdentifier: Constants.Segue.AddItem, sender: self.groceryItems[indexPath.row])
        })
        let delete = UITableViewRowAction(style: .normal, title: Constants.Identifiers.TableViewRowActionDelete, handler: {
            action, index in
            self.groceryItems.remove(at: indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
            self.updateTitle()
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
        let headerView = Bundle.main.loadNibNamed("GroceryTableHeader", owner: self, options: nil)?.first as! GroceryTableHeader
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
    
    // MARK: - IBAction
    
    //MARK: - Add Item View Controller delegate
    func addItemViewController(didFinishAdding item: GroceryItem) {
        
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
    
    func updateDataSourceWithNewItemFromFireBase() {
        //Firebase
        firebaseReference = FIRDatabase.database().reference()
        dataBaseHandler = firebaseReference?.child(Constants.Firebase.ParentGroceryRoot).observe(.childAdded, with: { (snapshot) in
            if let item = snapshot.value as? NSDictionary {
                let firebaseRow = GroceryItem()
                firebaseRow.amount = self.getFirebaseChildValueWithKey(Constants.Firebase.ChildAmount, withDictionary: item)
                firebaseRow.category = self.getFirebaseChildValueWithKey(Constants.Firebase.ChildCategory, withDictionary: item)
                firebaseRow.name = self.getFirebaseChildValueWithKey(Constants.Firebase.ChildName, withDictionary: item)
                firebaseRow.store = self.getFirebaseChildValueWithKey(Constants.Firebase.ChildStore, withDictionary: item)
                self.groceryItems.append(firebaseRow)
            }
            //Reload table after getting the new item from firebase cloud
            self.tableView.reloadData()
            //Update title depending on items in datasource
            self.updateTitle()
        })
    }
}

