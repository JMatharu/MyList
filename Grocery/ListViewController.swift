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
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make table cell expand if string is bigger than label size
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = Constants.UIDimentions.EstimatedRowHeightForTableCell
        
        updateScreenUI()
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
            guard let addItemViewController = UIStoryboard(name: Constants.Identifiers.MainStoryBoard, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifiers.AddItemStoryBoard) as? AddItemViewController else {
                return
            }
            addItemViewController.itemToEdit = self.groceryItems[indexPath.row]
            self.navigationController?.pushViewController(addItemViewController, animated: true)

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
            self.title = "\(groceryItems.count) Items"
        } else {
            self.title = "No Items in List"
        }
        
    }
    
    // MARK: - IBAction
    
    //MARK: - Add Item View Controller delegate
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: GroceryItem) {
        let newRowIndex = groceryItems.count
        groceryItems.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        updateScreenUI()
        
        dismiss(animated: true, completion: nil)
    }
    
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishEditing item: GroceryItem) {
        if let index = groceryItems.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Identifiers.AddItemSegue {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! AddItemViewController
            controller.delegate = self
        }
    }
}

