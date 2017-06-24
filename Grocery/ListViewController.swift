//
//  ListViewController.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-06-13.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, AddEditItemViewControllerDelegate {
    var groceryItems: [GroceryItem]
    let heightOfHeader: CGFloat = 40

    required init?(coder aDecoder: NSCoder) {
        groceryItems = [GroceryItem]()
        
        let row0 = GroceryItem()
        row0.category = "two"
        row0.amount = "111.11"
        row0.name = "A"
        row0.store = "Store"
        groceryItems.append(row0)
        
        let row1 = GroceryItem()
        row1.category = "three"
        row1.amount = "222.22"
        row1.name = "C"
        row1.store = "Store1"
        groceryItems.append(row1)
        
        let row2 = GroceryItem()
        row2.category = "three"
        row2.amount = "222.22"
        row2.name = "C"
        row2.store = "Store1"
        groceryItems.append(row2)
        
        let row3 = GroceryItem()
        row3.category = "three"
        row3.amount = "222.22"
        row3.name = "C"
        row3.store = "Store1"
        groceryItems.append(row3)
       
        let row4 = GroceryItem()
        row4.category = "three"
        row4.amount = "222.22"
        row4.name = "C"
        row4.store = "Store1"
        groceryItems.append(row4)
        
        let row5 = GroceryItem()
        row5.category = "three"
        row5.amount = "222.22"
        row5.name = "C"
        row5.store = "Store1"
        groceryItems.append(row5)
        
        let row6 = GroceryItem()
        row6.category = "three"
        row6.amount = "222.22"
        row6.name = "C"
        row6.store = "Store1"
        groceryItems.append(row6)
        
        let row7 = GroceryItem()
        row7.category = "three"
        row7.amount = "222.22"
        row7.name = "C"
        row7.store = "Store1"
        groceryItems.append(row7)
        
        let row8 = GroceryItem()
        row8.category = "three"
        row8.amount = "222.22"
        row8.name = "C"
        row8.store = "Store1"
        groceryItems.append(row8)
        
        let row9 = GroceryItem()
        row9.category = "three"
        row9.amount = "222.22"
        row9.name = "C"
        row9.store = "Store1"
        groceryItems.append(row9)
        
        let row10 = GroceryItem()
        row10.category = "three"
        row10.amount = "222.22"
        row10.name = "C"
        row10.store = "Store1"
        groceryItems.append(row10)
        
        let row11 = GroceryItem()
        row11.category = "three"
        row11.amount = "222.22"
        row11.name = "C"
        row11.store = "Store1"
        groceryItems.append(row11)
        
        let row12 = GroceryItem()
        row12.category = "three"
        row12.amount = "222.22"
        row12.name = "C"
        row12.store = "Store1"
        groceryItems.append(row12)
        
        let row13 = GroceryItem()
        row13.category = "three"
        row13.amount = "222.22"
        row13.name = "C"
        row13.store = "Store1"
        groceryItems.append(row13)
        
        let row14 = GroceryItem()
        row14.category = "three"
        row14.amount = "222.22"
        row14.name = "C"
        row14.store = "Store1"
        groceryItems.append(row14)
        
        let row15 = GroceryItem()
        row15.category = "three"
        row15.amount = "222.22"
        row15.name = "C"
        row15.store = "Store1"
        groceryItems.append(row15)
        
        let row16 = GroceryItem()
        row16.category = "three"
        row16.amount = "222.22"
        row16.name = "C"
        row16.store = "Store1"
        groceryItems.append(row16)
        
        let row17 = GroceryItem()
        row17.category = "three"
        row17.amount = "222.22"
        row17.name = "C"
        row17.store = "Store1"
        groceryItems.append(row17)
        
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make table cell expand if string is bigger than label size
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = Constants.UIDimentions.EstimatedRowHeightForTableCell
        
        updateScreenUI()
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
            self.updateScreenUI()
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
    
    func updateScreenUI() {
        if groceryItems.count > 0 {
            self.title = String(groceryItems.count) + Constants.Titles.Items
        } else {
            self.title = Constants.Titles.NoItem
        }
    }
    
    // MARK: - IBAction
    
    //MARK: - Add Item View Controller delegate
    func addItemViewController(didFinishAdding item: GroceryItem) {
        let newRowIndex = groceryItems.count
        groceryItems.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        updateScreenUI()
        self.tableView.reloadData()
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
}

