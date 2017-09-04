//
//  AddEditItemViewController.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-06-15.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import PMAlertController

struct AddItemVCConstants {
    static let DateFormat = "yyyyMMddHHmmss"
}

protocol AddEditItemViewControllerDelegate: class {
    func addItemViewController(didFinishAdding item: GroceryItem)
    func addItemViewController(didFinishEditing item: GroceryItem)
    func addItemViewControllerDidCancel()
}

class AddEditItemViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var storeName: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    var pickerNameData:[String] = []
    var pickerCategoryData:[String] = []
    var namePicker = UIPickerView()
    var categoryPicker = UIPickerView()
    weak var delegate: AddEditItemViewControllerDelegate?
    var itemToEdit: GroceryItem?
    var parentNode: String = ""
    var tempItemToEdit: [String:GroceryItem?] = [:]
    var fireKey: String = ""
    var editKey: String = ""
    
    override func viewDidLoad() {
        setNavigationBar()
        updateTableUI()
        storeName.becomeFirstResponder()
        loadNameAndCategory()
        setDelegateAndDataSourceForPicker()
        addPaddingOnUITextFields()
        setDataforEditScreen()
    }
 
    // MARK: - IBAction
    func cancel() {
        delegate?.addItemViewControllerDidCancel()
        // If using "Modal" then dismiss
        dismiss(animated: true, completion: nil)
        // If using "show" then popviewcontroller
        // self.navigationController?.popViewController(animated: true)
    }
    
    func done() {
        guard
            let store = storeName.text,
            !store.isEmpty,
            let amo = amount.text,
            !amo.isEmpty,
            let cat = categoryTextField.text,
            !cat.isEmpty,
            let name = nameTextField.text,
            !name.isEmpty
            else {
            let alertVC = PMAlertController(withTitle: Constants.Alert.IncompleteInformationTitle, withDescription: Constants.Alert.IncompleteInformationDescription)
            alertVC.addAction(PMAlertAction(title: Constants.Alert.Ok, style: PMAlertActionStyle.default, action: {
                alertVC.dismiss(animated: true, completion: nil)
            }))
            self.present(alertVC, animated: true, completion: nil)
            return
        }
        
        if let item = itemToEdit {
            item.amount = amount.text!
            item.store = storeName.text!
            item.category = categoryTextField.text!
            item.name = nameTextField.text!
            let dataToBeSavedAfterEdit = [Constants.Firebase.ChildCategory : item.category, Constants.Firebase.ChildName : item.name, Constants.Firebase.ChildAmount : item.amount, Constants.Firebase.ChildStore : item.store, Constants.Firebase.ChildDate : self.getCurrentDateWithTime()]
            FirebaseService().saveEditedGroceryList(key: editKey, parentNode: parentNode, dictionaryOfData: dataToBeSavedAfterEdit)
            delegate?.addItemViewController(didFinishEditing: item)
        } else {
            let item = GroceryItem()
            item.category = categoryTextField.text!
            item.amount = amount.text!
            item.name = nameTextField.text!
            item.store = storeName.text!
            
            //saving data to firebase
            let dataToBeSaved = [Constants.Firebase.ChildCategory : item.category, Constants.Firebase.ChildName : item.name, Constants.Firebase.ChildAmount : item.amount, Constants.Firebase.ChildStore : item.store, Constants.Firebase.ChildDate : self.getCurrentDateWithTime()]
            FirebaseService().saveGroceryList(parentNode:parentNode, dictionaryOfData: dataToBeSaved)
            delegate?.addItemViewController(didFinishAdding: item)
        }
        // If using "Modal" then dismiss
        dismiss(animated: true, completion: nil)
        // If using "show" then popviewcontroller
        // self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    
    //MARK: - Picker Methods
    // returns the number of 'columns' to display.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == namePicker {
            return pickerNameData.count
        } else {
            return pickerCategoryData.count
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == namePicker {
            nameTextField.text = pickerNameData[row]
        } else {
            categoryTextField.text = pickerCategoryData[row]
        }
        self.view.endEditing(false)
    }
    
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == namePicker {
            return pickerNameData[row]
        } else {
            return pickerCategoryData[row]
        }
    }
    
    //MARK: - Methods
    private func addPadding(textField: UITextField) {
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.UIDimentions.PaddingWidth, height: textField.frame.height))
        textField.leftViewMode = UITextFieldViewMode.always
    }
    
    private func setDelegateAndDataSourceForPicker() {
        namePicker.delegate = self
        namePicker.dataSource = self
        nameTextField.inputView = namePicker
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryTextField.inputView = categoryPicker
    }
    
    private func addPaddingOnUITextFields() {
        addPadding(textField: storeName)
        addPadding(textField: amount)
        addPadding(textField: categoryTextField)
        addPadding(textField: nameTextField)
    }
    
    func textFieldIsNotEmpty(sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        guard (storeName.text?.isEmpty)!, (amount.text?.isEmpty)! else {
            doneBarButton.isEnabled = false
            return
        }
        doneBarButton.isEnabled = true
    }
    
    private func setDataforEditScreen() {
        for (key, value) in tempItemToEdit {
            if let item = value {
                title = "Edit Item"
                storeName.text = item.store
                amount.text = item.amount
                categoryTextField.text = item.category
                nameTextField.text = item.name
                doneBarButton.isEnabled = true
            }
            editKey = key
        }
    }
    
    private func setNavigationBar() {
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: Int(Constants.UIDimentions.NavigationBarHeight)))
        self.view.addSubview(navigationBar)
        let navItem: UINavigationItem
        if itemToEdit != nil {
            navItem = UINavigationItem(title: Constants.Titles.EditItem)
        } else {
            navItem = UINavigationItem(title: Constants.Titles.AddItem)
        }
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(AddEditItemViewController.done))
        navItem.rightBarButtonItem = doneBarButton
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: nil, action: #selector(AddEditItemViewController.cancel))
        navItem.leftBarButtonItem = cancelBarButton
        navigationBar.setItems([navItem], animated: true)
        navigationBar.barTintColor = UIColor.navigationBarColor
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationBar.tintColor = UIColor.white
    }
    
    func updateTableUI() {
        tableView.tableHeaderView = UIView(frame: CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(tableView.bounds.size.width), height: Constants.UIDimentions.NavigationBarHeight))
    }
    
    func getCurrentDateWithTime() -> String {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AddItemVCConstants.DateFormat
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        return dateFormatter.string(from: date as Date)
    }
    
    func loadNameAndCategory() {
        NameCategorySharedService.sharedInstance.initializeNamesArray { (nameList) in
            for name in nameList {
                self.pickerNameData.append(name)
            }
            self.pickerNameData.sort(by: <)
        }
        
        NameCategorySharedService.sharedInstance.initializeCategoryArray { (categoryList) in
            for category in categoryList {
                self.pickerCategoryData.append(category)
            }
            self.pickerCategoryData.sort(by: <)
        }
    }
}
